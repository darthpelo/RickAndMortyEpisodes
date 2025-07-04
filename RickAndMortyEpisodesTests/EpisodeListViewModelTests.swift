import XCTest
@testable import RickAndMortyEpisodes

@MainActor
final class EpisodeListViewModelTests: XCTestCase {
    var fetcher: MockEpisodeFetcher!
    var cache: MockEpisodeCache!
    var sut: EpisodeListViewModel!

    override func setUp() {
        super.setUp()
        fetcher = MockEpisodeFetcher()
        cache = MockEpisodeCache()
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
    }

    override func tearDown() {
        fetcher = nil
        cache = nil
        sut = nil
        super.tearDown()
    }

    func testEpisodesLoadedFromCache() async {
        // Given
        let episode = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        cache.storedEpisodes = [episode]
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [episode]))
        // When
        await sut.fetchEpisodes()
        // Then
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Pilot")
        XCTAssertEqual(sut.state, .success)
    }

    func testEpisodesLoadedFromNetwork() async {
        // Given
        let episode = Episode(id: 2, name: "Lawnmower Dog", airDate: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        cache.storedEpisodes = nil
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [episode]))
        // When
        await sut.fetchEpisodes()
        // Then
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Lawnmower Dog")
        XCTAssertEqual(sut.state, .success)
    }

    func testEpisodesNetworkError() async {
        // Given
        cache.storedEpisodes = nil
        fetcher.result = .failure(URLError(.notConnectedToInternet))
        // When
        await sut.fetchEpisodes()
        // Then
        XCTAssertEqual(sut.state, .failure("Network error"))
        XCTAssertTrue(sut.episodes.isEmpty)
    }

    func testLoadMoreEpisodes() async {
        // Given
        let episode1 = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        let episode2 = Episode(id: 2, name: "Lawnmower Dog", airDate: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        let pageInfo = PageInfo(count: 2, pages: 2, next: "next", prev: nil)
        fetcher.result = .success(EpisodeResponse(info: pageInfo, results: [episode1]))
        await sut.fetchEpisodes()
        // When
        fetcher.result = .success(EpisodeResponse(info: pageInfo, results: [episode2]))
        await sut.loadMoreIfNeeded(currentEpisode: episode1)
        // Then
        XCTAssertEqual(sut.episodes.count, 2)
        XCTAssertEqual(sut.episodes.last?.name, "Lawnmower Dog")
    }

    func testEpisodesCorruptedData() async {
        // Given
        cache.storedEpisodes = nil
        struct DummyError: Error {}
        fetcher.result = .failure(DummyError())
        // When
        await sut.fetchEpisodes()
        // Then
        XCTAssertEqual(sut.state, .failure("Decoding error"))
        XCTAssertTrue(sut.episodes.isEmpty)
    }

    func testFetchEpisodesWithForceRefreshClearsCacheAndLoadsFromAPI() async {
        // Given
        let cachedEpisode = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        let apiEpisode = Episode(id: 2, name: "Lawnmower Dog", airDate: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        cache.storedEpisodes = [cachedEpisode]
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [apiEpisode]))
        // When:
        await sut.fetchEpisodes(forceRefresh: true)
        // Then
        XCTAssertTrue(cache.clearEpisodesCacheCalled)
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Lawnmower Dog")
        XCTAssertEqual(sut.state, .success)
    }

    func testPerformBackgroundRefreshReturnsTrue() async {
        // Given
        let episode = Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [episode]))
        
        // When
        let result = await sut.performBackgroundRefresh()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Pilot")
        XCTAssertTrue(cache.saveEpisodesCalled)
    }
    
    func testPerformBackgroundRefreshReturnsFalseOnError() async {
        // Given
        fetcher.result = .failure(URLError(.notConnectedToInternet))
        
        // When
        let result = await sut.performBackgroundRefresh()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.episodes.isEmpty)
    }
} 
