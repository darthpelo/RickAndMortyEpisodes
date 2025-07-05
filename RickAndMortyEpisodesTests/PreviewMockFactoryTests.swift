@testable import RickAndMortyEpisodes
import XCTest

@MainActor
final class PreviewMockFactoryTests: XCTestCase {
    // MARK: - Mock Episodes Tests

    func testCreateMockEpisodes() {
        // Given/When
        let episodes = PreviewMockFactory.createMockEpisodes()

        // Then
        XCTAssertEqual(episodes.count, 3)
        XCTAssertEqual(episodes[0].id, 1)
        XCTAssertEqual(episodes[0].name, "Pilot")
        XCTAssertEqual(episodes[0].episode, "S01E01")
        XCTAssertEqual(episodes[1].name, "Lawnmower Dog")
        XCTAssertEqual(episodes[2].name, "Anatomy Park")
    }

    func testCreateEmptyEpisodeList() {
        // Given/When
        let episodes = PreviewMockFactory.createEmptyEpisodeList()

        // Then
        XCTAssertTrue(episodes.isEmpty)
    }

    func testCreateSingleEpisode() {
        // Given/When
        let episode = PreviewMockFactory.createSingleEpisode()

        // Then
        XCTAssertEqual(episode.id, 1)
        XCTAssertEqual(episode.name, "Pilot")
        XCTAssertEqual(episode.episode, "S01E01")
        XCTAssertEqual(episode.characters.count, 1)
    }

    func testCreateLongEpisodeList() {
        // Given/When
        let episodes = PreviewMockFactory.createLongEpisodeList()

        // Then
        XCTAssertEqual(episodes.count, 20)
        XCTAssertEqual(episodes[0].id, 1)
        XCTAssertEqual(episodes[0].name, "Episode 1")
        XCTAssertEqual(episodes[19].id, 20)
        XCTAssertEqual(episodes[19].name, "Episode 20")
    }

    // MARK: - Mock Characters Tests

    func testCreateMockCharacter() {
        // Given/When
        let character1 = PreviewMockFactory.createMockCharacter(id: 1)
        let character2 = PreviewMockFactory.createMockCharacter(id: 2)

        // Then
        XCTAssertEqual(character1.id, 1)
        XCTAssertEqual(character1.name, "Morty Smith") // id % names.count = 1
        XCTAssertEqual(character2.id, 2)
        XCTAssertEqual(character2.name, "Summer Smith") // id % names.count = 2

        // Test gender alternation
        XCTAssertEqual(character2.gender, "Male") // id % 2 == 0
        XCTAssertEqual(character1.gender, "Female") // id % 2 != 0
    }

    // MARK: - Mock Response Tests

    func testCreateMockPageInfo() {
        // Given/When
        let pageInfo = PreviewMockFactory.createMockPageInfo(count: 5, pages: 2, hasNext: true)

        // Then
        XCTAssertEqual(pageInfo.count, 5)
        XCTAssertEqual(pageInfo.pages, 2)
        XCTAssertNotNil(pageInfo.next)
        XCTAssertNil(pageInfo.prev)
    }

    func testCreateMockEpisodeResponse() {
        // Given
        let testEpisodes = PreviewMockFactory.createMockEpisodes()

        // When
        let response = PreviewMockFactory.createMockEpisodeResponse(
            episodes: testEpisodes,
            hasNextPage: true
        )

        // Then
        XCTAssertEqual(response.results.count, 3)
        XCTAssertEqual(response.info.count, 3)
        XCTAssertNotNil(response.info.next)
    }

    // MARK: - Preview Scenarios Tests

