import UIKit

final class InteractiveTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet private weak var cellMyListButton: UIButton?
    @IBOutlet private weak var cellRateButton: UIButton?
    @IBOutlet private weak var cellShareButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
