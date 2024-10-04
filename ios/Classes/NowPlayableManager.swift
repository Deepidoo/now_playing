import Foundation
import MediaPlayer

class NowPlayingManager: NSObject {
  static let shared = NowPlayingManager()
  
  override init() {
    super.init()
  }
  
  func updateNowPlayingInfo(title: String, artist: String, artwork: UIImage?, duration: TimeInterval, currentTime: TimeInterval, playbackRate: Float) {
    var nowPlayingInfo = [String: Any]()
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    nowPlayingInfo[MPMediaItemPropertyArtist] = artist
    
    if let artwork = artwork {
      nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { size in
        return artwork
      }
    }
    
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
    nowPlayingInfo[MPNowPlayingInfoPropertyCurrentPlaybackDate] = Date()
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  func setupRemoteCommandHandlers(
    onPlay: @escaping () -> Void,
    onPause: @escaping () -> Void,
    onNextTrack: @escaping () -> Void,
    onPreviousTrack: @escaping () -> Void,
    onSeek: @escaping (TimeInterval) -> Void
  ) {
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.playCommand.addTarget { _ in
      onPlay()
      return .success
    }
    
    commandCenter.pauseCommand.addTarget { _ in
      onPause()
      return .success
    }
    
    commandCenter.nextTrackCommand.addTarget { _ in
      onNextTrack()
      return .success
    }
    
    commandCenter.previousTrackCommand.addTarget { _ in
      onPreviousTrack()
      return .success
    }

    commandCenter.changePlaybackPositionCommand.addTarget { event in
      if let event = event as? MPChangePlaybackPositionCommandEvent {
        onSeek(event.positionTime)
      }
      return .success
    }
  }
}
