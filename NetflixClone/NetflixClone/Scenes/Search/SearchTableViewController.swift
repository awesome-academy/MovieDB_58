import UIKit

final class SearchTableViewController: UITableViewController {
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var searchTextFieldImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configSearchTextField()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func configView() {
        view.backgroundColor = .black
    }

    private func configSearchTextField() {
        guard let searchTextField = searchTextField else {
            return
        }
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

    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        if searchTextField.text?.isEmpty == true {
            searchTextFieldImage?.isHidden = false
            searchTextField.placeholder = "Search"
            searchTextField.textAlignment = .center
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        return cell
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
}
