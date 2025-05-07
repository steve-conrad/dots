import fabric
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.button import Button
from fabric.widgets.window import Window

def create_button(): # define a "factory function"
    return Button(label="Click Me", on_clicked=lambda b, *_: b.set_label("you clicked me"))


if __name__ == "__main__":
    box = Box(
      orientation="v",
      children=[
        Label(label="Fabric Buttons Demo"),
        Box(
          orientation="h",
          children=[
            create_button(),
            create_button(),
            create_button(),
            create_button(),
          ],
        ),
      ],
    )
    window = Window(child=box)
    app = Application("default", window)

    app.run()
