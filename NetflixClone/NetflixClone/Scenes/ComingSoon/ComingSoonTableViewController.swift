import UIKit
import UserNotifications

final class ComingSoonTableViewController: UITableViewController {
    private var comingSoonList = [ListedItem]()
    private let apiRepo = APIRepository()
    private var page = 1
    private var keepFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        fetchData(page: page)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    private func configTableView() {
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
    }

    private func fetchData(page: Int) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            // Start fetching
            self.apiRepo.getComingSoonMovie(mediaType: .movie, page: page) { (result: Result<ListedItems, Error>) in
                switch result {
                case .success(let success):
                    if success.results.isEmpty {
                        self.keepFetching = false
                        DispatchQueue.main.async {
                            self.createAlert()
                        }
                    } else {
                        self.comingSoonList += success.results
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let failure):
                    self.apiRepo.popupError(error: failure, viewController: self)
                }
            }
        }
    }

    func loadMoreData() {
        if !keepFetching {
            keepFetching.toggle()
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                self.fetchData(page: self.page)
                DispatchQueue.main.async {
                    self.keepFetching = false
                }
            }
        }
    }

    @IBAction func remindMeTapped(_ sender: UIButton) {
        guard let releaseDate = comingSoonList[sender.tag].releaseDate else { return }
        let alert = UIAlertController(title: "Set a reminder on \(releaseDate)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let content = UNMutableNotificationContent()
            content.title = "Movie Release!!"
            content.body = "\(self.comingSoonList[sender.tag].title ?? "No Title") is playing today!"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "RemindMeIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func infoTapped(_ sender: UIButton) {
        let detailVC = DetailTableViewController(id: comingSoonList[sender.tag].id, isMovie: true, playVideo: false)
        navigationController?.pushViewController(detailVC, animated: true)
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

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if contentHeight >= scrollView.frame.height {
            if offSetY > contentHeight - scrollView.frame.height + 150 && !keepFetching {
                page += 1
                loadMoreData()
            }
        }

        if offSetY < -200 {
            tableView.reloadData()
        }
    }
}

extension UITableViewController {
    func createAlert() {
        let alert = UIAlertController(title: "Error", message: "End of List!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }))
        present(alert, animated: true)
    }
}
