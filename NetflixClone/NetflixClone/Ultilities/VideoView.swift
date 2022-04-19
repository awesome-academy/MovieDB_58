import UIKit
import YoutubePlayer_in_WKWebView

protocol VideoViewType: AnyObject {
    var isAutoPlay: Bool { get set }

    func prepare(videoId: String, isAutoPlay: Bool)
    func play(cell: ItemBannerTableViewCell)
    func pause(cell: ItemBannerTableViewCell)
}

final class VideoView: UIView, VideoViewType {
    private let videoView = WKYTPlayerView()
    var isAutoPlay: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }

    private func prepareView() {
        self.addSubview(videoView)
        self.videoView.delegate = self
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func prepare(videoId: String, isAutoPlay: Bool = false) {
        self.isAutoPlay = isAutoPlay
        self.videoView.load(withVideoId: videoId)
    }

    func play(cell: ItemBannerTableViewCell) {
        self.videoView.playVideo()
    }

    func pause(cell: ItemBannerTableViewCell) {
        self.videoView.pauseVideo()
    }
}

extension VideoView: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        if isAutoPlay {
            self.videoView.playVideo()
        }
    }
}
