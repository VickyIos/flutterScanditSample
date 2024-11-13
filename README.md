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

## Update on 13 Nov 2024

Previous issues were addressed, Now we are using scandit_flutter_datacapture_barcode: ^6.28.1

And we use Zebra Device(TC22/TC27) for testing 

The issue which we are facing is, Our Mobile app face overheating issue, the Scandit Camera Viewfinder freezes over time and Camera Viewfinder turns Black while we continuously scan QR codes and make our App unusable.

In this minimal project, I have integrated only the scandit framework and no other computation or functionality added.

Even only with Scandit Framework, the Device gets overheat & the Scandit Camera Viewfinder freezes over time

I have attached video for your reference, Kindly check.

https://github.com/user-attachments/assets/b570f5a5-40d9-4028-a520-83bb98070bca

In our analysis, we notice the issue when the Device & the App meets this condition

- When the temperature of the Zebra device hits 42° or 43° or higher

- Zebra Device Thermal State reach ThermalStatus.severe

Using a different device manufacturer, the Xiaomi Redmi A2, model number 23028rn4di, I have also tried the identical scenario.

- Scan Screen Freeze at 47° with this device.

I have added the log

```
2024-11-07 13:22:19.046   954-5897  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][HAL    ] camxhal3module.cpp:75 SetDropCallbacks() We are dropping the callbacks due to error conditions!


2024-11-07 13:22:19.046  1324-6626  Camera3-Device          cameraserver                         E  Camera 0: notifyError: Camera HAL reported serious device error


2024-11-07 13:22:19.047 24468-24540 sdc-core                com.rfxcel.mobile        E  Failed to open camera with camera API 2


2024-11-07 13:22:19.047 24468-24540 newrelic                com.rfxcel.mobile        E  newrelic: {level=ERROR,tag=sdc-core,message=Failed to open camera with camera API 2}


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W  android.hardware.camera2.CameraAccessException: CAMERA_ERROR (3): The camera device has encountered a serious error


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.hardware.camera2.impl.CameraDeviceImpl.checkIfCameraClosedOrInError(CameraDeviceImpl.java:2524)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.hardware.camera2.impl.CameraDeviceImpl.flush(CameraDeviceImpl.java:1427)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.hardware.camera2.impl.CameraCaptureSessionImpl.abortCaptures(CameraCaptureSessionImpl.java:453)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at com.scandit.datacapture.core.internal.module.source.CameraApi2Delegate.f(SourceFile:2)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at com.scandit.datacapture.core.internal.module.source.CameraApi2Delegate.goToSleep(SourceFile:15)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.os.MessageQueue.nativePollOnce(Native Method)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.os.MessageQueue.next(MessageQueue.java:335)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.os.Looper.loopOnce(Looper.java:161)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.os.Looper.loop(Looper.java:288)


2024-11-07 13:22:19.052 24468-24540 System.err              com.rfxcel.mobile        W    at android.os.HandlerThread.run(HandlerThread.java:67)


2024-11-07 13:22:19.052   954-1693  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][NONE:    ] camxstatsroiprocessor.cpp:391: SetAECGain AECTrackerROI: invalid input AEC gain 1.000000


2024-11-07 13:22:19.052   954-1693  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][NONE:    ] camxstatsroiprocessor.cpp:391: SetAECGain AECTrackerROI: invalid input AEC gain 1.000000


2024-11-07 13:22:19.053  1324-6625  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.057  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.059 24468-24552 BufferPoolAccessor2.0   com.rfxcel.mobile        D  bufferpool2 0xb4000072b73ede38 : 0(0 size) total buffers - 0(0 size) used buffers - 0/5 (recycle/alloc) - 4/34 (fetch/transfer)


2024-11-07 13:22:19.059 24468-24552 BufferPoolAccessor2.0   com.rfxcel.mobile        D  bufferpool2 0xb4000072b739b5c8 : 0(0 size) total buffers - 0(0 size) used buffers - 0/5 (recycle/alloc) - 4/34 (fetch/transfer)


2024-11-07 13:22:19.059 24468-24552 BufferPoolAccessor2.0   com.rfxcel.mobile        D  evictor expired: 2, evicted: 2


2024-11-07 13:22:19.059  1387-2058  BufferPoolAccessor2.0   media.swcodec                        D  bufferpool2 0xb400007b9322fb58 : 0(0 size) total buffers - 0(0 size) used buffers - 15/18 (recycle/alloc) - 3/18 (fetch/transfer)


2024-11-07 13:22:19.059  1387-2058  BufferPoolAccessor2.0   media.swcodec                        D  bufferpool2 0xb400007b9322f6b8 : 0(0 size) total buffers - 0(0 size) used buffers - 15/18 (recycle/alloc) - 3/18 (fetch/transfer)


2024-11-07 13:22:19.059  1387-2058  BufferPoolAccessor2.0   media.swcodec                        D  evictor expired: 2, evicted: 2


2024-11-07 13:22:19.060  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: start to disconnect


2024-11-07 13:22:19.060  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: serializationLock acquired


2024-11-07 13:22:19.060  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: Shutting down


2024-11-07 13:22:19.063  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.065  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.069  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.077   954-1692  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][NONE:    ] camxstatsroiprocessor.cpp:391: SetAECGain AECTrackerROI: invalid input AEC gain 1.000000


2024-11-07 13:22:19.077   954-1692  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][NONE:    ] camxstatsroiprocessor.cpp:391: SetAECGain AECTrackerROI: invalid input AEC gain 1.000000


2024-11-07 13:22:19.080  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.083  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.103 24468-25028 FrameEvents             com.rfxcel.mobile        E  updateAcquireFence: Did not find frame.


2024-11-07 13:22:19.109  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.120  1324-1707  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.121  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.147  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.153  1324-1707  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.155  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.160  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.187  1324-1707  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.193 24468-25028 FrameEvents             com.rfxcel.mobile        E  updateAcquireFence: Did not find frame.


2024-11-07 13:22:19.193  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.200  1324-1707  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.221  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.223 24468-25028 FrameEvents             com.rfxcel.mobile        E  updateAcquireFence: Did not find frame.


2024-11-07 13:22:19.234  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.236  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.259  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.269  1324-6626  CallStack               cameraserver                         W  update: Failed to unwind callstack.


2024-11-07 13:22:19.270  1324-6626  ProcessCallStack        cameraserver                         E  getThreadName: Failed to open /proc/self/task/25345/comm


2024-11-07 13:22:19.272  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.272 24468-25028 FrameEvents             com.rfxcel.mobile        E  updateAcquireFence: Did not find frame.


2024-11-07 13:22:19.277  1324-6626  CameraTraces            cameraserver                         D  Process trace saved. Use dumpsys media.camera to view.


2024-11-07 13:22:19.277   954-5897  Thermal-Lib             and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  Thermal-Lib-Client: Client received msg camcorder 10


2024-11-07 13:22:19.278   954-5897  Thermal-Lib             and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  Thermal-Lib-Client: No Callback registered for camcorder


2024-11-07 13:22:19.278   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][HAL    ] camxhaldevice.cpp:2592 LogRequest() Frame Number ## REQUEST_ERROR ## RESULT_ERROR ## BUFFER_ERROR ## Shutter ##  Metadata[Rcvd/Tot] ## Output[Rcvd/Tot(inErr)] ## Input ## S0[Rcvd/StatusOK/BufErrNotify](0xb400006d64254208)[0] ## S1[Rcvd/StatusOK/BufErrNotify](0xb400006d6425fa48)[0] ##


2024-11-07 13:22:19.279   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.279   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.279   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.279   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.289  1324-6626  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.294  1324-6626  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.295  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.295  1324-6626  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.295  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.296  1324-6625  HidlCamera3-Device      cameraserver                         W  notifyHelper: received notify message in error state.


2024-11-07 13:22:19.296  1324-6625  HidlCamera3-Device      cameraserver                         W  processCaptureResult_3_4: received capture result in error state.


2024-11-07 13:22:19.297  1324-5828  Camera3-Device          cameraserver                         I  disconnectImpl: E


2024-11-07 13:22:19.297  1324-5828  Camera3-Device          cameraserver                         E  Camera 0: disconnectImpl: Shutting down in an error state


2024-11-07 13:22:19.297  1324-5828  CameraLatencyHistogram  cameraserver                         I  ProcessCaptureRequest latency histogram (6188) samples:


2024-11-07 13:22:19.297  1324-5828  CameraLatencyHistogram  cameraserver                         I         40     80    120    160    200    240    280    320    360    inf (max ms)


2024-11-07 13:22:19.297  1324-5828  CameraLatencyHistogram  cameraserver                         I       99.98   0.00   0.02   0.00   0.00   0.00   0.00   0.00   0.00   0.00 (%)


2024-11-07 13:22:19.298   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.298   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.298   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.298   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.298   972-1217  SDM                     ven...ware.display.composer-service  I  ResourceImpl::SetMaxBandwidthMode: new bandwidth mode=0


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:101 DumpState() [IPEHw : 0], AvailableResource = 100


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:101 DumpState() [IFEHw : 0], AvailableResource = 100


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:101 DumpState() [IFEHw : 1], AvailableResource = 100


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:101 DumpState() [SensorHw : 0], AvailableResource = 100


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:101 DumpState() [SensorHw : 1], AvailableResource = 100


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:174 DumpState()


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:175 DumpState() client {TCTRealTimeFeatureZSLPreviewRaw, 0xb400006e9428c2b0}


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:176 DumpState() -------------------------


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:177 DumpState()     Key     Allocation


2024-11-07 13:22:19.304   954-11244 CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  [ DUMP][CORE   ] camxresourcemanager.cpp:178 DumpState() -------------------------


2024-11-07 13:22:19.367   948-1027  minksocket              ssgtzd                               E  MinkIPC_QRTR_Service: client with node 1 port 45e7 went down


2024-11-07 13:22:19.382   948-1027  minksocket              ssgtzd                               E  MinkIPC_QRTR_Service: client with node 1 port 45ec went down


2024-11-07 13:22:19.384   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.385   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.386   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.393   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.402   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.403   673-937   sscrpcd                 sscrpcd                              I  vendor/qcom/proprietary/adsprpc/src/apps_std_imp.c:859: Successfully opened file /mnt/vendor/persist/sensors/registry/registry/../temp.json


2024-11-07 13:22:19.406  2879-2983  ThermalEngine           thermal-engine                       I  Thermal-Server: removing client on fd 71


2024-11-07 13:22:19.406  2879-2983  ThermalEngine           thermal-engine                       D  bw_client_hal_callback: received 0x0 value from client:camera_bw


2024-11-07 13:22:19.406   954-11244 Thermal-Lib             and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   I  thermal_bandwidth_client_cancel_request: Removing all bw request for camera_bw


2024-11-07 13:22:19.411  1324-5828  CameraLatencyHistogram  cameraserver                         I  Stream 0 dequeueBuffer latency histogram (6188) samples:


2024-11-07 13:22:19.411  1324-5828  CameraLatencyHistogram  cameraserver                         I          5     10     15     20     25     30     35     40     45    inf (max ms)


2024-11-07 13:22:19.411  1324-5828  CameraLatencyHistogram  cameraserver                         I       98.13   1.73   0.08   0.05   0.02   0.00   0.00   0.00   0.00   0.00 (%)


2024-11-07 13:22:19.415  1324-5828  CameraLatencyHistogram  cameraserver                         I  Stream 1 dequeueBuffer latency histogram (6188) samples:


2024-11-07 13:22:19.415  1324-5828  CameraLatencyHistogram  cameraserver                         I          5     10     15     20     25     30     35     40     45    inf (max ms)


2024-11-07 13:22:19.415  1324-5828  CameraLatencyHistogram  cameraserver                         I       95.70   4.07   0.23   0.00   0.00   0.00   0.00   0.00   0.00   0.00 (%)


2024-11-07 13:22:19.416  1324-5828  Camera3-Device          cameraserver                         I  disconnectImpl: X


2024-11-07 13:22:19.417  1457-1743  WindowManager           system_server                        D  DP::updateSystemBarAttributes called


2024-11-07 13:22:19.417  1457-1743  WindowManager           system_server                        D  DP::::updateSystemBarAttributes displayId: 0


2024-11-07 13:22:19.420  1457-1743  WindowManager           system_server                        D  DP::updateSystemBarAttributes called


2024-11-07 13:22:19.420  1457-1743  WindowManager           system_server                        D  DP::::updateSystemBarAttributes displayId: 0


2024-11-07 13:22:19.420  1125-1125  DisplayDevice           surfaceflinger                       I  Display 4630947082925536386 policy changed


                                                                                                    Previous: {{defaultModeId=0, allowGroupSwitching=false, primaryRange=[60.00 Hz, 60.00 Hz], appRequestRange=[60.00 Hz, 60.00 Hz]}}


                                                                                                    Current:  {{defaultModeId=0, allowGroupSwitching=false, primaryRange=[0.00 Hz, 240.00 Hz], appRequestRange=[0.00 Hz, 240.00 Hz]}}


                                                                                                    0 mode changes were performed under the previous policy


2024-11-07 13:22:19.422  1324-5828  CameraService           cameraserver                         I  onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1


2024-11-07 13:22:19.422  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.422  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.422  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.422  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.423 24468-24595 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.423 24468-24595 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.426  1324-5828  CameraService           cameraserver                         I  disconnect: Disconnected client for camera 0 for PID 24468


2024-11-07 13:22:19.427  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.428 24468-24540 libc                    com.rfxcel.mobile        W  Access denied finding property "persist.vendor.camera.privapp.list"


2024-11-07 13:22:19.429  1324-5828  CameraService           cameraserver                         I  CameraService::connect call (PID 24468 "com.rfxcel.mobile", camera ID 0) and Camera API version 2


2024-11-07 13:22:19.429  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.429  1324-5828  Camera2ClientBase       cameraserver                         I  Camera 0: Opened. Client: com.rfxcel.mobile (PID 24468, UID 10248)


2024-11-07 13:22:19.430  1324-5828  CameraDeviceClient      cameraserver                         I  CameraDeviceClient 0: Opened


2024-11-07 13:22:19.430  1324-5828  CameraService           cameraserver                         I  makeClient: Camera2 API, override to portrait 0


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         I  onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.431 24468-24480 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.431  1324-5828  CameraProviderManager   cameraserver                         I  Camera device device@3.5/legacy/0 <mailto:device@3.5/legacy/0>  torch status is now NOT_AVAILABLE


2024-11-07 13:22:19.431  1324-5828  CameraService           cameraserver                         I  onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0


2024-11-07 13:22:19.431 24468-24480 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.431   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.431   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.432   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.432   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.432   972-1217  SDM                     ven...ware.display.composer-service  I  ResourceImpl::SetMaxBandwidthMode: new bandwidth mode=1


2024-11-07 13:22:19.432   954-6133  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][HAL    ] camxthermalmanager.cpp:157 RegisterHALDevice() Thermal level is 10! Already in mitigation, force the device creation to fail


2024-11-07 13:22:19.433   954-6133  CamX                    and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  [ERROR][HAL    ] camxhal3.cpp:1121 initialize() initialize() failed


2024-11-07 13:22:19.433   954-6133  CamDevSession@3.2-impl <mailto:CamDevSession@3.2-impl>   and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  initialize: Unable to initialize HAL device: Operation not permitted (-1)


2024-11-07 13:22:19.433   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.433   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.433   977-977   ANDR-PERF-TARGET        ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Error: Invalid logical cluster id 2


2024-11-07 13:22:19.433   977-977   ANDR-PERF-REQUEST       ven...qti.hardware.perf@2.2-service <mailto:ven...qti.hardware.perf@2.2-service>   E  Translate to physical failed


2024-11-07 13:22:19.434   972-1217  SDM                     ven...ware.display.composer-service  I  ResourceImpl::SetMaxBandwidthMode: new bandwidth mode=0


2024-11-07 13:22:19.434   954-6133  CamDev@3.2-impl <mailto:CamDev@3.2-impl>          and...amera.provider@2.4-service_64 <mailto:and...amera.provider@2.4-service_64>   E  open: camera device session init failed


2024-11-07 13:22:19.434  1324-5828  Camera3-Device          cameraserver                         E  Camera 0: initialize: Could not open camera session: Function not implemented (-38)


2024-11-07 13:22:19.434  1324-5828  Camera2ClientBase       cameraserver                         E  initializeImpl: Camera 0: unable to initialize device: Function not implemented (-38)


2024-11-07 13:22:19.434  1324-5828  CameraService           cameraserver                         E  connectHelper: Could not initialize client from HAL.


2024-11-07 13:22:19.434  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: start to disconnect


2024-11-07 13:22:19.434  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: serializationLock acquired


2024-11-07 13:22:19.434  1324-5828  Camera2ClientBase       cameraserver                         D  Camera 0: Shutting down


2024-11-07 13:22:19.434  1324-5828  Camera3-Device          cameraserver                         I  disconnectImpl: E


2024-11-07 13:22:19.434  1324-5828  CameraService           cameraserver                         I  onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1


2024-11-07 13:22:19.435 24468-24480 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.435  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.436  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.436  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.436  1324-5828  CameraService           cameraserver                         E  cameraId(0) Not imager do not filter.


2024-11-07 13:22:19.436 24468-24480 libc                    com.rfxcel.mobile        W  Access denied finding property "vendor.camera.aux.packagelist"


2024-11-07 13:22:19.437  1324-5828  CameraService           cameraserver                         I  disconnect: Disconnected client for camera 0 for PID 24468


2024-11-07 13:22:19.437  1324-5828  Camera2ClientBase       cameraserver                         I  Closed Camera 0. Client was: com.rfxcel.mobile (PID 24468, UID 10248)


2024-11-07 13:22:19.437  1324-5828  Camera3-Device          cameraserver                         I  disconnectImpl: E


2024-11-07 13:22:19.453 24468-24540 sdc-core                com.rfxcel.mobile        E  Failed to open camera with camera API 2


2024-11-07 13:22:19.453 24468-24540 newrelic                com.rfxcel.mobile        E  newrelic: {level=ERROR,tag=sdc-core,message=Failed to open camera with camera API 2}
```
