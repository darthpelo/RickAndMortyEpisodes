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

    func testFetchEpisodesSuccess() async throws {
        // Given
        let json = """
        {"info":{"count":1,"pages":1,"next":null,"prev":null},"results":[{"id":1,"name":"Pilot","airDate":"December 2, 2013","episode":"S01E01","characters":[],"url":"https://rickandmortyapi.com/api/episode/1","created":"2017-11-10T12:56:33.798Z"}]}
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        // When
        let response = try await sut.fetchEpisodes(page: 1)
        // Then
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.name, "Pilot")
    }

    func testFetchCharacterSuccess() async throws {
        // Given
        let json = """
        {"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth","url":""},"location":{"name":"Earth","url":""},"image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg","episodes":[],"url":"https://rickandmortyapi.com/api/character/1","created":"2017-11-04T18:48:46.250Z"}
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        // When
        let character = try await sut.fetchCharacter(id: 1)
        // Then
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
    }

    func testFetchEpisodesNetworkError() async {
        // Given
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        // When
        do {
            _ = try await sut.fetchEpisodes(page: 1)
            XCTFail("Expected error was not thrown")
        } catch {
            // Then
            XCTAssertTrue(error is URLError)
        }
    }

    func testFetchEpisodesParsingError() async {
        // Given
        let invalidJson = "{".data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJson)
        }
        // When
        do {
            _ = try await sut.fetchEpisodes(page: 1)
            XCTFail("Expected decoding error was not thrown")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
} 
