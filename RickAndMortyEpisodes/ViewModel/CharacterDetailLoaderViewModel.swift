import Foundation

/// State for the character detail loader
enum CharacterDetailLoaderState {
    case idle
    case loading
    case success(Character)
    case failure(String)
}

extension CharacterDetailLoaderState: Equatable {
    static func == (lhs: CharacterDetailLoaderState, rhs: CharacterDetailLoaderState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.failure(l), .failure(r)):
            return l == r
        case (.success, .success):
            return true // We don't compare the Character
        default:
            return false
        }
    }
}

extension CharacterDetailLoaderState {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}

/// Protocol for the character detail loader view model
@MainActor
protocol CharacterDetailLoaderViewModelProtocol: ObservableObject {
    var state: CharacterDetailLoaderState { get }
    func loadCharacter(id: Int) async
}

/// ViewModel for loading character details asynchronously
@MainActor
final class CharacterDetailLoaderViewModel: CharacterDetailLoaderViewModelProtocol {
    @Published private(set) var state: CharacterDetailLoaderState = .idle
    private let fetcher: EpisodeFetching

    init(fetcher: EpisodeFetching = APIService.shared) {
        self.fetcher = fetcher
    }

    /// Loads character details from the API
    func loadCharacter(id: Int) async {
        state = .loading
        do {
            let character = try await fetcher.fetchCharacter(id: id)
            state = .success(character)
        } catch {
            state = .failure(LocalizedString.failedToLoadCharacter)
        }
    }

    /// Resets the state to idle
    func reset() {
        state = .idle
    }
}
