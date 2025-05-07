import fabric # importing the base package
from fabric import Application
from fabric.widgets.label import Label # gets the Label class
from fabric.widgets.window import Window # grabs the Window class from Fabric

window = Window( # creates a new instance of the Window class and assign it to the 'window' variable
 child = Label("Ello, bruv"), # creates a new Label instance and assigns it as a child of the window
 all_visible=True # make the window and all of its children appear once the config runs
)

app = Application("default", window) # define a new config named "default" which holds 'window'
app.run() # run the event loop (run the config)
