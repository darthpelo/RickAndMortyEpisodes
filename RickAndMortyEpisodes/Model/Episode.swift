import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}

extension Episode {
    var formattedAirDate: String {
        LocalizedString.formatAirDate(airDate)
    }
}
