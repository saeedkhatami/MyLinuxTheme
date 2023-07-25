#!/usr/bin/env python3

# imports
import subprocess
import os
import shutil
import sys


# colors
C = "\033[0m"     # clear (end)
R = "\033[0;31m"  # red (error)
G = "\033[0;32m"  # green (process)
B = "\033[0;36m"  # blue (choice)
Y = "\033[0;33m"  # yellow (info)

# functions
def check_root():
    id = int(subprocess.check_output("id -u", shell=True).decode("utf-8"))
    if id != 0:
        print(f"\n{R}(!){C} Run the script with 'sudo' privileges or as root user !!\n")
        exit()


def check_distro():
    try:
        lsb_id = subprocess.check_output("lsb_release -i", shell=True).decode("utf-8")
        id = lsb_id.split(":")[-1].lower().strip()
    except Exception:
        id = ""
    return id


def change_grub_theme(grub_theme_path):
    with open("/etc/default/grub", "r") as grub_file:
        data = grub_file.readlines()
        flag = False
        for i, line in enumerate(data):
            if line.startswith("GRUB_TERMINAL_OUTPUT"):
                data.pop(i)
                data.insert(i, f"#{line}\n")
            elif line.startswith("GRUB_TIMEOUT_STYLE"):
                data.pop(i)
                data.insert(i, f"#{line}\n")
            elif line.startswith("GRUB_ENABLE_BLSCFG"):
                data.pop(i)
                data.insert(i, "GRUB_ENABLE_BLSCFG=false\n")
            elif line.startswith("GRUB_THEME"):
                flag = True
                data.pop(i)
                data.insert(i, f'GRUB_THEME="{grub_theme_path}"\n')

        if not flag:
            data.append(f'GRUB_THEME="{grub_theme_path}"\n')

    with open("/etc/default/grub", "w") as grub_file:
        grub_file.writelines(data)


def reset_grub_theme():
    with open("/etc/default/grub", "r") as grub_file:
        data = grub_file.readlines()

        for i, line in enumerate(data):
            if line.startswith("GRUB_THEME"):
                data.pop(i)  # removing existing line
                # data.insert(i, f'#GRUB_THEME=""\n')  # adding new line

    with open("/etc/default/grub", "w") as grub_file:
        grub_file.writelines(data)


def prompt(choices):
    options = list(choices)
    while True:
        print(f"{B}(?){C} Choose an option [{options[0]}-{options[-1]}] : ", end="")
        choice = input().upper()
        if choice not in options:
            print(f"\n{R}(!){C} Select one of the available options !!\n")
            continue
        return choice


def banner():
    print(B)
    print("0x4rch-grub-th3m3\n")


