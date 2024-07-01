# flutter_module_sample

A new Flutter module project.

## Getting Started

Steps:

1.Build a new AAR file by `flutter build aar` from this Flutter Module Project

2.Copy the maven URL from the terminal after the generation of aar file

```
maven {
            url '../build/host/outputs/repo'
      }

```

3.Copy dependencies from the terminal after the generation of aar file

```
dependencies {
      debugImplementation 'com.example.flutter_module_sam:flutter_debug:1.0'
      profileImplementation 'com.example.flutter_module_sam:flutter_profile:1.0'
      releaseImplementation 'com.example.flutter_module_sam:flutter_release:1.0'
    }
```


For help getting started with Flutter development, view the online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).
