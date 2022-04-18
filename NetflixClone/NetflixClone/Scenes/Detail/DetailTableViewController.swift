import UIKit

final class DetailTableViewController: UITableViewController {
    private var itemBackDrop = ""
    private var itemName = ""
    private var itemReleaseYear = ""
    private var itemIsAdult = false
    private var itemRunTime = 0
    private var itemGenres = [Genre]()
    private var itemGenresText = "Genres: "
    private var itemId: Int = 0
    private var itemIsMovie = false
    private var itemOverview = ""
    private var casts = [Cast]()
    private var crews = [Crew]()
    private var directorName: String?
    private var directorPosterPath: String?
    private var inMyList = false
    private var moreLikeThisList = [ListedItem]()
    private var videoList = [Video]()
    private var playVideo: Bool?

    init(id: Int, isMovie: Bool, playVideo: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.itemId = id
        self.itemIsMovie = isMovie
        self.playVideo = playVideo
    }

    private enum LayoutOptions {
        static let itemBannerRowHeight: CGFloat = 463
        static let itemCastRowHeight: CGFloat = 195
        static let interactRowHeight: CGFloat = 100
        static let moreLikeThisRowHeight: CGFloat = 362
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let mediaType = itemIsMovie ? CreditMediaType.movie : CreditMediaType.tvShow
        fetchData(mediaType: mediaType)
        configView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ItemBannerTableViewCell.nib, forCellReuseIdentifier: ItemBannerTableViewCell.identifier)
        tableView.register(ItemCastTableViewCell.nib, forCellReuseIdentifier: ItemCastTableViewCell.identifier)
        tableView.register(InteractiveTableViewCell.nib, forCellReuseIdentifier: InteractiveTableViewCell.identifier)
        tableView.register(MoreLikeThisTableViewCell.nib, forCellReuseIdentifier: MoreLikeThisTableViewCell.identifier)
    }

    private func fetchData(mediaType: CreditMediaType) {
        DispatchQueue.global(qos: .userInteractive).sync { [weak self] in
            let apiRepo = APIRepository()
            guard let self = self else { return }
            let group = DispatchGroup()
            // Start fetching
            if self.itemIsMovie {
                group.enter()
                apiRepo.getMovieDetail(id: self.itemId, viewController: self) { (movieDetail: MovieDetail) in
                    self.setContentForMovieDetailValue(movieDetail: movieDetail)
                    group.leave()
                }
            } else {
                group.enter()
                apiRepo.getTvDetail(id: self.itemId, viewController: self) { (tvDetail: TvDetail) in
                    self.setContentForTvDetailValue(tvDetail: tvDetail)
                    group.leave()
                }
            }

            group.enter()
            fetchCastNCrew(mediaType: mediaType, apiRepo: apiRepo)
            group.leave()

            group.enter()
            apiRepo.getSimilarItem(mediaType: mediaType, id: self.itemId) { (results: Result<ListedItems, Error>) in
                switch results {
                case .success(let success):
                    self.moreLikeThisList.append(contentsOf: success.results)
                case .failure(let failure):
                    self.popupErrorCategory(error: failure, viewController: self)
                }
                group.leave()
            }

            group.enter()
            apiRepo.getVideo(mediaType: mediaType, id: self.itemId) { (results: Result<Videos, Error>) in
                switch results {
                case .success(let success):
                    self.videoList.append(contentsOf: success.results)
                case .failure(let failure):
                    self.popupErrorCategory(error: failure, viewController: self)
                }
                group.leave()
            }
            // Update UI
            group.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }

    private func setContentForTvDetailValue(tvDetail: TvDetail) {
        itemBackDrop = tvDetail.backdropPath ?? "No backdrop"
        itemName = tvDetail.name ?? tvDetail.originalName ?? "No title"
        itemReleaseYear = String((tvDetail.firstAirDate?.prefix(4) ?? "No release date")) as String
        itemRunTime = tvDetail.episodeRunTime?.first ?? 0
        itemGenres = tvDetail.genres ?? [Genre]()
        itemOverview = tvDetail.overview ?? "No overview"
    }

    private func setContentForMovieDetailValue(movieDetail: MovieDetail) {
        self.itemBackDrop = movieDetail.backdropPath ?? "No backdrop"
        self.itemName = movieDetail.title ?? movieDetail.originalTitle ?? "No title"
        self.itemReleaseYear = String((movieDetail.releaseDate?.prefix(4) ?? "No release date")) as String
        self.itemIsAdult = movieDetail.adult ?? false
        self.itemRunTime = movieDetail.runtime ?? 0
        self.itemGenres = movieDetail.genres ?? [Genre]()
        self.itemOverview = movieDetail.overview ?? "No overview"
    }

    private func fetchCastNCrew(mediaType: CreditMediaType, apiRepo: APIRepository) {
        let group = DispatchGroup()
        group.enter()
        apiRepo.getCreditCast(mediaType: mediaType, id: self.itemId) { (results: Result<Casts, Error>) in
            switch results {
            case .success(let casts):
                self.casts.append(contentsOf: casts.cast)
            case .failure(let failure):
                self.popupErrorCategory(error: failure, viewController: self)
            }
            group.leave()
        }

        group.enter()
        apiRepo.getCreditCrew(mediaType: mediaType, id: self.itemId) { (results: Result<Crews, Error>) in
            switch results {
            case .success(let crews):
                self.crews.append(contentsOf: crews.crew)
            case .failure(let failure):
                self.popupErrorCategory(error: failure, viewController: self)
            }
            group.leave()
        }
    }

    private func getItemGenres() {
        let genreNames = itemGenres.map { $0.name ?? "No genre" }
        itemGenresText += genreNames.joined(separator: ", ")
    }

    private func setBannerImage(cell: ItemBannerTableViewCell) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            let apiRepo = APIRepository()
            let imageURL = self.itemBackDrop
            apiRepo.getImage(url: imageURL) { (result: Result<Data, Error>) in
                switch result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            cell.cellBanner?.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.cellBanner?.image = UIImage(named: "placeHolder")
                        }
                    }
                case .failure(let error):
                    self.popupErrorCategory(error: error, viewController: self)
                }
            }
        }
    }

    private func getItemTrailerKey(array: [Video]) -> String {
        let trailerVideo = array.filter { $0.type == "Trailer" }.first
        guard let trailerKey = trailerVideo?.key else { return "" }
        return trailerKey
    }

    private func setContentForItemBannerCell(cell: ItemBannerTableViewCell) {
        cell.itemBannerCellDelegate = self
        if itemBackDrop.isEmpty {
            tableView.reloadData()
            if casts.isEmpty {
                sleep(2)
                tableView.reloadData()
            }
        }
        getItemGenres()
        cell.cellItemTitle?.text = itemName
        cell.cellItemYear?.text = itemReleaseYear
        cell.cellItemDuration?.text = itemIsMovie ? String(itemRunTime) + "m" : String(itemRunTime) + "m per episode"
        cell.cellItemGenres?.text = itemGenresText
        cell.cellItemDescription?.text = itemOverview
        cell.cellItemGenres?.text = itemGenresText
        setBannerImage(cell: cell)
        cell.videoId = getItemTrailerKey(array: videoList)
        cell.playVideo = playVideo ?? false
    }

    private func getCastPosterPathFromArray(array: [Cast]) -> [String] {
        var posterPathList = [String]()
        for element in array {
            posterPathList.append(element.profilePath ?? "No value")
            if posterPathList.count >= 9 {
                return posterPathList
            }
        }
        return posterPathList
    }

    private func getCastNameFromArray(array: [Cast]) -> [String] {
        var castNameArray = [String]()
        for element in array {
            castNameArray.append(element.name ?? element.originalName ?? "No value")
            if castNameArray.count >= 9 {
                return castNameArray
            }
        }
        return castNameArray
    }

    private func getDirectorInfo(array: [Crew]) {
        for element in array {
            if element.job == "Director" {
                directorPosterPath = element.profilePath
                directorName = element.name ?? element.originalName ?? "No name"
                return
            }
        }
    }

    private func getMoreLikeThisPosterFromArray(array: [ListedItem]) -> [String] {
        var posterList = [String]()
        for element in array {
            posterList.append(element.posterPath ?? "No value")
            if posterList.count >= 6 {
                return posterList
            }
        }
        return posterList
    }

    private func getMoreLikeThisIdFromArray(array: [ListedItem]) -> [Int] {
        var idList = [Int]()
        for element in array {
            idList.append(element.id)
            if idList.count >= 6 {
                return idList
            }
        }
        return idList
    }

    private func getMoreLikeThisIsMovieFromArray(array: [ListedItem]) -> [Bool] {
        var isMovieList = [Bool]()
        for element in array {
            isMovieList.append(element.name == nil ? true : false)
            if isMovieList.count >= 6 {
                return isMovieList
            }
        }
        return isMovieList
    }

    private func setContentForCastCell(cell: ItemCastTableViewCell, castArray: [Cast]) {
        let castProfilePathList = getCastPosterPathFromArray(array: castArray)
        let castNameList = getCastNameFromArray(array: castArray)
        getDirectorInfo(array: crews)

        cell.configDataItemCastCollectionViewCell(profilePathList: castProfilePathList, castNameList: castNameList, directorProfilePathList: directorPosterPath, directorName: directorName)
    }

    private func setContentForMoreLikeThisCell(cell: MoreLikeThisTableViewCell, moreLikeThisArray: [ListedItem]) {
        let moreLikeThisPoterList = getMoreLikeThisPosterFromArray(array: moreLikeThisArray)
        let moreLikeThisIdList = getMoreLikeThisIdFromArray(array: moreLikeThisArray)
        let moreLikeThisIsMovieList = getMoreLikeThisIsMovieFromArray(array: moreLikeThisArray)

        cell.moreLikeThisCellDelegate = self
        cell.configDataMoreLikeThisCollectionViewCell(moreLikeThisPosterList: moreLikeThisPoterList, moreLikeThisIdList: moreLikeThisIdList, moreLikeThisIsMovieList: moreLikeThisIsMovieList)
    }

    private func popupErrorCategory(error: Error, viewController: UITableViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailSection: DetailSection = DetailSection(rawValue: indexPath.row) else { return UITableViewCell() }
        switch detailSection {
        case .itemBanner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemBannerTableViewCell.identifier, for: indexPath) as? ItemBannerTableViewCell else {
                return UITableViewCell()
            }
            setContentForItemBannerCell(cell: cell)
            return cell
        case .itemCast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCastTableViewCell.identifier, for: indexPath) as? ItemCastTableViewCell else {
                return UITableViewCell()
            }
            setContentForCastCell(cell: cell, castArray: casts)
            return cell
        case .interact:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InteractiveTableViewCell.identifier, for: indexPath) as? InteractiveTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .moreLikeThis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreLikeThisTableViewCell.identifier, for: indexPath) as? MoreLikeThisTableViewCell else {
                return UITableViewCell()
            }
            setContentForMoreLikeThisCell(cell: cell, moreLikeThisArray: moreLikeThisList)
            return cell
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let detailSection: DetailSection = DetailSection(rawValue: indexPath.row) else { return 0 }
        switch detailSection {
        case .itemBanner:
            return LayoutOptions.itemBannerRowHeight
        case .itemCast:
            return LayoutOptions.itemCastRowHeight
        case .interact:
            return LayoutOptions.interactRowHeight
        case .moreLikeThis:
            return LayoutOptions.moreLikeThisRowHeight
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        if offSetY < -200 {
            print("Reload")
            tableView.reloadData()
        }
    }
}

extension DetailTableViewController: ItemBannerCellDelegate {
    func seeMoreTapped() {
        let seeMoreVC = SeeMoreViewController(genres: itemGenresText, overview: itemOverview)
        seeMoreVC.isModalInPresentation = true
        navigationController?.pushViewController(seeMoreVC, animated: true)
    }
}

extension DetailTableViewController: MoreLikeThisCellDelegate {
    func itemTapped(indexPath: IndexPath) {
        let moreLikeThisItemId = moreLikeThisList[indexPath.item].id
        let moreLikeThisItemIsMovie = moreLikeThisList[indexPath.item].title != nil ? true : false
        let detailVC = DetailTableViewController(id: moreLikeThisItemId, isMovie: moreLikeThisItemIsMovie, playVideo: false)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
