import Foundation
@testable import RickAndMortyEpisodes

/// A mock implementation of KeyValueStore for testing, storing values in memory.
class MockKeyValueStore: KeyValueStore {
    private var storage: [String: Any] = [:]

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    func data(forKey defaultName: String) -> Data? {
        storage[defaultName] as? Data
    }
}
