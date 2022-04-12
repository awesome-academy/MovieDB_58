import UIKit

final class HomeTableViewController: UITableViewController {
    @IBOutlet private weak var tableHeaderImageView: UIImageView?
    @IBOutlet private weak var playButton: UIButton?
    @IBOutlet private weak var tvShowButton: UIButton?
    @IBOutlet private weak var movieButton: UIButton?
    @IBOutlet private weak var categoriesButton: UIButton?
    private let sectionTitles = ["My List", "Trending", "Popular Movie", "Popular TV Shows", "Up Coming"]
    private var movieEnabled = true
    private var tvShowEnabled = true
    private var headerItemId = 0
    private var headerItemIsMovie = true
    private var headerInMyList = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeDimView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        createObserver()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        makePillShapedButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        enableNavBarOnPushedView()
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
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func enableNavBarOnPushedView() {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
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

    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(itemTapped(_:)), name: Notification.Name.itemTappedNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seeAllTapped(_:)), name: Notification.Name.seeAllTappedNotiName, object: nil)
    }

    @objc private func itemTapped(_ notification: Notification) {
        var itemId: Int = 0
        var isMovie: Bool = true
        if let userInfo = notification.userInfo?["userInfo"] as? [String: Any] {
            itemId = userInfo["id"] as? Int ?? 0
            isMovie = userInfo["isMovie"] as? Bool ?? true
        }
        let detailVC = DetailTableViewController(id: itemId, isMovie: isMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc private func seeAllTapped(_ notification: Notification) {
        var sectionTitle: String = ""
        if let userInfo = notification.userInfo?["userInfo"] as? [String: Any] {
            sectionTitle = userInfo["sectionTitle"] as? String ?? ""
        }
        guard let seeAllVC = storyboard?.instantiateViewController(withIdentifier: "SeeAllViewController") else { return }
        navigationController?.pushViewController(seeAllVC, animated: true)
    }

    @objc private func searchButtonTapped() {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") else { return }
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        let detailVC = DetailTableViewController(id: headerItemId, isMovie: headerItemIsMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @IBAction private func addToMyListTapped(_ sender: UIButton) {
        guard let image = UIImage(systemName: "heart.fill") else { return }

        if headerInMyList != true {
            headerInMyList = true
            sender.setImage(image, for: .normal)
        } else {
            headerInMyList = false
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @IBAction private func tvShowButtonTapped(_ sender: UIButton) {
        tvShowEnabled = true
        movieEnabled = false
        tvShowButton?.titleLabel?.textColor = .white
        movieButton?.titleLabel?.textColor = .lightGray

        tableView.reloadData()
    }

    @IBAction private func movieButtonTapped(_ sender: UIButton) {
        movieEnabled = true
        tvShowEnabled = false
        movieButton?.titleLabel?.textColor = .white
        tvShowButton?.titleLabel?.textColor = .lightGray

        tableView.reloadData()
    }

    @IBAction private func playButtonTapped(_ sender: UIButton) {
        print("Play header item trailer video on youtube!")
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
