import gi
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk
from fabric import Application
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.utils import get_relative_path, monitor_file
from modules._datetime import datetime
from modules._powerbutton import powerbutton
from modules._bluetooth import bluetooth
from modules._workspaces import workspaces
from modules._activewindow import activewindow
from modules._audio import audio
from modules._network import network
from modules._notifications import notifications

class Bar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="top",
            exclusivity="auto",
            **kwargs
        )

        #Get display size 
        screen = Gdk.Screen.get_default()
        monitor_num = screen.get_primary_monitor()
        geometry = screen.get_monitor_geometry(monitor_num)
        monitor_width_px = geometry.width
        
        #Set bar width based on monitor
        bar_width = int(monitor_width_px * 0.60)
        bar_height = 30
        self.set_size_request(bar_width, bar_height)

        #Check if monitors changed or disconnect
        screen.connect("monitors-changed", self.on_monitors_changed)

        self.children = CenterBox(
            start_children=[powerbutton, activewindow],
            center_children=[workspaces],
            end_children=[datetime, audio, bluetooth, network, notifications],
        )   
    
    def on_monitors_changed(self, screen):
        self.show_all()
       

if __name__ == "__main__":
    bar = Bar()
    app = Application("MenuBar", bar)
    app.set_stylesheet_from_file("./styles/default.css")

    def apply_stylesheet(*_):
        return app.set_stylesheet_from_file(
            get_relative_path("./styles/default.css")
        )

    style_monitor = monitor_file(get_relative_path("./styles/default.css"))
    style_monitor.connect("changed", apply_stylesheet)
    apply_stylesheet()

    app.run()
