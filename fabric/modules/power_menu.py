from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.label import Label
from fabric.utils.helpers import exec_shell_command_async

class PowerMenu(Box):
    def __init__(self, **kwargs):
        super().__init__(
            name="power-menu",
            orientation="h",
            spacing=6,
            v_align="center",
            h_align="center",
            visible=False,  # start hidden
            **kwargs,
        )

        def create_button(label, command):
            return Button(
                name="power-menu-button",
                tooltip_markup=label,
                child=Label(label=label),
                on_clicked=lambda *_: self.run_and_hide(command),
            )

        self.buttons = [
            create_button("Lock", "loginctl lock-session"),
            create_button("Suspend", "systemctl suspend"),
            create_button("Logout", "hyprctl dispatch exit"),
            create_button("Reboot", "systemctl reboot"),
            create_button("Shutdown", "systemctl poweroff"),
        ]

        for btn in self.buttons:
            self.add(btn)


        def toggle(self):
            if self.is_visible():
                self.hide()
            else:
                self.show()

        def run_and_hide(self, command):
            exec_shell_command_async(command)
            self.hide()


