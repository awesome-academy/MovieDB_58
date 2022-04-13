import UIKit

final class HomeTableViewController: UITableViewController {
    @IBOutlet private weak var tableHeaderImageView: UIImageView?
    @IBOutlet private weak var playButton: UIButton?
    @IBOutlet private weak var tvShowButton: UIButton?
    @IBOutlet private weak var movieButton: UIButton?
    @IBOutlet private weak var categoriesButton: UIButton?
    @IBOutlet weak var headerTitle: UILabel?
    @IBOutlet weak var headerGenres: UILabel?
    
    private let sectionTitles = ["My List", "Trending", "Popular Movie", "Popular TV Show"]
    private var movieEnabled = true
    private var tvShowEnabled = true
    private var headerItemId = 0
    private var headerItemIsMovie = true
    private var headerInMyList = false
    private var myList = [ListedItem]()
    private var trendingList = [ListedItem]()
    private var popularMovieList = [ListedItem]()
    private var popularTvshowList = [ListedItem]()
    private var movieGenres = [Genre]()
    private var tvGenres = [Genre]()

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
        super.viewWillAppear(animated)
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
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            self.fetchAllMediaTypeData()
            group.leave()

            group.enter()
            apiRepo.getGenre(mediaType: .tvShow, viewController: self) { (genresArray: Genres) in
                self.tvGenres.append(contentsOf: genresArray.genres)
                group.leave()
            }

