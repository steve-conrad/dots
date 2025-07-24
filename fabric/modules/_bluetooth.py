from imports import *

bluetooth = Button(
    label=" ",
    name="bluetooth-button"
)

script_path = os.path.expandvars(
    "$HOME/.config/hyprnosis/modules/bluetooth.sh"
)

bluetooth.connect("clicked",  lambda *args: subprocess.Popen([script_path]))
