import Foundation
import UIKit

protocol APIRepositoryType {

    func getList(listType: ListType, mediaType: MediaType, viewController: UITableViewController, completion: @escaping (ListedItems) -> Void)
    func getDiscoverList(mediaType: MediaType, genreId: Int, viewController: UITableViewController, completion: @escaping (ListedItems) -> Void)
    func getMovieDetail(id: Int, viewController: UITableViewController, completion: @escaping (MovieDetail) -> Void)
    func getTvDetail(id: Int, viewController: UITableViewController, completion: @escaping (TvDetail) -> Void)
    func getGenre(mediaType: MediaType, viewController: UITableViewController, completion: @escaping (Genres) -> Void)
    func getGenreCategory(mediaType: MediaType, viewController: UIViewController, completion: @escaping (Genres) -> Void)
    func getSearchList(query: String, page: Int, viewController: UITableViewController, completion: @escaping ((Result<ListedItems, Error>)) -> Void)
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
    func getCreditCast(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<Casts, Error>) -> Void)
    func getCreditCrew(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<Crews, Error>) -> Void)
    func getSimilarItem(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<ListedItems, Error>) -> Void)
}

class APIRepository: APIRepositoryType {
    func getList(listType: ListType, mediaType: MediaType, viewController: UITableViewController, completion: @escaping (ListedItems) -> Void) {
        let endPoint = EndPoint.list(listType: listType, mediaType: mediaType)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getDiscoverList(mediaType: MediaType, genreId: Int, viewController: UITableViewController, completion: @escaping (ListedItems) -> Void) {
        let endPoint = EndPoint.discoverList(mediaType: mediaType, genreId: genreId)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getMovieDetail(id: Int, viewController: UITableViewController, completion: @escaping (MovieDetail) -> Void) {
        let endPoint = EndPoint.detail(mediaType: MediaType.movie, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getTvDetail(id: Int, viewController: UITableViewController, completion: @escaping (TvDetail) -> Void) {
        let endPoint = EndPoint.detail(mediaType: MediaType.tvShow, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<TvDetail, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getGenre(mediaType: MediaType, viewController: UITableViewController, completion: @escaping (Genres) -> Void) {
        let endPoint = EndPoint.genre(mediaType: mediaType)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<Genres, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupError(error: error, viewController: viewController)
            }
        }
    }

    func getGenreCategory(mediaType: MediaType, viewController: UIViewController, completion: @escaping (Genres) -> Void) {
        let endPoint = EndPoint.genre(mediaType: mediaType)

        APICaller.shared.getJSON(endPoint: endPoint) { [weak self] (result: Result<Genres, Error>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                self?.popupErrorCategory(error: error, viewController: viewController)
            }
        }
    }

    func getSearchList(query: String, page: Int, viewController: UITableViewController, completion: @escaping ((Result<ListedItems, Error>)) -> Void) {
        let endPoint = EndPoint.search(query: query, page: page)

        APICaller.shared.getJSON(endPoint: endPoint) { (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getImage(url: String, completion: @escaping ((Result<Data, Error>)) -> Void) {
        let endPoint = EndPoint.image(url: url)

        APICaller.shared.getImage(endPoint: endPoint) {(result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCreditCast(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<Casts, Error>) -> Void) {
        let endPoint = EndPoint.credit(mediaType: mediaType, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { (result: Result<Casts, Error>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCreditCrew(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<Crews, Error>) -> Void) {
        let endPoint = EndPoint.credit(mediaType: mediaType, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { (result: Result<Crews, Error>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSimilarItem(mediaType: CreditMediaType, id: Int, completion: @escaping (Result<ListedItems, Error>) -> Void) {
        let endPoint = EndPoint.similarItem(mediaType: mediaType, id: id)

        APICaller.shared.getJSON(endPoint: endPoint) { (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
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

    func popupErrorCategory(error: Error, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
}
