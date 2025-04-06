# project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Download flutter sdk : https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.2-stable.tar.xz in .devcontainer folder and rename to flutter.tar.xz

Run web server : flutter run -d web-server --web-port=8001 --web-hostname 0.0.0.0

Run on device : adb pair 192.168.1.30:, puis adb connect 192.168.1.30: et enfin flutter run


adb shell setprop log.tag I
adb shell -x logcat -v time 
