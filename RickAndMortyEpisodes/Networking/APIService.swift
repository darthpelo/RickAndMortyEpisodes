import Foundation

protocol EpisodeFetching {
    func fetchEpisodes(page: Int) async throws -> EpisodeResponse
    func fetchCharacter(id: Int) async throws -> Character
}

final class APIService: EpisodeFetching {
    static let shared = APIService()
    // URLSession is injected for testability; defaults to .shared
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }

    private let baseURL = "https://rickandmortyapi.com/api/"

    // Fetches paginated episodes from the API
    func fetchEpisodes(page: Int = 1) async throws -> EpisodeResponse {
        let urlString = "\(baseURL)episode?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(EpisodeResponse.self, from: data)
    }

    // Fetches character details by ID (required by EpisodeFetching)
    func fetchCharacter(id: Int) async throws -> Character {
        let urlString = "\(baseURL)character/\(id)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(Character.self, from: data)
    }
}
