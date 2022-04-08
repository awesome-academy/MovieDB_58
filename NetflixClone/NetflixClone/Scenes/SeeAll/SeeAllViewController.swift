import UIKit

final class SeeAllViewController: UIViewController {
    @IBOutlet private weak var viewTitle: UILabel?
    @IBOutlet private weak var collectionView: UICollectionView?
    private var searchTitle: String = ""

    //TODO Update later
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle?.text = "Trending"
        // Do any additional setup after loading the view.
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

    private func setContentForCell(cell: SeeAllCollectionViewCell, indexPath: IndexPath) {
        cell.cellImage?.image = UIImage(named: "Image")
    }
}

extension SeeAllViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    //TODO Update later
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeAllCell", for: indexPath) as? SeeAllCollectionViewCell else {
            return UICollectionViewCell()
        }
        setContentForCell(cell: cell, indexPath: indexPath)
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
