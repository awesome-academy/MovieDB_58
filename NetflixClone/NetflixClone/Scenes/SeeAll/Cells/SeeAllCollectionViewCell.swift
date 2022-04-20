import UIKit

final class SeeAllCollectionViewCell: UICollectionViewCell, ReuseableView {
    @IBOutlet weak var cellImage: ImageLoader?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
    }

    func configUICell(indexPath: IndexPath, posterPath: String) {
        self.cellImage?.setImageByUrl(url: posterPath)
    }
}
