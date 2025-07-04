import XCTest
@testable import RickAndMortyEpisodes

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    var sut: CharacterDetailViewModel!
    var character: Character!

    override func setUp() {
        super.setUp()
        let origin = Origin(name: "Earth", url: "")
        let location = Location(name: "Earth", url: "")
        character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: origin,
            location: location,
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: ["url1", "url2"],
            url: "",
            created: ""
        )
        sut = CharacterDetailViewModel(character: character)
    }

    override func tearDown() {
        sut = nil
        character = nil
        super.tearDown()
    }

    func testExposedProperties() async {
        // Given: a character
        // When: initializing the view model
        // Then: all properties should be exposed correctly
        XCTAssertEqual(sut.name, "Rick Sanchez")
        XCTAssertEqual(sut.status, "Alive")
        XCTAssertEqual(sut.species, "Human")
        XCTAssertEqual(sut.originName, "Earth")
        XCTAssertEqual(sut.episodeCount, 2)
        XCTAssertEqual(sut.imageURL, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
    }

    func testExportCharacterDetailsCreatesJSONFile() async throws {
        // Given: a character
        // When: exporting details
        let fileURL = try sut.exportCharacterDetails()
        // Then: the file should exist and contain the correct JSON
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        XCTAssertEqual(json?["name"] as? String, "Rick Sanchez")
        XCTAssertEqual(json?["status"] as? String, "Alive")
        XCTAssertEqual(json?["species"] as? String, "Human")
        XCTAssertEqual(json?["origin"] as? String, "Earth")
        XCTAssertEqual(json?["episodeCount"] as? Int, 2)
    }
} 
