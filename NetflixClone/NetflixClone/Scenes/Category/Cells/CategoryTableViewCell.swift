import UIKit

class CategoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCellUI()
    }

    private func configCellUI() {
        self.backgroundColor = .clear
        self.textLabel?.backgroundColor = .clear
        self.textLabel?.textAlignment = .center
    }
}
