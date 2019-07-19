package com.glyfly.flutter_network;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterNetworkPlugin */
public class FlutterNetworkPlugin implements MethodCallHandler {

  private Context context;

  private FlutterNetworkPlugin(Context context) {
    this.context = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    registrar.activeContext();
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_network");
    channel.setMethodCallHandler(new FlutterNetworkPlugin(registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
      case "http_get":

      case "http_post":

        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
