import Foundation

private extension URL {
    static func makeForEndPoints(endpoint: String) -> URL {
        if let url = URL(string: "\(Constants.baseURL)/\(endpoint)?api_key=\(Constants.apiKey)") {
            return url
        }
        return URL(fileURLWithPath: "")
    }
}

enum EndPoint {
    case list(listType: ListType, mediaType: MediaType)
    case detail(mediaType: MediaType, id: Int)
    case genre(mediaType: MediaType)
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
        case .detail(mediaType: let mediaType, id: let id):
            return .makeForEndPoints(endpoint: "\(mediaType.rawValue)/\(id)")
        case .genre(mediaType: let mediaType):
            return .makeForEndPoints(endpoint: "genre/\(mediaType.rawValue)/list")
        }
    }
}
