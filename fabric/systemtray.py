import logging
from gi.repository import Gdk, GdkPixbuf, GLib, Gtk

from fabric.widgets.box import Box

logger = logging.getLogger(__name__)

class SystemTray(Box):
    def __init__(self, pixel_size: int = 20, refresh_interval: int = 1, **kwargs) -> None:
        super().__init__(
            name="systray",
            orientation=Gtk.Orientation.HORIZONTAL,
            spacing=8,
            **kwargs
        )
        self.enabled = True
        self.pixel_size = pixel_size
        self.refresh_interval = refresh_interval

        # Placeholder buttons for testing
        self._add_placeholder_buttons()

    def _add_placeholder_buttons(self):
        for i in range(3):  # Add 3 dummy buttons for now
            btn = Gtk.Button()
            icon = Gtk.Image.new_from_icon_name("folder", Gtk.IconSize.BUTTON)
            btn.set_image(icon)
            btn.set_tooltip_text(f"Dummy Tray Icon {i+1}")
            self.add(btn)
            btn.show()

    def set_visible(self, visible: bool):
        self.enabled = visible
        self._update_visibility()

    def _update_visibility(self):
        has = len(self.get_children()) > 0
        super().set_visible(self.enabled and has)

