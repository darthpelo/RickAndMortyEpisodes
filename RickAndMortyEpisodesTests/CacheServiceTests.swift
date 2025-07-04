import XCTest
@testable import RickAndMortyEpisodes

final class CacheServiceTests: XCTestCase {
    var sut: CacheService!
    var mockStore: MockKeyValueStore!

    override func setUp() {
        super.setUp()
        mockStore = MockKeyValueStore()
        sut = CacheService(store: mockStore)
    }

    override func tearDown() {
        sut = nil
        mockStore = nil
        super.tearDown()
    }

    // Test saving and loading episodes
    func testSaveAndLoadEpisodes() {
        // Given: an episode to save
        let episode = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "https://rickandmortyapi.com/api/episode/1", created: "2017-11-10T12:56:33.798Z")
        // When: saving and then loading episodes
        sut.saveEpisodes([episode])
        let loaded = sut.loadEpisodes()
        // Then: the loaded episodes should match the saved ones
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "Pilot")
    }

    // Test saving and loading characters
    func testSaveAndLoadCharacters() {
        // Given: a character to save
        let origin = Origin(name: "Earth", url: "")
        let location = Location(name: "Earth", url: "")
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: origin, location: location, image: "", episode: [], url: "", created: "")
        // When: saving and then loading characters
        sut.saveCharacters([character])
        let loaded = sut.loadCharacters()
        // Then: the loaded characters should match the saved ones
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "Rick Sanchez")
    }

    // Test loading episodes with corrupted data
    func testLoadEpisodesWithCorruptedData() {
        // Given: corrupted data is stored
        mockStore.set(Data([0x00, 0x01, 0x02]), forKey: "cachedEpisodes")
        // When: loading episodes
        let loaded = sut.loadEpisodes()
        // Then: the result should be nil
        XCTAssertNil(loaded)
    }

    // Test loading episodes when no data is present
    func testLoadEpisodesWithNoData() {
        // Given: no data is stored
        // When: loading episodes
        let loaded = sut.loadEpisodes()
        // Then: the result should be nil
        XCTAssertNil(loaded)
    }
} 