FROM ubuntu:latest

#Locale
ENV LANG C.UTF-8

#
# Install needed packages, setup user anda clean up.
RUN  apt update \
	&& apt install -y sudo \
	&& apt install -y openjdk-17-jdk-headless --no-install-recommends \
	&& apt install -y wget curl iputils-ping git xz-utils zip unzip --no-install-recommends

	# Clean Up
RUN	apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu

#
# Android SDK
# https://developer.android.com/studio#downloads
ENV HOME=/home/ubuntu
ENV ANDROID_SDK_TOOLS_VERSION=11076708
ENV ANDROID_PLATFORM_VERSION=34
ENV ANDROID_BUILD_TOOLS_VERSION=34.0.0
ENV ANDROID_HOME=$HOME/android-sdk-linux
ENV ANDROID_SDK_ROOT="$ANDROID_HOME"
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

#
# Flutter SDK
# https://flutter.dev/docs/development/tools/sdk/releases?tab=linux
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.27.2"
# Make sure to use the needed channel and version for this.
ENV FLUTTER_HOME=${ANDROID_HOME}/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

#
# Android SDK
RUN curl -C - --output android-sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip \
	&& mkdir -p ${ANDROID_HOME}/ \
	&& unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
	&& rm android-sdk-tools.zip \
  && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/tools

RUN  yes | sdkmanager --licenses \
	&& touch $HOME/.android/repositories.cfg \
	&& sdkmanager platform-tools \
	&& sdkmanager emulator \
	&& sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
	&& sdkmanager --install "cmdline-tools;latest"
# create emulator android
RUN  sdkmanager "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64" \
	 && echo no | avdmanager create avd -n Android${ANDROID_PLATFORM_VERSION} -k "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64"

# #
# # Flutter SDK
COPY ./flutter.tar.xz ${ANDROID_HOME}/
RUN tar -xJf $ANDROID_HOME/flutter.tar.xz -C $ANDROID_HOME/
RUN git config --global --add safe.directory '*'
RUN flutter config --android-sdk "${ANDROID_SDK_ROOT}" \
	&& yes | flutter doctor --android-licenses \
	&& flutter config --no-analytics \
	&& flutter update-packages
