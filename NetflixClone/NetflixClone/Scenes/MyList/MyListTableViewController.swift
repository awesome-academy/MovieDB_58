import UIKit

final class MyListTableViewController: UITableViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let coreDataRepo = CoreDataRepository()
    private var myListArray = [MyList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        createObserver()
        fetchDataFromCoreData()
    }

    private func setUpNavigationBar() {
        // View Title
        let titleLabel = UILabel()
        titleLabel.text = "My List"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
        // Search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""
    }

    func fetchDataFromCoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.myListArray = self.coreDataRepo.getAll()
            self.tableView.reloadData()
        }
    }

    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(myListTapped), name: Notification.Name.myListButtonTappedNotiName, object: nil)
    }

    @objc func myListTapped() {
        fetchDataFromCoreData()
    }

    @objc func searchButtonTapped() {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") else { return }
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyListTableViewCell.identifier, for: indexPath) as? MyListTableViewCell
        else { return UITableViewCell() }

        cell.setContentForCell(cell: cell, indexPath: indexPath, array: myListArray)

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailVC = DetailTableViewController(id: myListArray[indexPath.item].id, isMovie: myListArray[indexPath.item].isMovie, playVideo: false)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataRepo.remove(myListObject: myListArray[indexPath.row])
            myListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: NSNotification.Name.myListButtonTappedNotiName, object: nil)
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        if offSetY < -200 {
            tableView.reloadData()
        }
    }
}
