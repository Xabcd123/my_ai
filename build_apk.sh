#!/bin/bash

# File: build_apk.sh

# Update package lists
sudo apt update

# Install necessary tools and dependencies
sudo apt install -y openjdk-11-jdk wget unzip

# Install Android SDK Command-line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O commandlinetools.zip
mkdir -p $HOME/android-sdk/cmdline-tools
unzip commandlinetools.zip -d $HOME/android-sdk/cmdline-tools
rm commandlinetools.zip

# Add Android SDK to PATH
export ANDROID_HOME=$HOME/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Build the APK
./gradlew assembleDebug

# Output APK location
echo "APK built successfully! You can find it in app/build/outputs/apk/debug/"
