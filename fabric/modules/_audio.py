from imports import *

audio = Button(
    label=" ",
    name="audio-button"
)
audio.connect("clicked", lambda *args: subprocess.Popen("pavucontrol"))
