import Foundation
@testable import RickAndMortyEpisodes

class MockCharacterFetcher: EpisodeFetching {
    var characterResult: Result<Character, Error>?

    func fetchCharacter(id: Int) async throws -> Character {
        if let result = characterResult {
            switch result {
            case .success(let character): return character
            case .failure(let error): throw error
            }
        }
        fatalError("MockCharacterFetcher.characterResult not set")
    }

    func fetchEpisodes(page: Int) async throws -> EpisodeResponse {
        fatalError("Not implemented in this mock")
    }
}
