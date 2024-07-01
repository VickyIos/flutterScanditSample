# flutter_scandit_sample_module

We have created a Flutter module with the Scandit SDK(scandit_flutter_datacapture_barcode: ^6.24.1) integrated with our functional logics(Method Channel) and uploaded in this Repo.

## Steps to be followed

1.Build a new AAR file by using this command-line `flutter build aar`

2.Copy the maven URL from the terminal after the generation of aar file, this will be used in our Native Android App. 

```
maven {
            url '../build/host/outputs/repo'
      }
```
3.Copy dependencies from the terminal after the generation of aar file, this will be used in our Native Android App.

```
dependencies {
      debugImplementation 'com.example.flutter_module_sam:flutter_debug:1.0'
      profileImplementation 'com.example.flutter_module_sam:flutter_profile:1.0'
      releaseImplementation 'com.example.flutter_module_sam:flutter_release:1.0'
    }
```

4.Now you can Checkout our Android Native app repo 

## Getting Started

For help getting started with Flutter development, view the online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).


## Configuration:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.19.6, on macOS 14.4.1 23E224 darwin-arm64 (Rosetta), locale en-IN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
[!] Xcode - develop for iOS and macOS (Xcode 15.3)
! CocoaPods 1.12.1 out of date (1.13.0 is recommended).
CocoaPods is used to retrieve the iOS and macOS platform side's plugin code that responds to your plugin usage on the Dart side.
Without CocoaPods, plugins will not work on iOS or macOS.
For more info, see
https://flutter.dev/platform-plugins
To upgrade see
https://guides.cocoapods.org/using/getting-started.html#updating-cocoapods
for instructions.
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] Android Studio (version 2022.2)
[✓] VS Code (version 1.88.1)
[✓] Connected device (4 available)
[✓] Network resources
```
