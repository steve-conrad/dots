from dbus_next.aio import MessageBus
from dbus_next.constants import BusType
from dbus_next import Variant
import asyncio

MPRIS_PREFIX = "org.mpris.MediaPlayer2."

class MediaController:
    def __init__(self):
        self.bus = None
        self.player = None
        self.props = None
        self.player_name = None

    async def connect(self):
        # Connect to the session bus
        self.bus = await MessageBus(bus_type=BusType.SESSION).connect()

        # Get all available MPRIS players
        names = await self._get_mpris_players()
        if not names:
            raise RuntimeError("No MPRIS-compatible players found.")

        # Pick the first available player
        self.player_name = names[0]
        introspection = await self.bus.introspect(self.player_name, "/org/mpris/MediaPlayer2")
        obj = self.bus.get_proxy_object(self.player_name, "/org/mpris/MediaPlayer2", introspection)

        # Get player and properties interfaces
        self.player = obj.get_interface("org.mpris.MediaPlayer2.Player")
        self.props = obj.get_interface("org.freedesktop.DBus.Properties")

    async def _get_mpris_players(self):
        introspection = await self.bus.introspect("org.freedesktop.DBus", "/org/freedesktop/DBus")
        dbus_obj = self.bus.get_proxy_object("org.freedesktop.DBus", "/org/freedesktop/DBus", introspection)
        iface = dbus_obj.get_interface("org.freedesktop.DBus")

        names = await iface.call_list_names()
        return [name for name in names if name.startswith(MPRIS_PREFIX)]

    async def get_metadata(self):
        if not self.props:
            return None

        metadata = await self.props.call_get("org.mpris.MediaPlayer2.Player", "Metadata")
        return {
            "title": metadata.get("xesam:title", Variant("s", "")).value,
            "artist": ", ".join(metadata.get("xesam:artist", Variant("as", [])).value),
            "album": metadata.get("xesam:album", Variant("s", "")).value,
            "art_url": metadata.get("mpris:artUrl", Variant("s", "")).value,
        }

    async def play(self):
        await self.player.call_play()

    async def pause(self):
        await self.player.call_pause()

    async def play_pause(self):
        await self.player.call_play_pause()

    async def next(self):
        await self.player.call_next()

    async def previous(self):
        await self.player.call_previous()

# Test it manually
if __name__ == "__main__":
    async def test():
        mc = MediaController()
        await mc.connect()
        data = await mc.get_metadata()
        print("Now Playing:")
        print(data)

    asyncio.run(test())

