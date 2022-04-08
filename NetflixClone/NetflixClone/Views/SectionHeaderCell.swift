import UIKit

final class SectionHeaderCell: UITableViewCell, ReuseableView {

    @IBOutlet weak var sectionTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
