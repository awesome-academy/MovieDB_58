import UIKit

final class MyListTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var cellImage: ImageLoader?
    @IBOutlet weak var cellLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func configCellUI() {
        guard let cellImage = cellImage else {
            return
        }
        cellImage.layer.cornerRadius = 5
        self.backgroundColor = .clear
    }

}
