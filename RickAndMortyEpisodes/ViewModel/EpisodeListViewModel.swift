import Foundation

@MainActor
final class EpisodeListViewModel: EpisodeListViewModelProtocol {
    @Published var episodes: [Episode] = []
    @Published var state: EpisodeListViewModelState = .idle
    private let fetcher: EpisodeFetching
    private let cache: EpisodeCaching
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoadingMore: Bool = false
    private var lastRefreshDate: Date?
    
    /// Minimum time interval (in seconds) between automatic background refreshes
    private let backgroundRefreshInterval: TimeInterval = 300 // 5 minutes
    
    init(fetcher: EpisodeFetching, cache: EpisodeCaching) {
        self.fetcher = fetcher
        self.cache = cache
    }
    
    /// Refreshes data if enough time has passed since last refresh
    func refreshIfNeeded() async {
        let now = Date()
        
        // Check if enough time has passed since last refresh
        if let lastRefresh = lastRefreshDate,
           now.timeIntervalSince(lastRefresh) < backgroundRefreshInterval {
            return // Too soon to refresh
        }
        
        // Perform background refresh
        await fetchEpisodes(forceRefresh: true)
        lastRefreshDate = now
    }
    
    func fetchEpisodes(forceRefresh: Bool = false) async {
        if forceRefresh {
            cache.clearEpisodesCache()
        }
        if !forceRefresh, let cached = cache.loadEpisodes(), !cached.isEmpty {
            episodes = cached
            state = .success
            return
        }
        // Fetch from network if cache is empty or forceRefresh
        state = .loading
        do {
            let response = try await fetcher.fetchEpisodes(page: 1)
            episodes = response.results
            cache.saveEpisodes(response.results)
            state = .success
            currentPage = 1
            totalPages = response.info.pages
            lastRefreshDate = Date()
        } catch _ as URLError {
            episodes = []
            state = .failure("Network error")
        } catch {
            episodes = []
            state = .failure("Decoding error")
        }
    }
    
    func loadMoreIfNeeded(currentEpisode: Episode) async {
        // Check if we are already loading or if there are no more pages
        guard !isLoadingMore, currentPage < totalPages else { return }
        // Check if the current episode is the last one
        guard let last = episodes.last, last.id == currentEpisode.id else { return }
        isLoadingMore = true
        do {
            let nextPage = currentPage + 1
            let response = try await fetcher.fetchEpisodes(page: nextPage)
            episodes.append(contentsOf: response.results)
            cache.saveEpisodes(episodes)
            currentPage = nextPage
            totalPages = response.info.pages
        } catch {
            // Ignore errors for pagination in this implementation
        }
        isLoadingMore = false
    }
    
    func fetchEpisodes() async {
        await fetchEpisodes(forceRefresh: false)
    }
} 
