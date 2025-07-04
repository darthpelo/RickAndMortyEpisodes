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

    func testSaveAndLoadEpisodes() {
        // Given
        let episode = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "https://rickandmortyapi.com/api/episode/1", created: "2017-11-10T12:56:33.798Z")
        // When
        sut.saveEpisodes([episode])
        let loaded = sut.loadEpisodes()
        // Then
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "Pilot")
    }

    func testSaveAndLoadCharacters() {
        // Given
        let origin = Origin(name: "Earth", url: "")
        let location = Location(name: "Earth", url: "")
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: origin, location: location, image: "", episode: [], url: "", created: "")
        // When
        sut.saveCharacters([character])
        let loaded = sut.loadCharacters()
        // Then
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "Rick Sanchez")
    }

    func testLoadEpisodesWithCorruptedData() {
        // Given
        mockStore.set(Data([0x00, 0x01, 0x02]), forKey: "cachedEpisodes")
        // When
        let loaded = sut.loadEpisodes()
        // Then
        XCTAssertNil(loaded)
    }

    func testLoadEpisodesWithNoData() {
        // When
        let loaded = sut.loadEpisodes()
        // Then
        XCTAssertNil(loaded)
    }
} 
