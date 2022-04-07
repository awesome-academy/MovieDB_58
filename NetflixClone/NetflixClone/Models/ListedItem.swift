import Foundation

struct ListedItems: Codable {
    let results: [ListedItem]
}

struct ListedItem: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]?
    let id: Int
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

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult = "adult"
        case overview
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalName = "original_name"
        case originalLanguage = "original_language"
        case title
        case name
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}
