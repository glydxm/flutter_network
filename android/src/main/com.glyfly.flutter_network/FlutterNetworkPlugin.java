package android.src.main.com.glyfly.flutter_network;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterNetworkPlugin implements MethodChannel.MethodCallHandler {

    private final Context context;
    /**
     * Do not allow direct instantiation.
     */
    private FlutterNetworkPlugin(Context context) {
        this.context = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_network");
        channel.setMethodCallHandler(new FlutterNetworkPlugin(registrar.context()));
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "http_get":

                break;
            case "http_post":

                break;
            default:
                result.notImplemented();
                break;
        }
    }
}