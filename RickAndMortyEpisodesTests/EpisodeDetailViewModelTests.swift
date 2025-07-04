import XCTest
@testable import RickAndMortyEpisodes

@MainActor
final class EpisodeDetailViewModelTests: XCTestCase {
    var sut: EpisodeDetailViewModel!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCharacterIDsExtractionWithCharacters() async {
        // Given
        let episode = Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/42"
            ],
            url: "",
            created: ""
        )
        // When
        sut = EpisodeDetailViewModel(episode: episode)
        // Then
        XCTAssertEqual(sut.characterIDs, [1, 42])
    }

    func testCharacterIDsExtractionWithNoCharacters() async {
        // Given
        let episode = Episode(
            id: 2,
            name: "Lawnmower Dog",
            airDate: "December 9, 2013",
            episode: "S01E02",
            characters: [],
            url: "",
            created: ""
        )
        // When
        sut = EpisodeDetailViewModel(episode: episode)
        // Then
        XCTAssertTrue(sut.characterIDs.isEmpty)
    }

    func testPreloadCharacterNamesSuccess() async {
        // Given
        let episode = Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/2"
            ],
            url: "",
            created: ""
        )
        let mockFetcher = MockEpisodeFetcher()
        let character1 = Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "", gender: "Male", origin: Origin(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        let character2 = Character(id: 2, name: "Morty", status: "Alive", species: "Human", type: "", gender: "Male", origin: Origin(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        mockFetcher.characterResultForID = { id in
            if id == 1 { return .success(character1) }
            if id == 2 { return .success(character2) }
            return .failure(NSError(domain: "Test", code: 1))
        }
        let sut = EpisodeDetailViewModel(episode: episode, fetcher: mockFetcher)
        // When
        await sut.preloadCharacterNames()
        // Then
        XCTAssertEqual(sut.characterNames[1], "Rick")
        XCTAssertEqual(sut.characterNames[2], "Morty")
        XCTAssertFalse(sut.isLoadingNames)
        XCTAssertTrue(sut.errorNames.isEmpty)
    }

    func testPreloadCharacterNamesFailure() async {
        // Given
        let episode = Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01",
            characters: [
                "https://rickandmortyapi.com/api/character/1"
            ],
            url: "",
            created: ""
        )
        let mockFetcher = MockEpisodeFetcher()
        mockFetcher.characterResult = .failure(NSError(domain: "Test", code: 1, userInfo: nil))
        let sut = EpisodeDetailViewModel(episode: episode, fetcher: mockFetcher)
        // When
        await sut.preloadCharacterNames()
        // Then
        XCTAssertEqual(sut.characterNames[1], "N/A")
        XCTAssertFalse(sut.isLoadingNames)
        XCTAssertFalse(sut.errorNames.isEmpty)
    }
} 
