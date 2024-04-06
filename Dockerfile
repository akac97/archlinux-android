# Use the archlinux:base-devel image as the base
FROM archlinux/archlinux:base-devel

# Update the system and install necessary packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm wget curl unzip zip git git-lfs bash && \
    curl --tlsv1.3 -s "https://get.sdkman.io" | bash && \
    source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk install java 17.0.10-sem

# Set environment variables for Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Download and unzip Android Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip && \
    unzip commandlinetools-linux-7302050_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-7302050_latest.zip

# Accept licenses before installing components
RUN yes | sdkmanager --licenses

# Install latest versions of Android SDK Build-tools, Android SDK Platforms, Android Support Repository, CMake, NDK
RUN sdkmanager "build-tools;34.0.0" "platforms;android-34" "extras;android;m2repository" "cmake;3.10.2.4988404" "ndk;21.3.6528147"
