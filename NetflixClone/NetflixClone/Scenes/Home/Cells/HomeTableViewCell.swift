import UIKit

final class HomeTableViewCell: UITableViewCell, ReuseableView {
    private var itemId: Int = 1
    private var itemIsMovie = false
    private var idList = [Int]()
    private var posterList = [String]()
    private var isMovieList = [Bool]()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 101, height: 145)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(ListCollectionViewCell.nib, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    public func configDataHomeCollectionViewCell(idListTemp: [Int], posterListTemp: [String], isMovieListTemp: [Bool]) {
        idList = idListTemp
        posterList = posterListTemp
        isMovieList = isMovieListTemp
        collectionView.reloadData()
    }

    private func configUICell(cell: UICollectionViewCell) {
        cell.layer.cornerRadius = 5
    }

    private func setContentForCell(cell: ListCollectionViewCell, id: Int, posterPath: String, isMovie: Bool) {
        cell.cellImage?.setImageByUrl(url: posterPath)
        itemId = id
        itemIsMovie = isMovie
        itemIsMovie = isMovie

    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        configUICell(cell: cell)
        setContentForCell(cell: cell, id: idList[indexPath.item], posterPath: posterList[indexPath.item], isMovie: isMovieList[indexPath.item])

        return cell
    }
}

extension HomeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let notiName = Notification.Name(rawValue: "com.Turacle.itemTapped")
        let userInfo = ["userInfo": ["id": itemId, "isMovie": itemIsMovie]]
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: userInfo)
    }
}
