import Foundation

enum MediaType: String {
    case all = "all"
    case movie = "movie"
    case tvShow = "tv"
}

enum ListType: String {
    case trending
    case popular
}

enum Sections: Int {
    case myList = 0
    case trending = 1
    case popularMovie = 2
    case popularTvShow = 3
}
