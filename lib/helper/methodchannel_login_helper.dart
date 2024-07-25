import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MethodChannelService {
  final _channel = const MethodChannel('com.scandit.fluttermodule');
  static final MethodChannelService _instance = MethodChannelService._();
  Function(String)? _loginCallBack;
  Function(String)? _homeCallBack;

  factory MethodChannelService() {
    return _instance;
  }

  MethodChannelService._() {
    initialize();
  }

  void initialize() {
    _channel.setMethodCallHandler(_handleMessage);
  }

  Future<dynamic> _handleMessage(MethodCall call) async {
    debugPrint("Method channel call in helper : $call $_loginCallBack $_homeCallBack");
    if (call.method == 'instance_rfxcel') {
      String response = call.arguments as String;
      if (_loginCallBack != null) {
        _loginCallBack!(response);
      } else if (_homeCallBack != null) {
        _homeCallBack!(response);
      }
    }
  }

  set setLoginCallBack(Function(String)? funObj) {
    _loginCallBack = funObj;
  }

  set setHomeCallBack(Function(String)? funObj) {
    _homeCallBack = funObj;
  }
}
