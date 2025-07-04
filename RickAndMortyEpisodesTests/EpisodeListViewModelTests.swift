import XCTest
@testable import RickAndMortyEpisodes

final class EpisodeListViewModelTests: XCTestCase {
    var fetcher: MockEpisodeFetcher!
    var cache: MockEpisodeCache!
    var sut: EpisodeListViewModel!

    override func setUp() {
        super.setUp()
        fetcher = MockEpisodeFetcher()
        cache = MockEpisodeCache()
    }

    override func tearDown() {
        fetcher = nil
        cache = nil
        sut = nil
        super.tearDown()
    }

    // Test loading episodes from cache
    func testEpisodesLoadedFromCache() async {
        // Given: cache contains episodes
        let episode = Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        cache.storedEpisodes = [episode]
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [episode]))
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
        // When: fetching episodes
        await sut.fetchEpisodes()
        // Then: episodes from cache are shown immediately
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Pilot")
        XCTAssertEqual(sut.state, .success)
    }

    // Test loading episodes from network when cache is empty
    func testEpisodesLoadedFromNetwork() async {
        // Given: cache is empty, network returns episodes
        let episode = Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        cache.storedEpisodes = nil
        fetcher.result = .success(EpisodeResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: [episode]))
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
        // When: fetching episodes
        await sut.fetchEpisodes()
        // Then: episodes from network are shown
        XCTAssertEqual(sut.episodes.count, 1)
        XCTAssertEqual(sut.episodes.first?.name, "Lawnmower Dog")
        XCTAssertEqual(sut.state, .success)
    }

    // Test error handling when network fails
    func testEpisodesNetworkError() async {
        // Given: network returns error
        cache.storedEpisodes = nil
        fetcher.result = .failure(URLError(.notConnectedToInternet))
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
        // When: fetching episodes
        await sut.fetchEpisodes()
        // Then: state is failure with error message
        XCTAssertEqual(sut.state, .failure("Network error"))
        XCTAssertTrue(sut.episodes.isEmpty)
    }

    // Test pagination: loading next page
    func testLoadMoreEpisodes() async {
        // Given: first page loaded, more pages available
        let episode1 = Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: "")
        let episode2 = Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        let pageInfo = PageInfo(count: 2, pages: 2, next: "next", prev: nil)
        fetcher.result = .success(EpisodeResponse(info: pageInfo, results: [episode1]))
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
        await sut.fetchEpisodes()
        // When: loading more episodes
        fetcher.result = .success(EpisodeResponse(info: pageInfo, results: [episode2]))
        await sut.loadMoreIfNeeded(currentEpisode: episode1)
        // Then: next page is loaded and episodes are appended
        XCTAssertEqual(sut.episodes.count, 2)
        XCTAssertEqual(sut.episodes.last?.name, "Lawnmower Dog")
    }

    // Test handling of corrupted data from network
    func testEpisodesCorruptedData() async {
        // Given: network returns corrupted data (simulate decoding error)
        cache.storedEpisodes = nil
        struct DummyError: Error {}
        fetcher.result = .failure(DummyError())
        sut = EpisodeListViewModel(fetcher: fetcher, cache: cache)
        // When: fetching episodes
        await sut.fetchEpisodes()
        // Then: state is failure
        XCTAssertEqual(sut.state, .failure("Decoding error"))
        XCTAssertTrue(sut.episodes.isEmpty)
    }
} 
