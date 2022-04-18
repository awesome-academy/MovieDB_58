import UIKit
import YoutubePlayer_in_WKWebView

final class VideoView: WKYTPlayerView {
    func playVideo(cellBanner: UIImageView, playVideo: Bool, isPlaying: inout Bool, videoId: String) {
        if playVideo {
          cellBanner.isHidden = isPlaying
          self.load(withVideoId: videoId)
          isPlaying = !isPlaying
        }
    }

    func playButtonTapped(cellBanner: UIImageView, isPlaying: inout Bool, videoId: String) {
        cellBanner.isHidden = isPlaying
        if isPlaying {
            self.load(withVideoId: videoId)
        }
        isPlaying = !isPlaying
    }
}