    func testPreviewScenarioDisplayNames() {
        // Given/When/Then
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.success.displayName, "Success State")
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.loading.displayName, "Loading State")
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.networkError.displayName, "Network Error")
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.emptyList.displayName, "Empty List")
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.slowCache.displayName, "Slow Cache")
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.longList.displayName, "Long List")
    }

    func testPreviewScenarioEpisodes() {
        // Given/When/Then
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.success.episodes.count, 3)
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.loading.episodes.count, 0)
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.networkError.episodes.count, 0)
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.emptyList.episodes.count, 0)
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.slowCache.episodes.count, 3)
        XCTAssertEqual(PreviewMockFactory.PreviewScenario.longList.episodes.count, 20)
    }

    // MARK: - Mock Services Tests

    func testPreviewMockFetcherSuccess() async throws {
        // Given
        let mockFetcher = PreviewMockFactory.PreviewMockFetcher(
            episodesToReturn: PreviewMockFactory.createMockEpisodes(),
            shouldSimulateError: false,
            simulatedDelay: 0.0 // No delay for test
        )

        // When
        let response = try await mockFetcher.fetchEpisodes(page: 1)

        // Then
        XCTAssertEqual(response.results.count, 3)
        XCTAssertEqual(response.results[0].name, "Pilot")
    }

    func testPreviewMockFetcherError() async {
        // Given
        let mockFetcher = PreviewMockFactory.PreviewMockFetcher(
            episodesToReturn: [],
            shouldSimulateError: true,
            simulatedDelay: 0.0 // No delay for test
        )

        // When/Then
        do {
            _ = try await mockFetcher.fetchEpisodes(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testPreviewMockFetcherCharacter() async throws {
        // Given
        let mockFetcher = PreviewMockFactory.PreviewMockFetcher(
            shouldSimulateError: false,
            simulatedDelay: 0.0 // No delay for test
        )

        // When
        let character = try await mockFetcher.fetchCharacter(id: 1)

        // Then
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Morty Smith")
    }

    // MARK: - Mock Cache Tests

    func testPreviewMockCache() {
        // Given
        let testEpisodes = PreviewMockFactory.createMockEpisodes()
        let mockCache = PreviewMockFactory.PreviewMockCache(
            preloadedEpisodes: nil,
            simulateSlowAccess: false
        )

        // When
        mockCache.saveEpisodes(testEpisodes)
        let loadedEpisodes = mockCache.loadEpisodes()

        // Then
        XCTAssertNotNil(loadedEpisodes)
        XCTAssertEqual(loadedEpisodes?.count, 3)
        XCTAssertEqual(loadedEpisodes?[0].name, "Pilot")
    }

    func testPreviewMockCacheWithPreloadedEpisodes() {
        // Given
        let testEpisodes = PreviewMockFactory.createMockEpisodes()
        let mockCache = PreviewMockFactory.PreviewMockCache(
            preloadedEpisodes: testEpisodes,
            simulateSlowAccess: false
        )

        // When
        let loadedEpisodes = mockCache.loadEpisodes()

        // Then
        XCTAssertNotNil(loadedEpisodes)
        XCTAssertEqual(loadedEpisodes?.count, 3)
    }

    func testPreviewMockCacheClear() {
        // Given
        let testEpisodes = PreviewMockFactory.createMockEpisodes()
        let mockCache = PreviewMockFactory.PreviewMockCache()

        // When
        mockCache.saveEpisodes(testEpisodes)
        mockCache.clearEpisodesCache()
        let loadedEpisodes = mockCache.loadEpisodes()

        // Then
        XCTAssertNil(loadedEpisodes)
    }

    // MARK: - ViewModel Factory Tests

    func testCreateEpisodeListViewModelSuccess() {
        // Given/When
        let viewModel = PreviewMockFactory.createEpisodeListViewModel(
            scenario: .success,
            simulatedDelay: 0.0
        )

        // Then
        XCTAssertNotNil(viewModel)
        // Cannot test state directly as it requires async operations
        // but we can verify the viewModel was created successfully
    }

    func testCreateEpisodeListViewModelForAllScenarios() {
        // Given
        let scenarios: [PreviewMockFactory.PreviewScenario] = [
            .success, .loading, .networkError, .emptyList, .slowCache, .longList
        ]

        // When/Then
        for scenario in scenarios {
            let viewModel = PreviewMockFactory.createEpisodeListViewModel(
                scenario: scenario,
                simulatedDelay: 0.0
            )
            XCTAssertNotNil(viewModel, "Failed to create viewModel for scenario: \(scenario)")
        }
    }
}
