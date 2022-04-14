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

    private func configCellUI() {
        guard let cellImage = cellImage else {
            return
        }
        cellImage.layer.cornerRadius = 5
        self.backgroundColor = .clear
    }
}
