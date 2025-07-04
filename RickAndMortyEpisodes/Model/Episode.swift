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
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: airDate) {
            return outputFormatter.string(from: date)
        }
        return airDate
    }
}
