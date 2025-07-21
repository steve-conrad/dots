import fabric
from fabric import Application
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.box import Box
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
            anchor="left top right",
            exclusivity="auto",
            **kwargs
        )

        self.date_time = DateTime(
            name="date-time",
        )
        self.workspaces = Workspaces(
            name="workspaces"
        )
        self.active_window = ActiveWindow(
            name="active_window"
        )
        self.children = CenterBox(
            start_children=[self.date_time],
            center_children=[self.workspaces],
            end_children=[self.active_window],
        )


if __name__ == "__main__":
    bar = Bar()
    app = Application("MenuBar", bar)
    app.set_stylesheet_from_file("./styles/bar.css")

    def apply_stylesheet(*_):
        return app.set_stylesheet_from_file(
            get_relative_path("./styles/bar.css")
        )

    style_monitor = monitor_file(get_relative_path("./styles"))
    style_monitor.connect("changed", apply_stylesheet)
    apply_stylesheet() # initial styling

    app.run()
