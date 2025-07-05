import Foundation
@testable import RickAndMortyEpisodes

/// Mock implementation of EpisodeCaching for testing
class MockEpisodeCache: EpisodeCaching {
    var storedEpisodes: [Episode]?
    var saveEpisodesCalled = false
    var loadEpisodesCalled = false
    var clearEpisodesCacheCalled = false

    func saveEpisodes(_ episodes: [Episode]) {
        saveEpisodesCalled = true
        storedEpisodes = episodes
    }

    func loadEpisodes() -> [Episode]? {
        loadEpisodesCalled = true
        return storedEpisodes
    }

    func clearEpisodesCache() {
        clearEpisodesCacheCalled = true
        storedEpisodes = nil
    }
}
