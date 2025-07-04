import Foundation

/// ViewModel for the episode detail screen
final class EpisodeDetailViewModel: EpisodeDetailViewModelProtocol {
    let episode: Episode
    let characterIDs: [Int]
    
    init(episode: Episode) {
        self.episode = episode
        // Extract character IDs from URLs
        self.characterIDs = episode.characters.compactMap { urlString in
            guard let idString = urlString.split(separator: "/").last,
                  let id = Int(idString) else { return nil }
            return id
        }
    }
} 