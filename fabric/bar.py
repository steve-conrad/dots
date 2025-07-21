import fabric
import subprocess
import os
from fabric import Application
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.widgets.label import Label
from fabric.utils import get_relative_path, monitor_file
from fabric.audio import Audio
from gi.repository import Gdk
from modules.power_menu import PowerMenu
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

        default_bar_size = (1400, 30)
        self.set_size_request(*default_bar_size)

        self.power_button = Button (
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
        self.audio_button = Audio(
        )

        self.children = CenterBox(
            start_children=[self.power_button, self.date_time],
            center_children=[self.workspaces],
            end_children=[self.active_window],
        )   

    def run_power_menu_script(self, *args):
        script_path = os.path.expandvars(
          "$HOME/.config/hyprnosis/configs/waybar/scripts/power_menu.sh"
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
    apply_stylesheet() # initial styling

    app.run()
