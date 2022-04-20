import UIKit

final class ComingSoonTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var cellImage: UIImageView?
    @IBOutlet weak var cellReleaseDate: UILabel?
    @IBOutlet weak var cellTitle: UILabel?
    @IBOutlet weak var cellOverview: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func infoButtonTapped(_ sender: UIButton) {
    }

    @IBAction func remindButtonTapped(_ sender: UIButton) {
    }
}
