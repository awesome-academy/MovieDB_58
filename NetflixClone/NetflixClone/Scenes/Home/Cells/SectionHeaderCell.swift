import UIKit

final class SectionHeaderCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var sectionTitle: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction private func seeAllTapped(_ sender: Any) {
        let notiName = Notification.Name(rawValue: "com.Turacle.seeAll")
        let userInfo = ["userInfo": ["sectionTitle": sectionTitle]]
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: userInfo)
    }
}
