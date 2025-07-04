import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
} 

extension Episode {
    var formattedAirDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: air_date) {
            return outputFormatter.string(from: date)
        }
        return air_date
    }
}