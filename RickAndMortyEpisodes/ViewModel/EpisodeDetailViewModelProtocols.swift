import Foundation

protocol EpisodeDetailViewModelProtocol: ObservableObject {
    var episode: Episode { get }
    var characterIDs: [Int] { get }
    var characterNames: [Int: String] { get }
    var isLoadingNames: Bool { get }
    var errorNames: [Int: String] { get }
    func preloadCharacterNames() async
} 