def install():
    # installer script
    print("\n   INSTALLER ✔️")
    THEME = "0x4rch-gurb-th3m3"

    # arch
    if os.path.exists("/boot/grub/"):
        GRUB_THEMES_DIR = "/boot/grub/themes/"
        GRUB_UPDATE_CMD = "grub-mkconfig -o /boot/grub/grub.cfg"

        if not os.path.exists(GRUB_THEMES_DIR):
            os.mkdir(GRUB_THEMES_DIR)

    else:
        print(f"\n{R}(!){C} Couldn't find the GRUB directory. Exiting the script ...")
        exit()

    THEME_DIR = f"{GRUB_THEMES_DIR}{THEME}/"

    if os.path.exists(THEME_DIR):
        print("\n")
        print(f"{Y}(#){C} If you already have a version of this theme installed, uninstall it first.\n")
        exit()
    else:
        os.mkdir(THEME_DIR)  # making the theme dir in '/boot/grub/themes'

    # selecting resolution
    print(f"\n{B}(?){C} Choose the RESOLUTION {Y}[default = 1]{C} :\n\n    (1) {G}1080p{C} {Y}[Full HD]{C}    (2) {G}1440p{C} {Y}[2K]{C}\n")
    icon_theme_choice = input(f"{B}(?){C} choice : ")
    if icon_theme_choice == "2":
        RESOLUTION = "1440p"
    else:
        RESOLUTION = "1080p"

    # selecting icon theme
    print(f"\n{B}(?){C} Choose the ICON THEME {Y}[default = 1]{C} :\n\n    (1) {G}Color{C} Icons     (2) {G}White{C} Icons\n")
    icon_theme_choice = input("choice : ")
    if icon_theme_choice == "2":
        ICON_THEME = "white"
    else:
        ICON_THEME = "color"

    # defining asset paths
    BACKGROUND_PATH = (f"assets/backgrounds/arch-{RESOLUTION}.png")
    ICONS_PATH = f"assets/icons-{RESOLUTION}/{ICON_THEME}/"
    FONTS_PATH = f"assets/fonts/{RESOLUTION}/"
    BASE_PATH = f"base/{RESOLUTION}/"

    print(f"\n{G}($){C} Copying assets to {THEME_DIR}")
    # copying & renaming background img
    shutil.copy(BACKGROUND_PATH, f"{THEME_DIR}background.png")
    # copying & renaming icon pack
    shutil.copytree(ICONS_PATH, f"{THEME_DIR}icons/")  # 'icons' dir created inside main theme dir
    # copying font files
    shutil.copytree(FONTS_PATH, THEME_DIR, dirs_exist_ok=True)
    # copying base files
    shutil.copytree(BASE_PATH, THEME_DIR, dirs_exist_ok=True)
    print("    done.\n")

    print(f"{G}($){C} Editing the GRUB file ...")
    THEME_PATH = f"{THEME_DIR}theme.txt"
    change_grub_theme(THEME_PATH)
    print("    done.\n")

    print(f"{G}($){C} Updating GRUB ...\n")
    subprocess.run(GRUB_UPDATE_CMD, shell=True)

    print(f"\n{Y}(#){C} 0x4rch grub th3m3 has been successfully installed !!\n")

    exit()


def uninstall():
    # uninstaller script
    print("\n   UNINSTALLER ❌\n")
    THEME = "0x4rch-gurb-th3m3"  # theme name

    # arch
    if os.path.exists("/boot/grub/"):
        GRUB_THEME_DIR = f"/boot/grub/themes/{THEME}/"
        GRUB_UPDATE_CMD = "grub-mkconfig -o /boot/grub/grub.cfg"

    else:  # if theme not found
        print(f"\n{R}(!){C} Couldn't find the GRUB directory. Exiting the script ...")
        exit()

    ask = input(f"{B}(?){C} Remove 4rch-gurb-th3m3 (y/n)? {Y}[default = n]{C} : ")
    if ask.lower() != "y":
        print(f"\n{R}(!){C} No changes were made. Exiting the script ...\n")
        exit()
    else:
        # removing theme folder
        shutil.rmtree(GRUB_THEME_DIR)
        print(f"\n{G}($){C} Removed the theme directory ...\n")

    # resetting the grub file
    print(f"{G}($){C} Resetting the GRUB file ...\n")
    reset_grub_theme()

    # updating grub
    print(f"{G}($){C} Updating GRUB ...\n")
    subprocess.run(GRUB_UPDATE_CMD, shell=True)

    print(f"\n{Y}(#){C} 0x4rch-gurb-th3m3 has been successfully removed !!\n")
    exit()


if __name__ == "__main__":
    check_root()  # checking root access
    banner()  # shows banner
    try:
        if len(sys.argv) != 2:
            raise Exception("Invalid number of arguments: Use either '-i' or '-u'")
        if sys.argv[-1] in ["-i", "--install"]:
            install()  # installer
        elif sys.argv[-1] in ["-u", "--uninstall"]:
            uninstall()  # uninstaller
        else:
            raise Exception("Invalid argument provided: Use either '-i' or '-u'")
    except Exception as e:
        print(f"\n{R}(!){C} An unexpected error occurred while running the script !!\n")
        print(f"{R}(!){C} ERROR : {R}{e}{C}")
        exit()
