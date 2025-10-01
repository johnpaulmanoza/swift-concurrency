import Foundation

struct Album: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
    }
}
