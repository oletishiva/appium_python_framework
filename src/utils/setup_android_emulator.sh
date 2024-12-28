#!/bin/bash

set -e

# Target Android SDK version and emulator details
ANDROID_VERSION="31"
SYSTEM_IMAGE="system-images;android-31;google_apis_playstore;arm64-v8a"
EMULATOR_NAME="test_avd"

# Function to check the operating system
function check_os() {
    case "$(uname -s)" in
        Linux*)     OS="Linux";;
        Darwin*)    OS="Mac";;
        CYGWIN*|MINGW32*|MSYS*|MINGW*) OS="Windows";;
        *)          OS="UNKNOWN";;
    esac
    echo "Detected OS: $OS"
}

# Function to install dependencies for Linux
function install_linux_dependencies() {
    echo "Installing dependencies for Linux..."
    sudo apt-get update
    sudo apt-get install -y openjdk-11-jdk wget unzip
}

# Function to install dependencies for Mac
function install_mac_dependencies() {
    echo "Installing dependencies for Mac..."

    # Check and install OpenJDK
    if ! brew list --formula | grep -q "^openjdk$"; then
        echo "Installing OpenJDK..."
        brew install openjdk
    else
        echo "OpenJDK is already installed."
    fi

    # Check and install wget
    if ! brew list --formula | grep -q "^wget$"; then
        echo "Installing wget..."
        brew install wget
    else
        echo "wget is already installed."
    fi

    # Check and install unzip
    if ! brew list --formula | grep -q "^unzip$"; then
        echo "Installing unzip..."
        brew install unzip
    else
        echo "unzip is already installed."
    fi
}


# Function to install dependencies for Windows
function install_windows_dependencies() {
    echo "Installing dependencies for Windows..."
    echo "Please ensure you have Java, wget, and unzip installed manually."
}

# Function to setup Android SDK
function setup_android_sdk() {
    ANDROID_SDK_DIR="$HOME/android-sdk"
    mkdir -p "$ANDROID_SDK_DIR"

    if [[ ! -d "$ANDROID_SDK_DIR/cmdline-tools/latest" ]]; then
        echo "Downloading Android Command Line Tools..."
        if [[ "$OS" == "Windows" ]]; then
            wget -q https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip -O cmdline-tools.zip
        elif [[ "$OS" == "Mac" ]]; then
            wget -q https://dl.google.com/android/repository/commandlinetools-mac-9477386_latest.zip -O cmdline-tools.zip
        else
            wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip
        fi

        unzip cmdline-tools.zip -d "$ANDROID_SDK_DIR"
        rm cmdline-tools.zip

        mkdir -p "$ANDROID_SDK_DIR/cmdline-tools/latest"
        cp -R "$ANDROID_SDK_DIR/cmdline-tools/"* "$ANDROID_SDK_DIR/cmdline-tools/latest/"
        rm -rf "$ANDROID_SDK_DIR/cmdline-tools/cmdline-tools"

    else
        echo "Android Command Line Tools already installed."
    fi

    echo "Android SDK tools set up."
}

# Function to configure environment variables
function configure_env() {
    export ANDROID_SDK_ROOT="$HOME/android-sdk"
    export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

    echo "Environment variables configured."
    # Persist the configuration
    SHELL_CONFIG="$HOME/.bashrc"
    if [[ "$SHELL" == */zsh ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    fi

    echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> "$SHELL_CONFIG"
    echo "export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:\$PATH" >> "$SHELL_CONFIG"
}

# Function to check if a specific SDK component is installed
function is_sdk_component_installed() {
    sdkmanager --list | grep -q "$1"
}

# Function to install required SDK packages
function install_sdk_packages() {
    echo "Installing required Android SDK packages..."

    yes | sdkmanager --licenses

    if is_sdk_component_installed "platform-tools"; then
        echo "Platform tools already installed."
    else
        sdkmanager "platform-tools"
    fi

    if is_sdk_component_installed "platforms;android-$ANDROID_VERSION"; then
        echo "Android platform $ANDROID_VERSION already installed."
    else
        sdkmanager "platforms;android-$ANDROID_VERSION"
    fi

    if is_sdk_component_installed "$SYSTEM_IMAGE"; then
        echo "System image for Android $ANDROID_VERSION already installed."
    else
        sdkmanager "$SYSTEM_IMAGE"
    fi

    if is_sdk_component_installed "emulator"; then
        echo "Android emulator already installed."
    else
        sdkmanager "emulator"
    fi
}

# Function to check if an AVD already exists
function is_avd_existing() {
    avdmanager list avd | grep -q "$EMULATOR_NAME"
}

# Function to create an AVD
function create_avd() {
    if is_avd_existing; then
        echo "AVD $EMULATOR_NAME already exists."
    else
        echo "Creating Android Virtual Device (AVD)..."
        if avdmanager create avd -n "$EMULATOR_NAME" -k "$SYSTEM_IMAGE" --device "pixel_4" <<< "no"; then
            echo "AVD $EMULATOR_NAME created successfully."
        else
            echo "Error: Failed to create AVD. Please check system image and try again."
            exit 1
        fi
    fi
}

# Main execution flow
check_os
if [[ "$OS" == "Linux" ]]; then
    install_linux_dependencies
elif [[ "$OS" == "Mac" ]]; then
    install_mac_dependencies
elif [[ "$OS" == "Windows" ]]; then
    install_windows_dependencies
else
    echo "Unsupported OS: $OS"
    exit 1
fi

setup_android_sdk
configure_env
install_sdk_packages
create_avd

echo "Setup complete. To start the emulator, use:"
echo "emulator -avd $EMULATOR_NAME"
