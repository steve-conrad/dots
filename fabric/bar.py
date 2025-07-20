import fabric
from fabric import Application
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.box import Box
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import (
        Language,
        WorkspaceButton,
        Workspaces,
        get_hyprland_connection,
)

from systemtray import SystemTray

class Bar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            **kwargs
        )

        self.systray = SystemTray()
        self.date_time = DateTime()
        self.workspaces = Workspaces(
            connection=get_hyprland_connection(),
            workspace_button_class=WorkspaceButton,
        )

        self.children = CenterBox(
            left_children=[],
            center_children=[self.workspaces, self.date_time],
            right_children=[],
        )


if __name__ == "__main__":
    bar = Bar()
    app = Application("bar-example", bar)
    #Load CSS styles
    app.set_stylesheet_from_file("./styles/bar.css", exposed_functions={}) 
    app.run()
