import Foundation

@MainActor
protocol EpisodeDetailViewModelProtocol: ObservableObject {
    var episode: Episode { get }
    var characterIDs: [Int] { get }
} 
