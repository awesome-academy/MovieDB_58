import UIKit

final class DetailTableViewController: UITableViewController {
    private var itemId: Int = 0
    private var isMovie = false

    init(id: Int, isMovie: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.itemId = id
        self.isMovie = isMovie
    }

    private enum LayoutOptions {
        static let itemBannerRowHeight: CGFloat = 463
        static let itemCastRowHeight: CGFloat = 195
        static let interactRowHeight: CGFloat = 100
        static let moreLikeThisRowHeight: CGFloat = 362
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ItemBannerTableViewCell.nib, forCellReuseIdentifier: ItemBannerTableViewCell.identifier)
        tableView.register(ItemCastTableViewCell.nib, forCellReuseIdentifier: ItemCastTableViewCell.identifier)
        tableView.register(InteractiveTableViewCell.nib, forCellReuseIdentifier: InteractiveTableViewCell.identifier)
        tableView.register(MoreLikeThisTableViewCell.nib, forCellReuseIdentifier: MoreLikeThisTableViewCell.identifier)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailSection: DetailSection = DetailSection(rawValue: indexPath.row) else { return UITableViewCell() }
        switch detailSection {
        case .itemBanner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemBannerTableViewCell.identifier, for: indexPath) as? ItemBannerTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .itemCast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCastTableViewCell.identifier, for: indexPath) as? ItemCastTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .interact:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InteractiveTableViewCell.identifier, for: indexPath) as? InteractiveTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .moreLikeThis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreLikeThisTableViewCell.identifier, for: indexPath) as? MoreLikeThisTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }

        return UITableViewCell()
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let detailSection: DetailSection = DetailSection(rawValue: indexPath.row) else { return 0 }
        switch detailSection {
        case .itemBanner:
            return LayoutOptions.itemBannerRowHeight
        case .itemCast:
            return LayoutOptions.itemCastRowHeight
        case .interact:
            return LayoutOptions.interactRowHeight
        case .moreLikeThis:
            return LayoutOptions.moreLikeThisRowHeight
        }
    }
}
