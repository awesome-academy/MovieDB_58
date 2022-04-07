import Foundation

struct CreatedBy: Codable {
    let id: Int
    let creditId: String?
    let name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditId = "credit_id"
        case name
        case gender
        case profilePath = "profile_path"
    }
}
