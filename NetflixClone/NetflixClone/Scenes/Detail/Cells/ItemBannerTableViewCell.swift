import UIKit
import YoutubePlayer_in_WKWebView

protocol ItemBannerCellDelegate {
    func seeMoreTapped()
}

final class ItemBannerTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var videoPlayerView: WKYTPlayerView?
    @IBOutlet weak var cellBanner: UIImageView?
    @IBOutlet weak var cellItemTitle: UILabel?
    @IBOutlet weak var cellItemYear: UILabel?
    @IBOutlet weak var cellItemRatedR: UIButton?
    @IBOutlet weak var cellItemDuration: UILabel?
    @IBOutlet weak var cellItemGenres: UILabel?
    @IBOutlet weak var cellPlayButton: UIButton?
    @IBOutlet weak var cellItemDescription: UILabel?
    @IBOutlet weak var cellSeemoreButton: UIButton?

    private var isPlaying = false
    var itemTrailerId = ""
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
    }

    @IBAction func playTapped(_ sender: Any) {
        cellBanner?.isHidden = isPlaying
        if isPlaying {
            videoPlayerView?.load(withVideoId: itemTrailerId)
        } else {
            videoPlayerView?.stopVideo()
        }
        isPlaying = !isPlaying
    }

    @IBAction func seeMoreTapped(_ sender: UIButton) {
        itemBannerCellDelegate?.seeMoreTapped()
    }
}

extension ItemBannerTableViewCell: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
}
