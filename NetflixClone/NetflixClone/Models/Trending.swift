import Foundation

struct Items: Codable {
    let results: [TrendingItem]
}

struct Item: Codable {
    let posterPath: String?
    let audult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]?
    let id: Int?
    let originalTitle: String?
    let originalName: String?
    let originalLanguage: String?
    let title: String?
    let name: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
}
