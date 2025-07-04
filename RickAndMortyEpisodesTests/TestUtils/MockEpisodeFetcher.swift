import Foundation
@testable import RickAndMortyEpisodes

/// Mock implementation of EpisodeFetching for testing
class MockEpisodeFetcher: EpisodeFetching {
    var result: Result<EpisodeResponse, Error>?
    var fetchEpisodesCalled = false
    var lastRequestedPage: Int?
    
    // For character fetching
    var characterResult: Result<Character, Error>?
    var lastRequestedCharacterID: Int?

    func fetchEpisodes(page: Int) async throws -> EpisodeResponse {
        fetchEpisodesCalled = true
        lastRequestedPage = page
        if let result = result {
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        } else {
            fatalError("MockEpisodeFetcher.result not set")
        }
    }
    
    func fetchCharacter(id: Int) async throws -> Character {
        lastRequestedCharacterID = id
        if let result = characterResult {
            switch result {
            case .success(let character):
                return character
            case .failure(let error):
                throw error
            }
        } else {
            fatalError("MockEpisodeFetcher.characterResult not set")
        }
    }
} 