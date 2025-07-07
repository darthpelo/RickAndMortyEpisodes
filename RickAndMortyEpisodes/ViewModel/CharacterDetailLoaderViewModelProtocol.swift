import Foundation

@MainActor
protocol CharacterDetailLoaderViewModelProtocol: ObservableObject {
    var state: CharacterDetailLoaderState { get }
    func loadCharacter(id: Int) async
}
