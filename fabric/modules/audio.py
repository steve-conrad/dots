# modules/audio_controls.py

import fabric.widgets as widgets
from fabric.core import Service
from fabric.core import Signal
#from fabric import get_service
from fabric.widgets.button import Button # Explicitly import Button
from fabric.widgets.label import Label   # Explicitly import Label
from fabric.widgets.scale import Scale   # Explicitly import Scale
from fabric.audio import Audio
from fabric.audio import AudioStream

class AudioControlBox(widgets.box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_orientation("horizontal") # Use "horizontal" or "h"
        self.set_spacing(5) # Add some spacing between elements

        self.audio_service = None
        self.speaker_stream = None

        self._initialize_audio()
        self._build_ui()

    def _initialize_audio(self):
        """Initializes the Fabric Audio service and gets the speaker stream."""
        try:
            self.audio_service = get_service("audio", Service)
        except Exception as e:
            print(f"Error getting audio service: {e}. Audio controls may not function.")
            self.audio_service = None

        if self.audio_service:
            self.speaker_stream = self.audio_service.speaker
            if not self.speaker_stream and self.audio_service.speakers:
                self.speaker_stream = self.audio_service.speakers[0]
                print(f"No default speaker, using first available: {self.speaker_stream.name}")
            elif not self.speaker_stream:
                print("No speaker stream found. Audio controls will be disabled.")

    def _build_ui(self):
        """Constructs the UI elements for audio control."""
        # Mute/Unmute Button
        self.mute_button = Button(label="", name="audio-mute-button")
        self.mute_button.connect(Signal("clicked"), self._on_mute_button_clicked)
        self.add(self.mute_button)

        # Volume Slider (optional, but commonly desired for full control)
        self.volume_label = Label(label="Vol:")
        self.add(self.volume_label)

        self.volume_slider = Scale(
            value=0, # Will be updated dynamically
            min_value=0,
            max_value=100,
            width=100, # Adjust width as needed
            name="audio-volume-slider"
        )
        self.volume_slider.connect(Signal("value-changed"), self._on_volume_slider_changed)
        self.add(self.volume_slider)

        # Initial UI update and signal connections
        if self.speaker_stream:
            self._update_ui_from_stream()
            self.speaker_stream.connect(Signal("changed"), self._on_speaker_stream_changed)
        else:
            # Disable controls if no speaker found
            self.mute_button.set_label("🔇 N/A")
            self.mute_button.set_sensitive(False) # Make button unclickable
            self.volume_slider.set_sensitive(False)
            self.volume_slider.set_value(0) # Set slider to 0 if no audio

    def _update_ui_from_stream(self):
        """Updates UI elements based on the current state of the speaker stream."""
        if not self.speaker_stream:
            return

        # Update mute button label
        if self.speaker_stream.muted:
            self.mute_button.set_label("🔇") # Muted icon
        else:
            volume_percent = int(self.speaker_stream.volume * 100)
            if volume_percent == 0:
                self.mute_button.set_label("🔇") # Muted but volume 0
            elif volume_percent < 50:
                self.mute_button.set_label(f"🔈 {volume_percent}%") # Low volume
            else:
                self.mute_button.set_label(f"🔊 {volume_percent}%") # High volume

        # Update volume slider
        new_slider_value = int(self.speaker_stream.volume * 100)
        # Prevent infinite loop if setting value triggers signal
        if self.volume_slider.get_value() != new_slider_value:
            self.volume_slider.set_value(new_slider_value)

    def _on_mute_button_clicked(self, *args):
        """Callback for when the mute button is clicked."""
        if self.speaker_stream:
            self.speaker_stream.muted = not self.speaker_stream.muted
            # The _on_speaker_stream_changed will handle UI update

    def _on_volume_slider_changed(self, scale_widget, value):
        """Callback for when the volume slider's value changes."""
        if self.speaker_stream:
            # Convert slider value (0-100) back to stream volume (0.0-1.0)
            # Only update if the change came from user interaction, not from _update_ui_from_stream
            if scale_widget.is_focus(): # Heuristic for user interaction vs programmatic update
                self.speaker_stream.volume = value / 100.0
            # The _on_speaker_stream_changed will handle UI update

    def _on_speaker_stream_changed(self, audio_stream):
        """Callback when the speaker stream's properties (volume/mute) change."""
        self._update_ui_from_stream()
