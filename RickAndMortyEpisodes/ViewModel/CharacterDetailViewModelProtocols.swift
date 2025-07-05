import Foundation

@MainActor
protocol CharacterDetailViewModelProtocol: ObservableObject {
    var character: Character { get }
    var imageURL: URL? { get }
    var name: String { get }
    var status: String { get }
    var species: String { get }
    var originName: String { get }
    var episodeCount: Int { get }
    func exportCharacterDetails() throws -> URL
}
