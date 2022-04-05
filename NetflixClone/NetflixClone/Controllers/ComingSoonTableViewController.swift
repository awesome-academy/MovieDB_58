import UIKit

final class ComingSoonTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
