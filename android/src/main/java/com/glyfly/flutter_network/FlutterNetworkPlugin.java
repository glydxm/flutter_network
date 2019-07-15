package com.glyfly.flutter_network;

import android.content.Context;

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
    String url = "http://192.168.155.1:2019/findStore";
    switch (call.method) {
      case "http_get":
//        HttpTool.get(context, url, new StringCallBack() {
//          @Override
//          public void onResponse(String s, int i) {
//            Toast.makeText(context, s, Toast.LENGTH_SHORT).show();
//            result.success(s);
//          }
//        });
        result.success("Ok");
        break;
      case "http_post":

        break;
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
