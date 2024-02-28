#!/usr/bin/env python3

import json
import os
import subprocess


def config():
    # Create a new tmux session
    session_name = "0"
    subprocess.check_call(["tmux", "new-session", "-d", "-s", session_name])

    USER_HOME = os.path.expanduser("~")
    WINDOW_NAME_WITH_DIR = {
        "shell_my": os.path.join(USER_HOME, "shell_my"),
    }

    user_workspace_config = os.path.join(USER_HOME, ".tmux_workspace.json")
    if os.path.isfile(user_workspace_config):
        print(f"Loading user workspace config: {user_workspace_config}")
        # load .tmux_workspace.json to override WINDOW_NAME_WITH_DIR
        """
        .tmux_workspace.json example:
        {
            "shell_my": "/home/username/shell_my",
            "shell_my2": "/home/username/shell_my2"
        }
        """
        with open(os.path.join(user_workspace_config)) as f:
            data = json.load(f)
            WINDOW_NAME_WITH_DIR.clear()
            WINDOW_NAME_WITH_DIR.update(data)
    else:
        print(f"User workspace config not found: {user_workspace_config}, use default.")

    print("WINDOW_NAME_WITH_DIR: ++++++++++++++++++++")
    for key in WINDOW_NAME_WITH_DIR.keys():
        print(f"key: {key}, value: {WINDOW_NAME_WITH_DIR[key]}")
    print("WINDOW_NAME_WITH_DIR: ++++++++++++++++++++")
    # Create a new window for each directory
    idx = 0
    for key in WINDOW_NAME_WITH_DIR.keys():
        dir = WINDOW_NAME_WITH_DIR[key]
        if not os.path.isdir(dir):
            print(f"Directory {dir} does not exist. Skipping.")
        else:
            print(f"Creating window('{idx}') '{key}' at: '{dir}'")
            if idx == 0:
                subprocess.check_call(
                    ["tmux", "rename-window", "-t", f"{session_name}:{idx}", key]
                )
                subprocess.check_call(
                    [
                        "tmux",
                        "send-keys",
                        "-t",
                        f"{session_name}:{idx}",
                        f"cd {dir} && clear",
                        "C-m",
                    ]
                )
            else:
                subprocess.check_call(
                    [
                        "tmux",
                        "new-window",
                        "-t",
                        f"{session_name}:{idx}",
                        "-n",
                        key,
                        f"cd {dir} && bash",
                    ]
                )
            idx = idx + 1


if __name__ == "__main__":
    config()
