import Foundation
import UIKit

class APICaller {
    static let shared = APICaller()
    private init() {
        print("APICaller Singleton initialized!")
    }

    // MARK: Get list
    func getJSON<T: Codable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: endPoint.url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                print(results)
                completion(.success(results))
            } catch {
                print(response ?? "Can't find response")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
