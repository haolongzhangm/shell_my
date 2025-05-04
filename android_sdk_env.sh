#!/usr/bin/env bash

set -ex
export ANDROID_HOME=~/Android/Sdk

if [ ! -d "$ANDROID_HOME" ]; then
  echo "Android SDK directory does not exist. Please install the Android SDK."
  exit -1
fi

export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "use to list avd: emulator -list-avds"
echo "use to remount system: emulator -avd xxxx -writable-system"
