import Foundation

/// Enum representing the state of the episode list view model
enum EpisodeListViewModelState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}

/// Protocol for the episode list view model
protocol EpisodeListViewModelProtocol: ObservableObject {
    var episodes: [Episode] { get }
    var state: EpisodeListViewModelState { get }
    func fetchEpisodes() async
    func loadMoreIfNeeded(currentEpisode: Episode) async
}

/// Protocol for fetching episodes from a remote source
protocol EpisodeFetching {
    func fetchEpisodes(page: Int) async throws -> EpisodeResponse
}

/// Protocol for caching episodes locally
protocol EpisodeCaching {
    func saveEpisodes(_ episodes: [Episode])
    func loadEpisodes() -> [Episode]?
} 
