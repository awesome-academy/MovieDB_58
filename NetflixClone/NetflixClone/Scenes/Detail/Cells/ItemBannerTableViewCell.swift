import UIKit
import YoutubePlayer_in_WKWebView

protocol ItemBannerCellDelegate {
    func seeMoreTapped()
}

final class ItemBannerTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var cellItemTitle: UILabel?
    @IBOutlet weak var cellItemYear: UILabel?
    @IBOutlet weak var cellItemRatedR: UIButton?
    @IBOutlet weak var cellItemDuration: UILabel?
    @IBOutlet weak var cellItemGenres: UILabel?
    @IBOutlet weak var cellPlayButton: UIButton?
    @IBOutlet weak var cellItemDescription: UILabel?
    @IBOutlet weak var cellSeemoreButton: UIButton?

    var videoPlayerView: VideoViewType =  VideoView()
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
        if let videoView = videoPlayerView as? UIView {
            playerView.addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                videoView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
                videoView.topAnchor.constraint(equalTo: playerView.topAnchor),
                videoView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
                videoView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor)
            ])
        }
    }

    @IBAction func playTapped(_ sender: UIButton) {
        videoPlayerView.play(cell: self)
    }

    @IBAction func seeMoreTapped(_ sender: UIButton) {
        itemBannerCellDelegate?.seeMoreTapped()
    }
}
