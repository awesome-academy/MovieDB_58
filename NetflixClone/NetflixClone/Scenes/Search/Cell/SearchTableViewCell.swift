import UIKit

final class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView?
    @IBOutlet weak var cellLabel: UILabel?
    @IBOutlet weak var cellPlayButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configCellUI() {
        guard let cellImage = cellImage else {
            return
        }
        cellImage.layer.cornerRadius = 5
        self.backgroundColor = .clear
    }
}
