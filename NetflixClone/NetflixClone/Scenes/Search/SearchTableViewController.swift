import UIKit

final class SearchTableViewController: UITableViewController {
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var searchTextFieldImage: UIImageView?
    
    private var searchResults = [ListedItem]()
    private var pageCount = 1
    private var searchText = ""
    private var keepFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configSearchTextField()
    }

    private func configView() {
        view.backgroundColor = .black
    }

    private func configSearchTextField() {
        guard let searchTextField = searchTextField else {
            return
        }
        searchTextField.delegate = self
        searchTextField.borderStyle = .none
        searchTextField.layer.cornerRadius = 5
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .center
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        searchTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
    }

    private func fetchData(query: String, page: Int) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getSearchList(query: query, page: page, viewController: self) { (result: Result<ListedItems, Error>) in
                switch result {
                case .success(let listedArray):
                    if listedArray.results.isEmpty {
                        DispatchQueue.main.async {
                            self.createAlert()
                        }
                    } else {
                        self.searchResults += listedArray.results
                    }
                case .failure(let error):
                    self.popupError(error: error, viewController: self)
                }
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.tableView.reloadData()
                print("Fetching search with query: \(query) data is done!")
            }
        }
    }

    private func createAlert() {
        let alert = UIAlertController(title: "Error", message: "End of List!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }))
        present(alert, animated: true)
    }

    private func popupError(error: Error, viewController: UITableViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }

    private func setContentForCell(cell: SearchTableViewCell, indexPath: IndexPath) {
        guard let posterPath = searchResults[indexPath.row].posterPath else { return }
        guard let name = searchResults[indexPath.row].name ?? searchResults[indexPath.row].title else { return }

        cell.selectionStyle = .none
        cell.cellImage?.setImageByUrl(url: posterPath)
        cell.cellLabel?.text = name
    }

    private func itemTapped(id: Int, isMovie: Bool) {
        let detailVC = DetailTableViewController(id: id, isMovie: isMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func loadMoreData() {
        if !keepFetching {
            keepFetching.toggle()
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                self.fetchData(query: self.searchText, page: self.pageCount)
                DispatchQueue.main.async {
                    self.keepFetching = false
                }
            }
        }
    }

    @objc private func textFieldTapped() {
        guard let searchTextField = searchTextField else {
            return
        }
        searchTextFieldImage?.isHidden = true
        searchTextField.placeholder = ""
        searchTextField.textAlignment = .left
    }

    @objc private func textFieldEndEditing() {
        guard let searchTextField = searchTextField else {
            return
        }
        guard var text = searchTextField.text else {
            return
        }
        if searchTextField.text?.isEmpty == true {
            searchResults = [ListedItem]()
            pageCount = 1
            searchTextFieldImage?.isHidden = false
            searchTextField.placeholder = "Search"
            searchTextField.textAlignment = .center
            searchText = ""
            return
        }
        searchResults = [ListedItem]()
        pageCount = 1
        text = text.replacingOccurrences(of: " ", with: "%20")
        fetchData(query: text, page: pageCount)
        searchText = text
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }

        setContentForCell(cell: cell, indexPath: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemTapped(id: searchResults[indexPath.row].id, isMovie: searchResults[indexPath.row].title != nil)
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed(SearchSectionHeaderView.identifier, owner: self)?.first as? SearchSectionHeaderView else {
            return UIView()
        }

        return headerView
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if contentHeight >= scrollView.frame.height {
            if offSetY > contentHeight - scrollView.frame.height + 150 && !keepFetching {
                pageCount += 1
                loadMoreData()
            }
        }

        if offSetY < -200 {
            tableView.reloadData()
        }
    }
}

extension SearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField?.resignFirstResponder()
        return true
    }
}
