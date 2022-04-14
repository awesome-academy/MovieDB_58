import Foundation

private extension URL {
    static func makeForEndPoints(endpoint: String) -> URL {
        return URL(string: "\(Constants.baseURL)/\(endpoint)?api_key=\(Constants.apiKey)") ?? URL(fileURLWithPath: "")
    }

    static func makeForImageEndPoints(endpoint: String) -> URL {
        return URL(string: "\(Constants.baseImageURL)/\(endpoint)") ?? URL(fileURLWithPath: "")
    }

    static func makeForDiscoverEndPoints(endpoint: String) -> URL {
        return URL(string: "\(Constants.baseDiscoverURL)/\(endpoint)") ?? URL(fileURLWithPath: "")
    }

    static func makeForSearchEndPoints(endpoint: String) -> URL {
        return URL(string: "\(Constants.baseSearchURL)\(endpoint)") ?? URL(fileURLWithPath: "")
    }
}

enum EndPoint {
    case list(listType: ListType, mediaType: MediaType)
    case discoverList(mediaType: MediaType, genreId: Int)
    case detail(mediaType: MediaType, id: Int)
    case genre(mediaType: MediaType)
    case search(query: String, page: Int)
    case image(url: String)
}

extension EndPoint {
    var url: URL {
        switch self {
        case .list(listType: let listType, mediaType: let mediaType):
            switch listType {
            case .trending:
                return .makeForEndPoints(endpoint: "trending/\(mediaType.rawValue)/week")
            case .popular:
                return .makeForEndPoints(endpoint: "\(mediaType.rawValue)/popular")
            }
        case .discoverList(mediaType: let mediaType, genreId: let genreId):
            return .makeForDiscoverEndPoints(endpoint: "\(mediaType.rawValue)?api_key=\(Constants.apiKey)&with_genres=\(genreId)")
        case .detail(mediaType: let mediaType, id: let id):
            return .makeForEndPoints(endpoint: "\(mediaType.rawValue)/\(id)")
        case .genre(mediaType: let mediaType):
            return .makeForEndPoints(endpoint: "genre/\(mediaType.rawValue)/list")
        case .search(query: let query, page: let page):
            return .makeForSearchEndPoints(endpoint: "?api_key=\(Constants.apiKey)&query=\(query)&page=\(page)")
        case .image(url: let url):
            return .makeForImageEndPoints(endpoint: "\(url)")
        }
    }
}
