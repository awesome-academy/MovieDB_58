import UIKit

final class ItemCastTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet private weak var collectionView: UICollectionView?
    private var directorName: String?
    private var directorProfilePath: String?
    private var castProfilePaths = [String]()
    private var castNameList = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUICell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = .black
    }

    private func configUICell() {
        guard let collectionView = collectionView else { return }
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 101, height: 195)
        collectionView.backgroundColor = .black
        collectionView.collectionViewLayout = layout
        collectionView.register(ItemCastCollectionViewCell.nib, forCellWithReuseIdentifier: ItemCastCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }

    func configDataItemCastCollectionViewCell(profilePathList: [String], castNameList: [String], directorProfilePathList: String?, directorName: String?) {
        self.directorName = directorName
        self.directorProfilePath = directorProfilePathList
        self.castNameList = castNameList
        self.castProfilePaths = profilePathList
    }

    private func setContentForCell(cell: ItemCastCollectionViewCell, indexPath: IndexPath) {
        cell.configCastJobLabel(indexPath: indexPath, directorName: directorName)
        if indexPath.item == 0 && directorName != nil {
            cell.cellCastName?.text = directorName
            cell.cellCastImage?.setImageByUrl(url: directorProfilePath ?? "")
        }

        if indexPath.item != 0 {
            cell.cellCastName?.text = castNameList[indexPath.item - 1]
            cell.cellCastImage?.setImageByUrl(url: castProfilePaths[indexPath.item - 1])
        }
    }
}

extension ItemCastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castNameList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCastCollectionViewCell.identifier, for: indexPath)
                as? ItemCastCollectionViewCell else { return UICollectionViewCell()}

        cell.configCastJobLabel(indexPath: indexPath, directorName: directorName)
        setContentForCell(cell: cell, indexPath: indexPath)

        return cell
    }
}

extension ItemCastTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
