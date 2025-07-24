from imports import *

notifications = Button(
    label=" ",
    name="notifications-button"
)
notifications.connect("clicked", lambda *args: subprocess.Popen(["swaync-client", "-t", "-sw"]))


