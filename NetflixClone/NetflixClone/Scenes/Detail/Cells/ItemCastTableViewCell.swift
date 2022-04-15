import UIKit

final class ItemCastTableViewCell: UITableViewCell, ReuseableView {
    @IBOutlet private weak var collectionView: UICollectionView?

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

}

extension ItemCastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCastCollectionViewCell.identifier, for: indexPath)
                as? ItemCastCollectionViewCell else { return UICollectionViewCell()}

        cell.configCastJobLabel(indexPath: indexPath)

        return cell
    }
}

extension ItemCastTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
