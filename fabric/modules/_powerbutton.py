from imports import *

powerbutton = Button(
    label=" ",
    name="power-button"
)

script_path = os.path.expandvars(
    "$HOME/.config/hyprnosis/configs/waybar/scripts/power_menu.sh"
)

powerbutton.connect("clicked", lambda *args: subprocess.Popen([script_path]))
