import UIKit

final class HomeTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red

        fetchData()
    }
    // MARK: - Function
    func fetchData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            let thisVC = self ?? UITableViewController()
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getList(listType: .trending, mediaType: .all, viewController: thisVC)
            apiRepo.getGenre(mediaType: .tvShow, viewController: thisVC)
            apiRepo.getGenre(mediaType: .movie, viewController: thisVC)
            group.leave()
            group.wait()
            // Update UI
            group.notify(queue: .main) {
                self?.tableView.reloadData()
                print("Fetching is done!")
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
