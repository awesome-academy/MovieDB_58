import UIKit

final class ComingSoonTableViewController: UITableViewController {
    private var comingSoonList = [ListedItem]()
    private let apiRepo = APIRepository()
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        fetchData(page: page)
    }

    private func configTableView() {
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.hidesBarsOnSwipe = true
    }

    private func fetchData(page: Int) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            // Start fetching
            self.apiRepo.getComingSoonMovie(mediaType: .movie, page: page) { (result: Result<ListedItems, Error>) in
                switch result {
                case .success(let success):
                    self.comingSoonList += success.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let failure):
                    self.apiRepo.popupError(error: failure, viewController: self)
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comingSoonList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComingSoonTableViewCell.identifier, for: indexPath) as? ComingSoonTableViewCell
        else { return UITableViewCell() }
        cell.setContentForCell(indexPath: indexPath, comingSoonList: comingSoonList)

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
