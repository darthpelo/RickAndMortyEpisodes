import Foundation

@MainActor
final class EpisodeDetailViewModel: EpisodeDetailViewModelProtocol {
    let episode: Episode
    let characterIDs: [Int]
    private let fetcher: EpisodeFetching
    
    @Published private(set) var characterNames: [Int: String] = [:]
    @Published private(set) var isLoadingNames: Bool = false
    @Published private(set) var errorNames: [Int: String] = [:]
    
    init(episode: Episode, fetcher: EpisodeFetching = APIService.shared) {
        self.episode = episode
        self.characterIDs = episode.characters.compactMap { urlString in
            guard let idString = urlString.split(separator: "/").last,
                  let id = Int(idString) else { return nil }
            return id
        }
        self.fetcher = fetcher
    }
    
    func preloadCharacterNames() async {
        isLoadingNames = true
        errorNames = [:]
        for id in characterIDs {
            if characterNames[id] == nil {
                do {
                    let character = try await fetcher.fetchCharacter(id: id)
                    characterNames[id] = character.name
                } catch {
                    characterNames[id] = "N/A"
                    errorNames[id] = error.localizedDescription
                }
            }
        }
        isLoadingNames = false
    }
} 
