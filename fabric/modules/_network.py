from imports import *

network = Button(
    label=" ",
    name="network-button"
)
network.connect("clicked", lambda *args: subprocess.Popen("nm-connection-editor"))
