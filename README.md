# flutter_scandit_sample_module

We have created a Flutter module with the Scandit SDK(scandit_flutter_datacapture_barcode: ^6.24.1) integrated with our functional logics(Method Channel) and uploaded in this Repo.

## Steps to be followed

Note: If you need to reproduce the black screen issue due to Scandit initialisation

You need to uncomment, https://github.com/VickyIos/flutterScanditSampleModule/blob/b890e1d07c6b467566eb78560f178780f397faa6/lib/main.dart#L13

After uncommenting and follow the screenshot & you can start from step 1 

<img width="342" alt="Note" src="https://github.com/VickyIos/flutterScanditSampleModule/assets/20942319/011fe31f-4832-4811-8d96-63234ea64155">


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

## Update on 25 July 

Flutter Module App - Explained:

- Here is the basic screens of our flutter screens.
- Scan functionality using Scandit SDK is implemented in Screen 2
- These screens are placed within TabBar & TabBarView in HomeScreen Class, so this holds the 3 screens.
- In Home Screen, you can find a back button. So with this back button you can navigate back to Native App.

Issue:

1.Runtime error on logcat:

Steps to be followed to reproduce the issue:

Run Native app -> tap on "Click to open flutter module" -> this will open flutter screens -> Tap Screen 2 (Scan functionality) -> Tap back button on App Bar while you are at screen 2 -> Check Logcat you can find the below run time errors

```
2024-07-25 15:52:34.731 29847-30045/com.rfxcel.driscollsTest E/flutter: [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: MissingPluginException(No implementation found for method switchCameraToDesiredState on channel com.scandit.datacapture.core/method_channel)
    #0      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:332:7)
    <asynchronous suspension>
2024-07-25 15:52:34.733 29847-30045/com.rfxcel.driscollsTest I/flutter: MissingPluginException(No implementation found for method barcodeTrackingFinishDidUpdateSession on channel com.scandit.datacapture.barcode.tracking/method_channel)
2024-07-25 15:52:36.610 29847-30316/com.rfxcel.driscollsTest I/sdc-frameworks: Callback `BarcodeTrackingListener.didUpdateSession` not finished after 2000 milliseconds.
```

2.Error 1025:

Steps to be followed to reproduce the issue:

Run Native app -> Tap on "Click to open flutter module" button -> this will open flutter screens -> Tap Screen 2 (Scan functionality) -> Tap back button on App Bar while you are at screen 2 -> This will navigate to Native App(At the same time Check Logcat you can find the below run time errors) -> Tap again on "Click to open flutter module" button -> This will directly open Screen 2 with Scan functionality -> Now you can see this below error on Camera view.

Note: Same scenario works perfectly fine on Scandit v6.20.0

```
Error 1025 - Disposed Context
The data capture context has been disposed and can't be used anymore
```


Issue Scenario:

This problem occurs when we navigate from our Flutter module Scandit's Scan Screen to Native App.

While navigating out of our flutter module. App Lifecycle will get change which will cause the code below to run.
```
/// Based on the Change in App Lifecycle
/// We will change FrameSourceState value according to 
/// AppLifecycleState.resumed or AppLifecycleState.paused
_camera?.switchToDesiredState(FrameSourceState.off);
```

Above mentioned code will invoke the Scandit SDK method channel 
```
Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
  return methodChannel.invokeMethod(FunctionNames.switchCameraToDesiredState, desiredState.toString());
}
```

With this Scandit SDK method, below runtime error throws in Logcat 
```
2024-07-25 15:52:34.731 29847-30045/com.rfxcel.driscollsTest E/flutter: [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: MissingPluginException(No implementation found for method switchCameraToDesiredState on channel com.scandit.datacapture.core/method_channel)
    #0      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:332:7)
    <asynchronous suspension>
2024-07-25 15:52:34.733 29847-30045/com.rfxcel.driscollsTest I/flutter: MissingPluginException(No implementation found for method barcodeTrackingFinishDidUpdateSession on channel com.scandit.datacapture.barcode.tracking/method_channel)
2024-07-25 15:52:36.610 29847-30316/com.rfxcel.driscollsTest I/sdc-frameworks: Callback `BarcodeTrackingListener.didUpdateSession` not finished after 2000 milliseconds.
```

Since Scandit SDK throws this runtime error on Logcat, while we navigate back to our Flutter Module from Native App

As a result, Scandit SDK prompts the below error in the Camera Viewfinder and I have attached a screenshot of it
```
Error 1025 - Disposed Context
The data capture context has been disposed and can't be used anymore
```
![Scandit v6 24 2_error](https://github.com/user-attachments/assets/268a090b-a451-40b2-9797-1cc3ddc17762)

FYI: I have attached a screenrecord of the issue which is on Scandit SDK v6.24.2 and also screenrecord without any issues on Scandit SDK v6.20.0

Screenrecord with ScanditSDK v6.24.2 - Logcat errors & Disposed Context Error.

https://github.com/user-attachments/assets/e3099081-af7f-4dbd-8b1a-d595838db219

Screenrecord with ScanditSDK v6.20.0 - No Issues.

https://github.com/user-attachments/assets/ab50fe92-6836-4e3d-a539-b715f6504191

## With Scandit SDK v6.20.0 everything works well on our app (no runtime errors or no scandit camera viewfinder error) without any code changes, but not on SDK v6.24.2

Right now, We are blocked with these errors
