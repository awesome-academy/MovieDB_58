import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let baseDiscoverURL = "https://api.themoviedb.org/3/discover"
    static var apiKey: String {
        var keys: NSDictionary?
        var apiKey = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }

        if let dict = keys {
            apiKey = dict["APIKey"] as? String ?? "No APIKey"
        }

        return apiKey
    }
}
