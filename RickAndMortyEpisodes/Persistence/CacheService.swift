import Foundation

public protocol KeyValueStore {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: KeyValueStore {}

final class CacheService: EpisodeCaching {
    static let shared = CacheService()
    private let store: KeyValueStore
    init(store: KeyValueStore = UserDefaults.standard) {
        self.store = store
    }
    
    private let episodesKey = "cachedEpisodes"
    private let charactersKey = "cachedCharacters"
    
    func saveEpisodes(_ episodes: [Episode]) {
        if let data = try? JSONEncoder().encode(episodes) {
            store.set(data, forKey: episodesKey)
        }
    }
    
    func loadEpisodes() -> [Episode]? {
        guard let data = store.data(forKey: episodesKey) else { return nil }
        return try? JSONDecoder().decode([Episode].self, from: data)
    }
    
    func saveCharacters(_ characters: [Character]) {
        if let data = try? JSONEncoder().encode(characters) {
            store.set(data, forKey: charactersKey)
        }
    }
    
    func loadCharacters() -> [Character]? {
        guard let data = store.data(forKey: charactersKey) else { return nil }
        return try? JSONDecoder().decode([Character].self, from: data)
    }
    
    func clearEpisodesCache() {
        store.set(nil, forKey: episodesKey)
    }
} 
