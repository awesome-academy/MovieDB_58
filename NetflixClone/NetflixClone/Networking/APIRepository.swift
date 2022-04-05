import Foundation
import UIKit

protocol APIRepositoryType {

    func getList(listType: ListType, mediaType: MediaType, viewController: UITableViewController)
    func getMovieDetail(id: Int, viewController: UITableViewController)
    func getTvDetail(id: Int, viewController: UITableViewController)
    func getGenre(mediaType: MediaType, viewController: UITableViewController)
}

class APIRepository: APIRepositoryType {
    func getList(listType: ListType, mediaType: MediaType, viewController: UITableViewController) {
        let endPoint = EndPoint.list(listType: listType, mediaType: mediaType)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getMovieDetail(id: Int, viewController: UITableViewController) {
        let endPoint = EndPoint.detail(mediaType: MediaType.movie, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getTvDetail(id: Int, viewController: UITableViewController) {
        let endPoint = EndPoint.detail(mediaType: MediaType.movie, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<TvDetail, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getGenre(mediaType: MediaType, viewController: UITableViewController) {
        let endPoint = EndPoint.genre(mediaType: mediaType)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<Genres, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }
// Popup Error function
    func popupError(error: Error, viewController: UITableViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }

}
