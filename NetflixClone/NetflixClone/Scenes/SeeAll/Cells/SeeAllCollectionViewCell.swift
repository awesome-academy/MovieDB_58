import UIKit

final class SeeAllCollectionViewCell: UICollectionViewCell, ReuseableView {
    @IBOutlet weak var cellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
    }
}
