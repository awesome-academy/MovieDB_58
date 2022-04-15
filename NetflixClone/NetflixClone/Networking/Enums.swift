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

enum CategorySection: Int {
    case all = 0
    case movie = 1
    case tvShow = 2
}

enum DetailSection: Int {
    case itemBanner = 0
    case itemCast = 1
    case interact = 2
    case moreLikeThis = 3
}
