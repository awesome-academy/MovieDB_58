import UIKit

final class ItemCastCollectionViewCell: UICollectionViewCell, ReuseableView {
    @IBOutlet weak var cellCastImage: ImageLoader?
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

    func configCastJobLabel(indexPath: IndexPath, directorName: String?) {
        cellCastJob?.isHidden = indexPath.item != 0
    }
}
