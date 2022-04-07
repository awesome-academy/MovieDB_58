import Foundation

struct Casts: Codable {
    let cast: [Cast]
}

struct Cast: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let character: String?
    let creditId: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case character = "character"
        case creditId = "credit_id"
        case order
    }
}
