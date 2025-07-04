import Foundation

@MainActor
final class EpisodeDetailViewModel: EpisodeDetailViewModelProtocol {
    let episode: Episode
    let characterIDs: [Int]
    
    init(episode: Episode) {
        self.episode = episode
        self.characterIDs = episode.characters.compactMap { urlString in
            guard let idString = urlString.split(separator: "/").last,
                  let id = Int(idString) else { return nil }
            return id
        }
    }
} 
