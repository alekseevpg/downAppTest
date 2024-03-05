import Foundation

struct Profile: Decodable, Hashable {
    let name: String
    let userId: Int64
    let age: Int
    let loc: String?
    let aboutMe: String?
    let profilePicUrl: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case userId = "user_id"
        case age = "age"
        case loc = "loc"
        case aboutMe = "about_me"
        case profilePicUrl = "profile_pic_url"
    }
}
