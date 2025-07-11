@testable import RickAndMortyEpisodes
import XCTest

@MainActor
final class CharacterDetailLoaderViewModelTests: XCTestCase {
    var mockFetcher: MockCharacterFetcher!
    var sut: CharacterDetailLoaderViewModel!

    override func setUp() {
        super.setUp()
        mockFetcher = MockCharacterFetcher()
        sut = CharacterDetailLoaderViewModel(fetcher: mockFetcher)
    }

    override func tearDown() {
        mockFetcher = nil
        sut = nil
        super.tearDown()
    }

    func testLoadCharacterSuccess() async {
        // Given
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )
        mockFetcher.characterResult = .success(character)
        // When
        await sut.loadCharacter(id: 1)
        // Then
        if case .success(let loaded) = sut.state {
            XCTAssertEqual(loaded.id, 1)
            XCTAssertEqual(loaded.name, "Rick Sanchez")
        } else {
            XCTFail("Expected success state")
        }
    }

    func testLoadCharacterFailure() async {
        // Given
        struct DummyError: Error {}
        mockFetcher.characterResult = .failure(DummyError())
        // When
        await sut.loadCharacter(id: 1)
        // Then
        if case .failure(let message) = sut.state {
            XCTAssertEqual(message, LocalizedString.failedToLoadCharacter)
        } else {
            XCTFail("Expected failure state")
        }
    }

    func testStateIsLoadingWhileFetching() async {
        // Given
        mockFetcher.characterResult = .success(Character(
            id: 1, name: "", status: "", species: "", type: "", gender: "", origin: Origin(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [], url: "", created: ""
        ))
        var states: [CharacterDetailLoaderState] = []
        let cancellable = sut.$state.sink { states.append($0) }
        // When
        await sut.loadCharacter(id: 1)
        // Then
        XCTAssertTrue(states.contains(.loading), "Expected .loading state in the sequence")
        cancellable.cancel()
    }
}
