@testable import RickAndMortyEpisodes
import XCTest

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
}
