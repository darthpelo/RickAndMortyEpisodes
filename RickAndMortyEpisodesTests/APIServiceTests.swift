import XCTest
@testable import RickAndMortyEpisodes

final class APIServiceTests: XCTestCase {
    var sut: APIService!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        sut = APIService(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    // Test successful episode parsing
    func testFetchEpisodesSuccess() async throws {
        // Given: a valid JSON response for episodes
        let json = """
        {"info":{"count":1,"pages":1,"next":null,"prev":null},"results":[{"id":1,"name":"Pilot","air_date":"December 2, 2013","episode":"S01E01","characters":[],"url":"https://rickandmortyapi.com/api/episode/1","created":"2017-11-10T12:56:33.798Z"}]}
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        // When: fetching episodes
        let response = try await sut.fetchEpisodes(page: 1)
        // Then: the result should be parsed correctly
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.name, "Pilot")
    }

    // Test successful character parsing
    func testFetchCharacterSuccess() async throws {
        // Given: a valid JSON response for a character
        let json = """
        {"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth","url":""},"location":{"name":"Earth","url":""},"image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg","episode":[],"url":"https://rickandmortyapi.com/api/character/1","created":"2017-11-04T18:48:46.250Z"}
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        // When: fetching a character
        let character = try await sut.fetchCharacter(id: 1)
        // Then: the result should be parsed correctly
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
    }

    // Test network error handling
    func testFetchEpisodesNetworkError() async {
        // Given: a network error is simulated
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        // When: fetching episodes
        do {
            _ = try await sut.fetchEpisodes(page: 1)
            XCTFail("Expected error was not thrown")
        } catch {
            // Then: a URLError should be thrown
            XCTAssertTrue(error is URLError)
        }
    }

    // Test parsing error handling
    func testFetchEpisodesParsingError() async {
        // Given: an invalid JSON response
        let invalidJson = "{".data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJson)
        }
        // When: fetching episodes
        do {
            _ = try await sut.fetchEpisodes(page: 1)
            XCTFail("Expected decoding error was not thrown")
        } catch {
            // Then: a DecodingError should be thrown
            XCTAssertTrue(error is DecodingError)
        }
    }
} 
