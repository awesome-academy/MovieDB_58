import UIKit

final class SeeAllViewController: UIViewController {
    @IBOutlet private weak var viewTitle: UILabel?
    @IBOutlet private weak var collectionView: UICollectionView?

    var searchTitle: String = ""
    var listItem = [ListedItem]()
    private let apiRepo = APIRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewTitle?.text = searchTitle
        setupCollectionView()
    }

    private func setupCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.backgroundColor = .black
        collectionView.register(SeeAllCollectionViewCell.self, forCellWithReuseIdentifier: SeeAllCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
}

extension SeeAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeAllCell", for: indexPath) as? SeeAllCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configUICell(indexPath: indexPath, posterPath: listItem[indexPath.row].posterPath ?? "")
        return cell
    }
}

extension SeeAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 3.2
        let height = view.frame.size.height / 5
        return CGSize(width: width, height: height)
    }
}
