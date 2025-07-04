import Foundation

/// Protocol for the episode detail view model
protocol EpisodeDetailViewModelProtocol: ObservableObject {
    var episode: Episode { get }
    var characterIDs: [Int] { get }
} 