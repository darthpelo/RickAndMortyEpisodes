import Foundation

enum EpisodeListViewModelState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}

@MainActor
protocol EpisodeListViewModelProtocol: ObservableObject {
    var episodes: [Episode] { get }
    var state: EpisodeListViewModelState { get }
    func fetchEpisodes() async
    func loadMoreIfNeeded(currentEpisode: Episode) async
    func performBackgroundRefresh() async -> Bool
}
