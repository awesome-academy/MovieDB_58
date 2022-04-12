import UIKit

final class CategoryViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var tableView: UITableView?
    
    private let backgroundColor = UIColor.black.withAlphaComponent(0.0)
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configView()
    }

    private func configView() {
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        guard let closeButton = closeButton else { return }
        blurEffectView.frame = view.bounds
        view.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        closeButton.layer.cornerRadius = 20
    }

    private func setContentForCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.text = "The loai: \(indexPath.row)"
    }

    @IBAction private func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        setContentForCell(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
