import UIKit
import YoutubePlayer_in_WKWebView

final class VideoView: WKYTPlayerView {

    func playVideo(cellBanner: UIImageView, playVideo: Bool, videoId: String) {
        if playVideo {
          cellBanner.isHidden = true
          self.load(withVideoId: videoId)
        }
    }

    func playButtonTapped(cellBanner: UIImageView, videoId: String) {
        var isPlaying = true
        cellBanner.isHidden = isPlaying
        if isPlaying {
            self.load(withVideoId: videoId)
        }
        isPlaying = !isPlaying
    }
}
