import UIKit

final class SearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        view.backgroundColor = .red
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
