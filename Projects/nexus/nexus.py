# Nexus - Computer setup utility

# Python Modules and Libraries
import os
import subprocess
import threading
import customtkinter

# Main App
class App(customtkinter.CTk):
    def __init__(self):
        super().__init__()

        self.title("Arch Nexus")
        self.geometry("400x250")
        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(6, weight=1)

        # Main Menu
        self.main_menu_frame = customtkinter.CTkFrame(self)
        self.main_menu_frame.grid(row=3, column=0, padx=10, pady=10, sticky="nsew")
        self.main_menu_frame.grid_columnconfigure((0, 1, 2), weight=1)

        self.info_label = customtkinter.CTkLabel(
            self.main_menu_frame,
            text="Welcome to Nexus\nSelect an operating system to continue",
            font=("Helvetica", 24, "bold")
        )
        self.info_label.grid(row=0, column=0, columnspan=3, pady=(10, 5), sticky="n")

        self.button_1 = customtkinter.CTkButton(
            self.main_menu_frame, text="Arch",
            command=self.button_arch,
            height=50
        )
        self.button_1.grid(row=1, column=0, padx=10, pady=10, sticky="ew")

        self.button_2 = customtkinter.CTkButton(
            self.main_menu_frame,
            text="MacOS",
            command=self.button_macOS,
            height=50
        )
        self.button_2.grid(row=1, column=1, padx=10, pady=10, sticky="ew")

        self.button_3 = customtkinter.CTkButton(
            self.main_menu_frame,
            text="Windows",
            command=self.button_windows,
            height=50
        )
        self.button_3.grid(row=1, column=2, padx=10, pady=10, sticky="ew")

        # Arch Menu
        self.arch_menu_frame = customtkinter.CTkFrame(self)
        self.arch_menu_frame.grid_columnconfigure((0, 1, 2, 3), weight=1)
        self.arch_menu_frame.grid_rowconfigure((0, 1, 2), weight=1)
        self.output_textbox = customtkinter.CTkTextbox(self.arch_menu_frame, height=120)
        self.output_textbox.grid(row=3, column=0, columnspan=4, padx=10, pady=(0, 10), sticky="nsew")

        self.info_label = customtkinter.CTkLabel(
            self.arch_menu_frame,
            text="Select an option to configure Arch linux",
            font=("Helvetica", 24, "bold")
        )
        self.info_label.grid(row=0, column=0, columnspan=4, pady=(10, 5), sticky="n")

        self.button_1 = customtkinter.CTkButton(
            self.arch_menu_frame, text="Run All",
            command=self.button_run_all,
            height=50
        )
        self.button_1.grid(row=1, column=0, padx=10, pady=10, sticky="ew")

        self.button_2 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Update System",
            command=self.button_update,
            height=50
        )
        self.button_2.grid(row=1, column=1, padx=10, pady=10, sticky="ew")

        self.button_3 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install yay AUR Helper",
            command=self.button_install_yay,
            height=50
        )
        self.button_3.grid(row=1, column=2, padx=10, pady=10, sticky="ew")

        self.button_4 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install Hyprland",
            command=self.button_install_hyprland,
            height=50
        )
        self.button_4.grid(row=1, column=3, padx=10, pady=10, sticky="ew")

        self.button_5 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install GPU Drivers",
            command=self.button_gpu_drivers,
            height=50
        )
        self.button_5.grid(row=2, column=0, padx=10, pady=10, sticky="ew")

        self.button_6 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install System Utilities",
            command=self.button_install_utils,
            height=50
        )
        self.button_6.grid(row=2, column=1, padx=10, pady=10, sticky="ew")

        self.button_7 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install Apps",
            command=self.button_install_apps,
            height=50
        )
        self.button_7.grid(row=2, column=2, padx=10, pady=10, sticky="ew")

        self.button_8 = customtkinter.CTkButton(
            self.arch_menu_frame,
            text="Install Dots",
            command=self.button_install_dots,
            height=50
        )
        self.button_8.grid(row=2, column=3, padx=10, pady=10, sticky="ew")

    # Outputs script to GUI
    def script_output(self, command_or_path):
        def task():
            self.output_textbox.delete("0.0", "end")

            if isinstance(command_or_path, list):
                cmd = command_or_path
            else:
                cmd = ["/bin/bash", os.path.expanduser(command_or_path)]

            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True
            )

            for line in process.stdout:
                self.output_textbox.insert("end", line)
                self.output_textbox.see("end")

            process.stdout.close()
            process.wait()

        threading.Thread(target=task).start()

    # Define button actions
    def button_arch(self):
        self.main_menu_frame.grid_forget()
        self.arch_menu_frame.grid(row=3, column=0, padx=10, pady=10, sticky="nsew")

    def button_macOS(self):
        print("MacOS")

    def button_windows(self):
        print("Windows")

    def button_run_all(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/run_all.sh")
        print("Running system updates")

    def button_update(self):
        self.script_output(["pkexec", "pacman", "-Syu", "--noconfirm"])

    def button_install_yay(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/install_yay.sh")
        print("Installing yay")

    def button_install_hyprland(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/install_hyprland.sh")
        print("Installing Hyprland")

    def button_gpu_drivers(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/gpu_drivers.sh")
        print("Installing GPU Drivers")

    def button_install_utils(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/install_utils.sh")
        print("Installing system utilities")

    def button_install_apps(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/install_apps.sh")
        print("Installing applications")

    def button_install_dots(self):
        self.script_output("~/Dot-Files/Scripts/arch-nexus-py/scripts/install_dots.sh")
        print("Installing dot files")

app = App()
app.mainloop()

