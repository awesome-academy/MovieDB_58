import UIKit

final class CategoryViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var tableView: UITableView?
    private let backgroundColor = UIColor.black.withAlphaComponent(0.0)
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var movieGenres = [Genre]()
    private var tvGenres = [Genre]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configView()
        fetchData()
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

    private func fetchData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let thisVC = self
            let group = DispatchGroup()

            group.enter()
            apiRepo.getGenreCategory(mediaType: .tvShow, viewController: thisVC) {(genresArray: Genres) in
                self.tvGenres.append(contentsOf: genresArray.genres)
                group.leave()
            }
            group.enter()
            apiRepo.getGenreCategory(mediaType: .movie, viewController: thisVC) {(genresArray: Genres) in
                self.movieGenres.append(contentsOf: genresArray.genres)
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.tableView?.reloadData()
                print("Fetching is done!")
            }
        }
    }

    private func setContentForCell(cell: UITableViewCell, indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.textLabel?.text = "All genres"
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = movieGenres[indexPath.row].name
        }
        if indexPath.section == 2 {
            cell.textLabel?.text = tvGenres[indexPath.row].name
        }
    }

    @IBAction private func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        if section == 1 {
            return movieGenres.count
        }

        return tvGenres.count
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Movie Genres"
        }

        if section == 2 {
            return "TV Show Genres"
        }
        return ""
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
