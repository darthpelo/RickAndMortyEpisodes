import Foundation

protocol EpisodeDetailViewModelProtocol: ObservableObject {
    var episode: Episode { get }
    var characterIDs: [Int] { get }
} 
