import Foundation

/// Empty implementation of the episode list view model for TDD
final class EpisodeListViewModel: EpisodeListViewModelProtocol {
    @Published var episodes: [Episode] = []
    @Published var state: EpisodeListViewModelState = .idle
    private let fetcher: EpisodeFetching
    private let cache: EpisodeCaching
    
    init(fetcher: EpisodeFetching, cache: EpisodeCaching) {
        self.fetcher = fetcher
        self.cache = cache
    }
    
    // Empty implementation: does nothing
    func fetchEpisodes() async {
        // Not implemented
    }
    
    // Empty implementation: does nothing
    func loadMoreIfNeeded(currentEpisode: Episode) async {
        // Not implemented
    }
} 