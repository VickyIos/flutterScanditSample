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
