import Flutter
import UIKit
import AVFoundation

public class NowPlayingPlugin: NSObject, FlutterPlugin {
    private var nowPlayingManager: NowPlayingManager?
    private var channel: FlutterMethodChannel?
    
    @objc public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.deepidoo.dev/now_playing", binaryMessenger: registrar.messenger())
        let instance = NowPlayingPlugin()
        instance.channel = channel
        instance.nowPlayingManager = NowPlayingManager()
        registrar.addMethodCallDelegate(instance, channel: channel)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateNowPlayingInfo":
            if let args = call.arguments as? [String: Any],
               let title = args["title"] as? String,
               let artist = args["artist"] as? String,
               let duration = args["duration"] as? Double,
               let currentTime = args["currentTime"] as? Double,
               let playbackRate = args["playbackRate"] as? Float,
               let imageUrl = args["imageUrl"] as? String {
                loadArtwork(from: imageUrl) { artwork in
                    self.nowPlayingManager?.updateNowPlayingInfo(title: title, artist: artist, artwork: artwork, duration: duration, currentTime: currentTime, playbackRate: playbackRate)
                    result(nil)
                }
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for updateNowPlayingInfo", details: nil))
            }
        case "setupRemoteCommandHandlers":
            setupRemoteCommandCenter()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func loadArtwork(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    private func setupRemoteCommandCenter() {
        nowPlayingManager?.setupRemoteCommandHandlers(
            onPlay: { [weak self] in
                self?.channel?.invokeMethod("onPlay", arguments: nil)
            },
            onPause: { [weak self] in
                self?.channel?.invokeMethod("onPause", arguments: nil)
            },
            onNextTrack: { [weak self] in
                self?.channel?.invokeMethod("onNextTrack", arguments: nil)
            },
            onPreviousTrack: { [weak self] in
                self?.channel?.invokeMethod("onPreviousTrack", arguments: nil)
            },
            onSeek: { [weak self] time in
                self?.channel?.invokeMethod("onSeek", arguments: ["time": time])
            }
        )
    }
}
