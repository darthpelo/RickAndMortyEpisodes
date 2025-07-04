import Foundation

/// Empty implementation of the episode list view model for TDD
final class EpisodeListViewModel: EpisodeListViewModelProtocol {
    @Published var episodes: [Episode] = []
    @Published var state: EpisodeListViewModelState = .idle
    private let fetcher: EpisodeFetching
    private let cache: EpisodeCaching
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoadingMore: Bool = false
    
    init(fetcher: EpisodeFetching, cache: EpisodeCaching) {
        self.fetcher = fetcher
        self.cache = cache
    }
    
    /// Loads episodes from cache if available, otherwise fetches from network
    func fetchEpisodes() async {
        if let cached = cache.loadEpisodes(), !cached.isEmpty {
            episodes = cached
            state = .success
            return
        }
        // Fetch from network if cache is empty
        state = .loading
        do {
            let response = try await fetcher.fetchEpisodes(page: 1)
            episodes = response.results
            cache.saveEpisodes(response.results)
            state = .success
            currentPage = 1
            totalPages = response.info.pages
        } catch _ as URLError {
            // Handle network error
            episodes = []
            state = .failure("Network error")
        } catch {
            // Handle decoding or other errors
            episodes = []
            state = .failure("Decoding error")
        }
    }
    
    /// Loads the next page of episodes if needed
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
} 
