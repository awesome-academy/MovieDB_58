import UIKit

final class SeeMoreViewController: UIViewController, ReuseableView {
    @IBOutlet weak var genreTextLabel: UILabel?
    @IBOutlet weak var overviewTextLabel: UILabel?

    private var genres = ""
    private var overview = "Overview: \n"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configView()
    }

    init(genres: String, overview: String) {
        super.init(nibName: nil, bundle: nil)
        self.genres = genres
        self.overview += overview
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        view.backgroundColor = .black
        genreTextLabel?.text = genres
        overviewTextLabel?.text = overview
    }
}