            group.enter()
            apiRepo.getGenre(mediaType: .movie, viewController: self) { (genresArray: Genres) in
                self.movieGenres.append(contentsOf: genresArray.genres)
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.tableView.reloadData()
                print("Fetching is done!")
            }
        }
    }

    private func fetchAllMediaTypeData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getList(listType: .trending, mediaType: .all, viewController: self) { (listedArray: ListedItems) in
                self.trendingList = [ListedItem]()
                self.trendingList.append(contentsOf: listedArray.results)
                group.leave()
            }

            group.enter()
            apiRepo.getList(listType: .popular, mediaType: .movie, viewController: self) { (listedArray: ListedItems) in
                self.popularMovieList = [ListedItem]()
                self.popularMovieList.append(contentsOf: listedArray.results)
                group.leave()
            }

            group.enter()
            apiRepo.getList(listType: .popular, mediaType: .tvShow, viewController: self) { (listedArray: ListedItems) in
                self.popularTvshowList = [ListedItem]()
                self.popularTvshowList.append(contentsOf: listedArray.results)
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.configHeaderItem(apiRepo: apiRepo)
                self.tableView.reloadData()
                print("Fetching all media type data is done!")
            }
        }
    }

    private func fetchRequiredMediaType(mediaType: MediaType) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getList(listType: .trending, mediaType: mediaType, viewController: self) { (listedArray: ListedItems) in
                self.trendingList = [ListedItem]()
                self.trendingList.append(contentsOf: listedArray.results)
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.configHeaderItem(apiRepo: apiRepo)
                self.tableView.reloadData()
                print("Fetching \(mediaType) media type data is done!")
            }
        }
    }

    private func fetchRequiredMediaTypeWithGenre(mediaType: MediaType, genreID: Int) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            group.enter()
            apiRepo.getList(listType: .trending, mediaType: mediaType, viewController: self) { (listedArray: ListedItems) in
                self.trendingList = [ListedItem]()
                self.trendingList.append(contentsOf: listedArray.results)
                group.leave()
            }

            group.enter()
            apiRepo.getDiscoverList(mediaType: mediaType, genreId: genreID, viewController: self) { (listedArray: ListedItems) in
                switch mediaType {
                case .all:
                    return
                case .movie:
                    self.popularMovieList = [ListedItem]()
                    self.popularMovieList.append(contentsOf: listedArray.results)

                case .tvShow:
                    self.popularTvshowList = [ListedItem]()
                    self.popularTvshowList.append(contentsOf: listedArray.results)
                }
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.configHeaderItem(apiRepo: apiRepo)
                self.tableView.reloadData()
                print("Fetching \(mediaType) with genreID: \(genreID) data is done!")
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

    private func configHeaderItem(apiRepo: APIRepository) {
        var headerGenresString = ""
        var headerGenresArray = [String]()
        // Header image
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            guard let imageURL = self.trendingList[0].posterPath else { return }
            apiRepo.getImage(url: imageURL) { (result: Result<Data, Error>) in
                switch result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.tableHeaderImageView?.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.tableHeaderImageView?.image = UIImage(named: "placeHolder")
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        // Header Info
        headerTitle?.text = self.trendingList[0].name?.uppercased() ?? self.trendingList[0].title?.uppercased()
        headerGenresArray = getHeaderGenres()
        headerGenresString = headerGenresArray.joined(separator: " • ")
        headerGenres?.text = headerGenresString
    }

    private func getHeaderGenres() -> [String] {
        guard let genresId = trendingList[0].genreIDs else { return [String]() }
        var returnArray = [String]()
        if trendingList[0].name == nil || trendingList[0].originalName == nil {
            _ = genresId.map { genreId in
                movieGenres.map { movieGenre in
                    if genreId == movieGenre.id {
                        returnArray.append(movieGenre.name ?? "Error")
                    }
                }
            }
        } else {
            _ = genresId.map { genreId in
                tvGenres.map { tvGenre in
                    if genreId == tvGenre.id {
                        returnArray.append(tvGenre.name ?? "Error")
                    }
                }
            }
        }
        return returnArray
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

    private func setContentForCell(cell: HomeTableViewCell, array: [ListedItem]) {
        let posterPathList = getPosterPathFromArray(array: array)
        let idList = getIdFromArray(array: array)
        cell.configDataHomeCollectionViewCell(idListTemp: idList, posterListTemp: posterPathList)
    }

    private func getIdFromArray(array: [ListedItem]) -> [Int] {
        var idList = [Int]()
        _ = array.map({ element in
            idList.append(element.id)
        })
        return idList
    }

    private func getPosterPathFromArray(array: [ListedItem]) -> [String] {
        var posterPathList = [String]()
        for element in array {
            posterPathList.append(element.posterPath ?? "No value")
        }
        return posterPathList
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
        fetchRequiredMediaType(mediaType: .tvShow)

        tableView.reloadData()
    }

    @IBAction private func movieButtonTapped(_ sender: UIButton) {
        movieEnabled = true
        tvShowEnabled = false
        movieButton?.titleLabel?.textColor = .white
        tvShowButton?.titleLabel?.textColor = .lightGray
        fetchRequiredMediaType(mediaType: .movie)

        tableView.reloadData()
    }
    @IBAction func categoriesButtonTapped(_ sender: UIButton) {
        guard let categoryVC = storyboard?.instantiateViewController(withIdentifier: "CategoryScreen") as? CategoryViewController else { return }
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        categoryVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        categoryVC.categorySelectionDelegate = self
        self.present(categoryVC, animated: true)
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
        let sections: Sections = Sections(rawValue: indexPath.section) ?? .trending
        switch sections {
        case .myList:
            setContentForCell(cell: cell, array: myList)
        case .trending:
            setContentForCell(cell: cell, array: trendingList)
        case .popularMovie:
            setContentForCell(cell: cell, array: popularMovieList)
        case .popularTvShow:
            setContentForCell(cell: cell, array: popularTvshowList)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let homeSection: Sections = Sections(rawValue: indexPath.section) else { return 0 }
        switch homeSection {
        case .myList:
            return 150
        case .trending:
            return 150
        case .popularMovie:
            return movieEnabled ? 150 : 0
        case .popularTvShow:
            return tvShowEnabled ? 150 : 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let homeSection: Sections = Sections(rawValue: section) else { return 0 }
        switch homeSection {
        case .myList:
            return 45
        case .trending:
            return 45
        case .popularMovie:
            return movieEnabled ? 45 : 0
        case .popularTvShow:
            return tvShowEnabled ? 45 : 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed(SectionHeaderCell.identifier, owner: self)?.first as? SectionHeaderCell else {
            return UIView()
        }

        headerView.sectionTitle?.text = sectionTitles[section]

        return headerView
    }
}

extension HomeTableViewController: CategorySelectionDelegate {
    func allCategoryTapped() {
        categoriesButton?.titleLabel?.text = nil
        tvShowButton?.isHidden = false
        movieButton?.isHidden = false
        movieEnabled = true
        tvShowEnabled = true
        tvShowButton?.titleLabel?.textColor = .white
        movieButton?.titleLabel?.textColor = .white
        categoriesButton?.titleLabel?.text = "Categories"
        fetchAllMediaTypeData()
        tableView.reloadData()
    }

    func mediaTypeCategoryTapped(mediaType: MediaType, genreId: Int, genreName: String) {
        categoriesButton?.titleLabel?.text = nil
        switch mediaType {
        case .all:
            return
        case .movie:
            movieButton?.isHidden = false
            tvShowButton?.isHidden = true
            categoriesButton?.titleLabel?.text = genreName
            categoriesButton?.titleLabel?.textAlignment = .center
            fetchRequiredMediaTypeWithGenre(mediaType: .movie, genreID: genreId)
            movieEnabled = true
            tvShowEnabled = false
            tvShowButton?.titleLabel?.textColor = .lightGray
            movieButton?.titleLabel?.textColor = .white
        case .tvShow:
            movieButton?.isHidden = true
            tvShowButton?.isHidden = false
            categoriesButton?.titleLabel?.text = genreName
            categoriesButton?.titleLabel?.textAlignment = .center
            fetchRequiredMediaTypeWithGenre(mediaType: .tvShow, genreID: genreId)
            movieEnabled = false
            tvShowEnabled = true
            tvShowButton?.titleLabel?.textColor = .white
            movieButton?.titleLabel?.textColor = .lightGray
        }
        tableView.reloadData()
    }
}
