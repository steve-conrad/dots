import fabric
import subprocess
import os
import gi
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk
from fabric import Application
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.button import Button
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.utils import get_relative_path, monitor_file
from fabric.hyprland.widgets import (
        Language,
        WorkspaceButton,
        Workspaces,
        get_hyprland_connection,
        ActiveWindow,
)

class Bar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="top",
            exclusivity="auto",
            **kwargs
        )
       
        screen = Gdk.Screen.get_default()        
        monitor_num = screen.get_primary_monitor()
        geometry = screen.get_monitor_geometry(monitor_num)
        monitor_width_px = geometry.width

        bar_width = int(monitor_width_px * 0.60)
        bar_height = 30
        self.set_size_request(bar_width, bar_height)

        self.power_button = Button(
            label=" ",
            name="power-button"
        )
        self.power_button.connect("clicked", self.run_power_menu_script)

        self.date_time = DateTime(
            name="date-time"
        )

        self.workspaces = Workspaces(
            name="workspaces"
        )

        self.active_window = ActiveWindow(
            name="active-window"
        )

        self.audio = Button(
            label=" ",
            name="audio-button"
        )
        self.audio.connect("clicked", lambda *args: subprocess.Popen("pavucontrol"))

        self.bluetooth = Button(
            label=" ",
            name="bluetooth-button"
        )
        self.bluetooth.connect("clicked", self.run_bluetooth_script)

        self.network = Button(
            label=" ",
            name="network-button"
        )
        self.network.connect("clicked", lambda *args: subprocess.Popen("nm-connection-editor"))

        self.notifications = Button(
            label=" ",
            name="notifications-button"
        )
        self.notifications.connect("clicked", lambda *args: subprocess.Popen(["swaync-client", "-t", "-sw"]))

        self.children = CenterBox(
            start_children=[self.power_button, self.active_window],
            center_children=[self.workspaces],
            end_children=[self.date_time, self.audio, self.bluetooth, self.network, self.notifications],
        )   

    def run_power_menu_script(self, *args):
        script_path = os.path.expandvars(
          "$HOME/.config/hyprnosis/configs/waybar/scripts/power_menu.sh"
        )
        subprocess.Popen([script_path])

    def run_bluetooth_script(self, *args):
        script_path = os.path.expandvars(
            "$HOME/.config/hyprnosis/modules/bluetooth.sh"
        )
        subprocess.Popen([script_path]) 
       

if __name__ == "__main__":
    bar = Bar()
    app = Application("MenuBar", bar)
    app.set_stylesheet_from_file("./styles/bar.css")

    def apply_stylesheet(*_):
        return app.set_stylesheet_from_file(
            get_relative_path("./styles/bar.css")
        )

    style_monitor = monitor_file(get_relative_path("./styles/bar.css"))
    style_monitor.connect("changed", apply_stylesheet)
    apply_stylesheet()

    app.run()
