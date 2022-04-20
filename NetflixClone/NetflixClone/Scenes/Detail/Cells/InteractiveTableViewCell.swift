import UIKit

final class InteractiveTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet private weak var cellMyListButton: UIButton?
    @IBOutlet private weak var cellRateButton: UIButton?
    @IBOutlet private weak var cellShareButton: UIButton?

    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private let coreDataRepo = CoreDataRepository()
    private var myListArray: [MyList]?
    private var itemInMyList: Bool?
    private var itemId: Int = 0
    private var itemName: String?
    private var itemTitle: String?
    private var itemPosterPath: String?
    private var itemIsMovie: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fetchDataFromCoreData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func fetchDataFromCoreData() {
        myListArray = coreDataRepo.getAll()
    }

    func setContentForInteractiveCell(cell: InteractiveTableViewCell, indexPath: IndexPath, id: Int, name: String?, posterPath: String?, isMovie: Bool, inMyList: Bool) {
        cell.itemId = id
        cell.itemName = isMovie ? nil : name
        cell.itemTitle = isMovie ? name : nil
        cell.itemPosterPath = posterPath
        cell.itemIsMovie = isMovie
        cell.itemInMyList = inMyList
        cellMyListButton?.imageView?.image =  UIImage(systemName: itemInMyList ?? false ? "heart.fill" : "heart")
    }

    @IBAction func myListButtonTapped(_ sender: UIButton) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let itemInMyList = itemInMyList
        else { return }
        if !itemInMyList {
            self.itemInMyList = true
            let myListItem = MyList(context: context)
            myListItem.id = itemId
            myListItem.name = itemName
            myListItem.title = itemTitle
            myListItem.posterPath = itemPosterPath
            myListItem.isMovie = itemIsMovie ?? false

            coreDataRepo.add(myListObject: myListItem)

            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.itemInMyList = false
            guard let myListArray = myListArray else { return }
            let deleteObject = myListArray.filter { $0.id == itemId }
            coreDataRepo.remove(myListObject: deleteObject[0])
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        NotificationCenter.default.post(name: NSNotification.Name.myListButtonTappedNotiName, object: nil)
    }
}
