import UIKit

final class ComingSoonTableViewController: UITableViewController {
    private var comingSoonList = [ListedItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }

    private func configTableView() {
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.hidesBarsOnSwipe = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComingSoonTableViewCell.identifier, for: indexPath) as? ComingSoonTableViewCell
        else { return UITableViewCell() }

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
