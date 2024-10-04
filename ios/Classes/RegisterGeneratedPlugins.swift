import Flutter

@objc(RegisterGeneratedPlugins)
public class RegisterGeneratedPlugins: NSObject {
    @objc public static func register(with registry: FlutterPluginRegistrar) {
        NowPlayingPlugin.register(with: registry)
    }
}