import UIKit
import YoutubePlayer_in_WKWebView

protocol ItemBannerCellDelegate {
    func seeMoreTapped()
}

final class ItemBannerTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var videoPlayerView: VideoView?
    @IBOutlet weak var cellBanner: UIImageView?
    @IBOutlet weak var cellItemTitle: UILabel?
    @IBOutlet weak var cellItemYear: UILabel?
    @IBOutlet weak var cellItemRatedR: UIButton?
    @IBOutlet weak var cellItemDuration: UILabel?
    @IBOutlet weak var cellItemGenres: UILabel?
    @IBOutlet weak var cellPlayButton: UIButton?
    @IBOutlet weak var cellItemDescription: UILabel?
    @IBOutlet weak var cellSeemoreButton: UIButton?

    var playVideo: Bool?
    var videoId = ""
    var itemBannerCellDelegate: ItemBannerCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUICell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configUICell() {
        cellItemRatedR?.layer.cornerRadius = 2
        cellPlayButton?.layer.cornerRadius = 5
        videoPlayerView?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            guard let self = self,
                  let playVideo = self.playVideo,
                  let cellBanner = self.cellBanner
            else { return }

            self.videoPlayerView?.playVideo(cellBanner: cellBanner, playVideo: playVideo, videoId: self.videoId)
        }
    }

    @IBAction func playTapped(_ sender: UIButton) {
        guard let cellBanner = self.cellBanner else { return }
        videoPlayerView?.playButtonTapped(cellBanner: cellBanner, videoId: videoId)
    }

    @IBAction func seeMoreTapped(_ sender: UIButton) {
        itemBannerCellDelegate?.seeMoreTapped()
    }
}

extension ItemBannerTableViewCell: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        videoPlayerView?.playVideo()
    }
}
