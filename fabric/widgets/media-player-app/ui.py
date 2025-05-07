import fabric
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.window import Window

class MediaPlayerWindow(Window):
    def __init__(self):
        super().__init__(title="Media Player", width=300, height=100)

        # Main vertical layout container
        self.box = Box(vertical=True)
        
        # Adding children to the window (box as container)
        self.add_child(self.box)

        # Now Playing label
        self.label = Label("Now Playing: Nothing")
        self.box.append(self.label)

        # Play/Pause button
        self.play_pause_button = Button(label="Play")
        self.play_pause_button.connect("clicked", self.toggle_playback)
        self.box.append(self.play_pause_button)

    def toggle_playback(self, button):
        if self.play_pause_button.label == "Play":
            self.play_pause_button.label = "Pause"
            self.label.label = "Now Playing: Track A"
        else:
            self.play_pause_button.label = "Play"
            self.label.label = "Now Playing: Paused"

