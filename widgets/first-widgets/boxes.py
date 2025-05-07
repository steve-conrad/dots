import fabric # importing the base pacakge
from fabric import Application # prepare the application class which manages multi-config setups
from fabric.widgets.box import Box # gets the Box class
from fabric.widgets.label import Label # gets the Label class
from fabric.widgets.window import Window # grabs the Window class from Fabric


if __name__ == "__main__":
    box_1 = Box(
        orientation="v", # vertical
        children=Label(label="this is the first box")
    )
    box_2 = Box(
        spacing=28, # adds some spacing between the children
        orientation="h", # horizontal
        children=[
            Label(label="this is the first element in the second box"),
            Label(label="btw, this box elements will get added horizontally")
        ]
    )
    box_1.add(box_2) # append box_2 inside box_1 along with the label already in there

    window = Window(child=box_1) # there's no need showing this window using `show_all()`; it'll show them itself because the children are already passed
    app = Application("default", window) # define a new config named "defualt" which holds `window`

    app.run() # run the event loop (run the config)
