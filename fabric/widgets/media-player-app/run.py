from fabric import Application
from ui import MediaPlayerWindow

def run():
    window = MediaPlayerWindow()
    app = Application("MediaPlayer", window)
    app.run()

if __name__ == "__main__":
    run()

