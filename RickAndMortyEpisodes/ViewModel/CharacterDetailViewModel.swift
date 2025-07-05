import Foundation

@MainActor
final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    let character: Character
    var imageURL: URL? { URL(string: character.image) }
    var name: String { character.name }
    var status: String { character.status }
    var species: String { character.species }
    var originName: String { character.origin.name }
    var episodeCount: Int { character.episode.count }

    init(character: Character) {
        self.character = character
    }

    func exportCharacterDetails() throws -> URL {
        let exportDict: [String: Any] = [
            "name": character.name,
            "status": character.status,
            "species": character.species,
            "origin": character.origin.name,
            "episodeCount": character.episode.count
        ]
        let data = try JSONSerialization.data(withJSONObject: exportDict, options: [.prettyPrinted])
        let fileName = "character_\(character.id)_details.json"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        return fileURL
    }
}
