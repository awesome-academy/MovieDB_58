import UIKit

final class MyListTableViewController: UITableViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var myListArray: [MyList]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
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

    private func fetchDataFromCoreData() {
        let coreDataRepo = CoreDataRepository()
        myListArray = coreDataRepo.getAll()
    }

    @objc private func searchButtonTapped() {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") else { return }
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyListTableViewCell.identifier, for: indexPath) as? MyListTableViewCell,
              let myListArray = myListArray
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
    }
}
