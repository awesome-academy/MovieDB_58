import UIKit

final class HomeTableViewController: UITableViewController {
    @IBOutlet private weak var tableHeaderImageView: UIImageView?
    @IBOutlet private weak var playButton: UIButton?
    private let sectionTitles = ["My List", "Trending", "Popular Movie", "Popular TV Shows", "Up Coming"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        makeDimView()
        makePillShapedButton()
    }
    // MARK: - Function
    private func fetchData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            let thisVC = self ?? UITableViewController()
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getList(listType: .trending, mediaType: .all, viewController: thisVC)
            apiRepo.getGenre(mediaType: .tvShow, viewController: thisVC)
            apiRepo.getGenre(mediaType: .movie, viewController: thisVC)
            group.leave()
            group.wait()
            // Update UI
            group.notify(queue: .main) {
                self?.tableView.reloadData()
                print("Fetching is done!")
            }
        }
    }

    private func setUpNavigationBar() {
        // Logo
        let logo = UIImage(named: "netflix 1")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        // Search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: nil, action: nil)
        searchButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.hidesBarsOnSwipe = true
    }

    private func makeDimView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = tableHeaderImageView?.bounds ?? CGRect()
        tableHeaderImageView?.layer.addSublayer(gradientLayer)
    }

    private func makePillShapedButton() {
        playButton?.layer.cornerRadius = 5
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed(SectionHeaderCell.identifier, owner: self)?.first as? SectionHeaderCell else {
            return UIView()
        }

        headerView.sectionTitle.text = sectionTitles[section]

        return headerView
    }
}
