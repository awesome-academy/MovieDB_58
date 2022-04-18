import UIKit

protocol ItemBannerCellDelegate {
    func seeMoreTapped()
}

final class ItemBannerTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var videoPlayerView: UIView?
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
    }

    @IBAction func playTapped(_ sender: Any) {
        cellBanner?.isHidden = isPlaying
        isPlaying = !isPlaying
    }

    @IBAction func seeMoreTapped(_ sender: UIButton) {
        itemBannerCellDelegate?.seeMoreTapped()
    }
}
