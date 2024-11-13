import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart'
    as scnditDataCaptureCore;

class MultiScanScreen extends StatefulWidget {
  final String? licenseKey;
  const MultiScanScreen(this.licenseKey, {Key? key}) : super(key: key);

  @override
  State<MultiScanScreen> createState() =>
      _MultiScanScreenState(DataCaptureContext.forLicenseKey(licenseKey ?? ''));
}

class _MultiScanScreenState extends State<MultiScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener, DataCaptureViewListener {
  double zoomValue = 1.0;
  final zoomController = TextEditingController();
  final Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView _captureView;
  bool _isPermissionMessageVisible = false;
  final DataCaptureContext _context;

  _MultiScanScreenState(this._context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Use the recommended camera settings for the BarcodeTracking mode.
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;

    // This is the best settings for our usecase
    cameraSettings.preferredResolution = VideoResolution.uhd4k;
    cameraSettings.focusRange = FocusRange.near;
    cameraSettings.zoomFactor = zoomValue;
    cameraSettings.focusGestureStrategy = FocusGestureStrategy.autoOnLocation;

    _camera?.applySettings(cameraSettings);

    // Switch camera on to start streaming frames and enable the barcode tracking mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    if (mounted) {
      _checkPermission();
    }

    // The barcode tracking process is configured through barcode tracking settings
    // which are then applied to the barcode tracking instance that manages barcode tracking.
    var captureSettings = BarcodeTrackingSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    captureSettings.enableSymbologies({Symbology.qr});
    // Create new barcode tracking mode with the settings from above.
    _barcodeTracking = BarcodeTracking.forContext(_context, captureSettings)
      // Register self as a listener to get informed of tracked barcodes.
      ..addListener(this);
    // ..addListener(_feedbackListener);

    //  _barcodeTracking.addListener(_feedbackListener);
    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context)..addListener(this);

    // Add a barcode tracking overlay to the data capture view to render the tracked barcodes on
    // top of the video preview. This is optional, but recommended for better visual feedback.
    _captureView.addOverlay(
        BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
            _barcodeTracking,
            _captureView,
            BarcodeTrackingBasicOverlayStyle.frame));
    _captureView.logoStyle = LogoStyle.minimal;

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _barcodeTracking.isEnabled = true;
  }

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera?.switchToDesiredState(FrameSourceState.on);
          }
        }));
  }

  openCameraSettings() async {
    var cameraAccessStatus = await Permission.camera.status;
    if (cameraAccessStatus != PermissionStatus.granted) {
      if (cameraAccessStatus == PermissionStatus.denied ||
          cameraAccessStatus == PermissionStatus.permanentlyDenied) {
        var status = await Permission.camera.request();
        switch (status) {
          case PermissionStatus.granted:
            setState(() {
              _isPermissionMessageVisible = false;
              try {
                _camera?.switchToDesiredState(FrameSourceState.on);
              } catch (e) {
                debugPrint("error on openCameraSettings => $e");
              }
            });
            break;
          case PermissionStatus.denied:
            await openAppSettings();
            break;
          case PermissionStatus.permanentlyDenied:
            await openAppSettings();
            break;
          case PermissionStatus.restricted:
            await openAppSettings();
            break;
          case PermissionStatus.limited:
            await openAppSettings();
            break;
          default:
            await openAppSettings();
        }
      } else {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: PlatformText('No permission to access the camera!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, color: Colors.black, height: 1.5)),
                ),
                const SizedBox(
                  height: 12,
                ),
                FilledButton(
                    onPressed: openCameraSettings,
                    child: Text(
                      'Update Permission',
                    ))
              ],
            ),
          ),
        ],
      );
    } else {
      var bottomPadding = 10 + MediaQuery.of(context).padding.bottom;
      var containerPadding = EdgeInsets.fromLTRB(10, 10, 10, bottomPadding);
      child = Stack(children: [
        Container(
          color: Colors.black,
          child: _captureView,
        ),
        Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (zoomValue > 1.0) {
                        zoomValue = zoomValue - 0.25;
                      }
                    });

                    var cameraSettings =
                        BarcodeTracking.recommendedCameraSettings;

                    // Set the camera as the frame source and turn it on.
                    cameraSettings.preferredResolution = VideoResolution.uhd4k;
                    cameraSettings.focusRange = FocusRange.near;
                    cameraSettings.zoomFactor = zoomValue;
                    cameraSettings.focusGestureStrategy =
                        FocusGestureStrategy.autoOnLocation;
                    _camera?.applySettings(cameraSettings);
                  },
                  child: const Icon(
                    Icons.zoom_out_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Zoom',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (zoomValue >= 1.0) {
                        zoomValue = zoomValue + 0.25;
                      }
                    });
                    var cameraSettings =
                        BarcodeTracking.recommendedCameraSettings;

                    // Set the camera as the frame source and turn it on.

                    cameraSettings.preferredResolution = VideoResolution.uhd4k;
                    cameraSettings.focusRange = FocusRange.near;
                    cameraSettings.zoomFactor = zoomValue;
                    cameraSettings.focusGestureStrategy =
                        FocusGestureStrategy.autoOnLocation;

                    _camera?.applySettings(cameraSettings);
                  },
                  child: const Icon(
                    Icons.zoom_in_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ))
      ]);
    }
    return PlatformScaffold(body: child);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint("didChangeAppLifecycleState - ");
    if (state == AppLifecycleState.resumed) {
      var cameraAccessStatus = await Permission.camera.status;
      if (cameraAccessStatus == PermissionStatus.granted) {
        setState(() {
          _isPermissionMessageVisible = false;
          if (_camera != null && mounted) {
            try {
              _camera?.switchToDesiredState(FrameSourceState.on);
            } catch (e) {
              debugPrint('Unable to turn on camera, $e');
            }
          }
        });
      }
    } else if (state == AppLifecycleState.paused) {
      if (_camera != null && mounted) {
        var currentState = await _camera?.currentState;
        if (currentState == FrameSourceState.on) {
          try {
            _camera?.switchToDesiredState(FrameSourceState.off);
          } catch (e) {
            debugPrint('Unable to turn off camera, $e');
          }
        }
        setState(() {});
      }
    }
    setState(() {});
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _barcodeTracking.removeListener(this);
    _captureView.removeListener(this);
    _barcodeTracking.isEnabled = false;
    try {
      var currentState = await _camera?.currentState;
      if (currentState == FrameSourceState.on) {
        try {
          _camera?.switchToDesiredState(FrameSourceState.off);
        } catch (e) {
          debugPrint('Unable to turn off camera, $e');
        }
      }
    } catch (e) {
      debugPrint('Caught PlatformException: $e');
    }
    _context.removeAllModes();
  }

  @override
  void didChangeSize(DataCaptureView view, Size size,
      scnditDataCaptureCore.Orientation orientation) {
    // TODO: implement didChangeSize
  }

  @override
  void didUpdateSession(
      BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    // TODO: implement didUpdateSession
  }
}
