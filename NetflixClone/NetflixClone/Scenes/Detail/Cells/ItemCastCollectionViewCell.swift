import UIKit

final class ItemCastCollectionViewCell: UICollectionViewCell, ReuseableView {
    @IBOutlet weak var cellCastImage: UIImageView?
    @IBOutlet weak var cellCastName: UILabel?
    @IBOutlet weak var cellCastJob: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCellUI()
    }

    private func configCellUI() {
        contentView.backgroundColor = .black
        cellCastImage?.layer.cornerRadius = 5
    }

    func configCastJobLabel(indexPath: IndexPath) {
        if indexPath.item != 0 {
            cellCastJob?.isHidden = true
        }
    }
}
