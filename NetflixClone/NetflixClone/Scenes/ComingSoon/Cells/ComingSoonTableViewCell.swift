import UIKit

final class ComingSoonTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet weak var cellImage: ImageLoader?
    @IBOutlet weak var cellReleaseDate: UILabel?
    @IBOutlet weak var cellTitle: UILabel?
    @IBOutlet weak var cellOverview: UILabel?
    @IBOutlet weak var infoButton: UIButton?
    @IBOutlet weak var remindMeButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setContentForCell(indexPath: IndexPath, comingSoonList: [ListedItem]) {
        self.selectionStyle = .none
        self.infoButton?.tag = indexPath.row
        self.remindMeButton?.tag = indexPath.row
        self.cellImage?.setImageByUrl(url: comingSoonList[indexPath.row].posterPath ?? "")
        self.cellReleaseDate?.text = "Coming " + (comingSoonList[indexPath.row].releaseDate ?? "No release date")
        self.cellTitle?.text = comingSoonList[indexPath.row].title
        self.cellOverview?.text = comingSoonList[indexPath.row].overview
    }
}
