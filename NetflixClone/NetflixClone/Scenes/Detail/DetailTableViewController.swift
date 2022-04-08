import UIKit

final class DetailTableViewController: UITableViewController {
    private var itemId: Int = 0
    private var isMovie = false

    init(id: Int, isMovie: Bool) {
        self.itemId = id
        self.isMovie = isMovie
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        view.backgroundColor = .brown
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
