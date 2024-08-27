#!/bin/bash

# File: build_apk.sh

# Update package lists
sudo apt update

# Install necessary tools and dependencies
sudo apt install -y openjdk-11-jdk wget unzip

# Install Android SDK Command-line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O commandlinetools.zip
mkdir -p $HOME/android-sdk/cmdline-tools/latest
unzip commandlinetools.zip -d $HOME/android-sdk/cmdline-tools/latest
rm commandlinetools.zip

# Move the tools to the correct directory structure
mv $HOME/android-sdk/cmdline-tools/latest/cmdline-tools/* $HOME/android-sdk/cmdline-tools/latest/
rm -rf $HOME/android-sdk/cmdline-tools/latest/cmdline-tools

# Add Android SDK to PATH
export ANDROID_HOME=$HOME/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

# Verify sdkmanager is available
which sdkmanager

# Install Android SDK components
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Check if gradlew exists, download if not
if [ ! -f "./gradlew" ]; then
    echo "Gradle wrapper not found. Setting up Gradle wrapper..."

    # Download and install Gradle manually
    wget https://services.gradle.org/distributions/gradle-7.4.2-bin.zip
    unzip gradle-7.4.2-bin.zip
    export PATH=$PWD/gradle-7.4.2/bin:$PATH

    # Generate the Gradle wrapper
    gradle wrapper

    # Clean up the downloaded Gradle zip
    rm -rf gradle-7.4.2 gradle-7.4.2-bin.zip
fi

# Make gradlew executable
chmod +x ./gradlew

# Build the APK
./gradlew assembleDebug

# Output APK location
echo "APK built successfully! You can find it in app/build/outputs/apk/debug/"
