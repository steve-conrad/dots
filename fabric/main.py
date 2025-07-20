from bar import Bar
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

def main():
    bar = Bar()
    bar.show_all()
    Gtk.main()

if __name__ == "__main__":
    main()

