import Foundation

// Protocol to abstract key-value storage for testability
public protocol KeyValueStore {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

// UserDefaults conforms to KeyValueStore
extension UserDefaults: KeyValueStore {}

final class CacheService: EpisodeCaching {
    // Singleton instance for production use
    static let shared = CacheService()
    // KeyValueStore is injected for testability; defaults to UserDefaults.standard
    private let store: KeyValueStore
    init(store: KeyValueStore = UserDefaults.standard) {
        self.store = store
    }
    
    private let episodesKey = "cachedEpisodes"
    private let charactersKey = "cachedCharacters"
    
    // Saves episodes array to storage
    func saveEpisodes(_ episodes: [Episode]) {
        if let data = try? JSONEncoder().encode(episodes) {
            store.set(data, forKey: episodesKey)
        }
    }
    
    // Loads episodes array from storage
    func loadEpisodes() -> [Episode]? {
        guard let data = store.data(forKey: episodesKey) else { return nil }
        return try? JSONDecoder().decode([Episode].self, from: data)
    }
    
    // Saves characters array to storage
    func saveCharacters(_ characters: [Character]) {
        if let data = try? JSONEncoder().encode(characters) {
            store.set(data, forKey: charactersKey)
        }
    }
    
    // Loads characters array from storage
    func loadCharacters() -> [Character]? {
        guard let data = store.data(forKey: charactersKey) else { return nil }
        return try? JSONDecoder().decode([Character].self, from: data)
    }
} 
