import UIKit

protocol MoreLikeThisCellDelegate {
    func itemTapped(indexPath: IndexPath)
}

final class MoreLikeThisTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet private weak var collectionView: UICollectionView?
    private var itemPosterList = [String]()
    private var itemIdList = [Int]()
    private var itemIsMovieList = [Bool]()
    var moreLikeThisCellDelegate: MoreLikeThisCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        guard let collectionView = collectionView else { return }
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = .black
    }

    private func configUIView() {
        guard let collectionView = collectionView else { return }
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 5, right: 1)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .black
        collectionView.register(ListCollectionViewCell.nib, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
    }

    private func configUICell(cell: UICollectionViewCell) {
        cell.layer.cornerRadius = 5
    }

    func configDataMoreLikeThisCollectionViewCell(moreLikeThisPosterList: [String], moreLikeThisIdList: [Int], moreLikeThisIsMovieList: [Bool]) {
        itemPosterList = moreLikeThisPosterList
        itemIdList = moreLikeThisIdList
        itemIsMovieList = moreLikeThisIsMovieList
    }

    private func setContentForCell(cell: ListCollectionViewCell, indexPath: IndexPath) {
        if itemPosterList.isEmpty {
            collectionView?.reloadData()
            return
        }
        cell.cellImage?.setImageByUrl(url: self.itemPosterList[indexPath.item])
    }
}

extension MoreLikeThisTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        configUICell(cell: cell)
        setContentForCell(cell: cell, indexPath: indexPath)

        return cell
    }
}

extension MoreLikeThisTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moreLikeThisCellDelegate?.itemTapped(indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
