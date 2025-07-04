import XCTest
@testable import RickAndMortyEpisodes

@MainActor
final class EpisodeDetailViewModelTests: XCTestCase {
    var sut: EpisodeDetailViewModel!

    override func setUp() {
        super.setUp()
        // No dependencies to inject, just initialize in each test
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // Test extracting character IDs from episode with characters
    func testCharacterIDsExtractionWithCharacters() async {
        // Given: an episode with character URLs
        let episode = Episode(
            id: 1,
            name: "Pilot",
            air_date: "December 2, 2013",
            episode: "S01E01",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/42"
            ],
            url: "",
            created: ""
        )
        // When: initializing the view model
        sut = EpisodeDetailViewModel(episode: episode)
        // Then: characterIDs should contain the extracted IDs
        XCTAssertEqual(sut.characterIDs, [1, 42])
    }

    // Test extracting character IDs from episode with no characters
    func testCharacterIDsExtractionWithNoCharacters() async {
        // Given: an episode with no character URLs
        let episode = Episode(
            id: 2,
            name: "Lawnmower Dog",
            air_date: "December 9, 2013",
            episode: "S01E02",
            characters: [],
            url: "",
            created: ""
        )
        // When: initializing the view model
        sut = EpisodeDetailViewModel(episode: episode)
        // Then: characterIDs should be empty
        XCTAssertTrue(sut.characterIDs.isEmpty)
    }
} 
