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

class Bar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            **kwargs
        )

        self.date_time = DateTime(
            name="date_time",
        )
        self.workspaces = Workspaces(
            name="workspaces",
        )

        self.children = CenterBox(
            left_children=[],
            center_children=[self.date_time, self.workspaces],
            right_children=[],
        )


if __name__ == "__main__":
    bar = Bar()
    app = Application("MenuBar", bar)
    app.set_stylesheet_from_file("./styles/bar.css") 
    app.run()
