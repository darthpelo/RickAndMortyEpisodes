import Foundation

// MARK: - Preview Mock Data Factory
#if DEBUG
/// Centralized factory for creating consistent and reusable mock data for previews
enum PreviewMockFactory {
    // MARK: - Mock Episodes
    static func createMockEpisodes() -> [Episode] {
        [
            Episode(
                id: 1,
                name: "Pilot",
                airDate: "December 2, 2013",
                episode: "S01E01",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                ],
                url: "https://rickandmortyapi.com/api/episode/1",
                created: "2017-11-10T12:56:33.798Z"
            ),
            Episode(
                id: 2,
                name: "Lawnmower Dog",
                airDate: "December 9, 2013",
                episode: "S01E02",
                characters: [
                    "https://rickandmortyapi.com/api/character/3",
                    "https://rickandmortyapi.com/api/character/4"
                ],
                url: "https://rickandmortyapi.com/api/episode/2",
                created: "2017-11-10T12:56:33.798Z"
            ),
            Episode(
                id: 3,
                name: "Anatomy Park",
                airDate: "December 16, 2013",
                episode: "S01E03",
                characters: [
                    "https://rickandmortyapi.com/api/character/5",
                    "https://rickandmortyapi.com/api/character/6"
                ],
                url: "https://rickandmortyapi.com/api/episode/3",
                created: "2017-11-10T12:56:33.798Z"
            )
        ]
    }

    // MARK: - Mock Characters
    static func createMockCharacter(id: Int) -> Character {
        let names = ["Rick Sanchez", "Morty Smith", "Summer Smith", "Beth Smith", "Jerry Smith", "Birdperson"]
        let species = ["Human", "Alien", "Robot", "Humanoid", "Unknown"]
        let statuses = ["Alive", "Dead", "Unknown"]

        return Character(
            id: id,
            name: names[id % names.count],
            status: statuses[id % statuses.count],
            species: species[id % species.count],
            type: "",
            gender: id % 2 == 0 ? "Male" : "Female",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg",
            episode: ["https://rickandmortyapi.com/api/episode/1"],
            url: "https://rickandmortyapi.com/api/character/\(id)",
            created: "2017-11-04T18:48:46.250Z"
        )
    }

    // MARK: - Mock Page Info
    static func createMockPageInfo(count: Int = 3, pages: Int = 1, hasNext: Bool = false) -> PageInfo {
        PageInfo(
            count: count,
            pages: pages,
            next: hasNext ? "https://rickandmortyapi.com/api/episode?page=2" : nil,
            prev: nil
        )
    }

    // MARK: - Mock Episode Response
    static func createMockEpisodeResponse(
        episodes: [Episode] = createMockEpisodes(),
        hasNextPage: Bool = false
    ) -> EpisodeResponse {
        EpisodeResponse(
            info: createMockPageInfo(count: episodes.count, hasNext: hasNextPage),
            results: episodes
        )
    }

    // MARK: - Specialized Mock Data for Testing Edge Cases
    static func createEmptyEpisodeList() -> [Episode] {
        []
    }

    static func createSingleEpisode() -> Episode {
        Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01",
            characters: ["https://rickandmortyapi.com/api/character/1"],
            url: "https://rickandmortyapi.com/api/episode/1",
            created: "2017-11-10T12:56:33.798Z"
        )
    }

    static func createLongEpisodeList() -> [Episode] {
        (1...20).map { id in
            Episode(
                id: id,
                name: "Episode \(id)",
                airDate: "December \(id + 1), 2013",
                episode: "S01E\(String(format: "%02d", id))",
                characters: ["https://rickandmortyapi.com/api/character/\(id)"],
                url: "https://rickandmortyapi.com/api/episode/\(id)",
                created: "2017-11-10T12:56:33.798Z"
            )
        }
    }
}

// MARK: - Preview Mock Services
extension PreviewMockFactory {
    /// Configurable mock fetcher for different preview scenarios
    class PreviewMockFetcher: EpisodeFetching {
        private let episodesToReturn: [Episode]
        private let shouldSimulateError: Bool
        private let simulatedDelay: TimeInterval

        init(
            episodesToReturn: [Episode] = PreviewMockFactory.createMockEpisodes(),
            shouldSimulateError: Bool = false,
            simulatedDelay: TimeInterval = 0.5
        ) {
            self.episodesToReturn = episodesToReturn
            self.shouldSimulateError = shouldSimulateError
            self.simulatedDelay = simulatedDelay
        }

        func fetchEpisodes(page: Int) async throws -> EpisodeResponse {
            // Simulate realistic network delay
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))

            if shouldSimulateError {
                throw URLError(.notConnectedToInternet)
            }

            return PreviewMockFactory.createMockEpisodeResponse(
                episodes: episodesToReturn,
                hasNextPage: page < 2
            )
        }

        func fetchCharacter(id: Int) async throws -> Character {
            // Simulate realistic network delay
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 0.6 * 1_000_000_000))

            if shouldSimulateError {
                throw URLError(.notConnectedToInternet)
            }

            return PreviewMockFactory.createMockCharacter(id: id)
        }
    }

    /// Configurable mock cache for different preview scenarios
    class PreviewMockCache: EpisodeCaching {
        private var storedEpisodes: [Episode]?
        private let simulateSlowAccess: Bool

        init(
            preloadedEpisodes: [Episode]? = nil,
            simulateSlowAccess: Bool = false
        ) {
            self.storedEpisodes = preloadedEpisodes
            self.simulateSlowAccess = simulateSlowAccess
        }

        func saveEpisodes(_ episodes: [Episode]) {
            if simulateSlowAccess {
                // Simulate slow access to test loading states
                Thread.sleep(forTimeInterval: 0.1)
            }
            storedEpisodes = episodes
        }

        func loadEpisodes() -> [Episode]? {
            if simulateSlowAccess {
                // Simulate slow access to test loading states
                Thread.sleep(forTimeInterval: 0.1)
            }
            return storedEpisodes
        }

        func clearEpisodesCache() {
            storedEpisodes = nil
        }
    }
}

// MARK: - Preview ViewModel Factory
extension PreviewMockFactory {
    /// Factory for creating EpisodeListViewModel configured for different preview scenarios
    @MainActor
    static func createEpisodeListViewModel(
        scenario: PreviewScenario = .success,
        episodes: [Episode] = createMockEpisodes(),
        simulatedDelay: TimeInterval = 0.5
    ) -> EpisodeListViewModel {
        let mockFetcher = PreviewMockFetcher(
            episodesToReturn: episodes,
            shouldSimulateError: scenario == .networkError,
            simulatedDelay: simulatedDelay
        )

        let mockCache = PreviewMockCache(
            preloadedEpisodes: scenario == .success ? episodes : nil,
            simulateSlowAccess: scenario == .slowCache
        )

        return EpisodeListViewModel(fetcher: mockFetcher, cache: mockCache)
    }
}

// MARK: - Preview Scenarios
extension PreviewMockFactory {
    /// Predefined scenarios for previews
    enum PreviewScenario {
        case success
        case loading
        case networkError
        case emptyList
        case slowCache
        case longList

        var displayName: String {
            switch self {
            case .success: return "Success State"
            case .loading: return "Loading State"
            case .networkError: return "Network Error"
            case .emptyList: return "Empty List"
            case .slowCache: return "Slow Cache"
            case .longList: return "Long List"
            }
        }

        var episodes: [Episode] {
            switch self {
            case .success: return PreviewMockFactory.createMockEpisodes()
            case .loading: return []
            case .networkError: return []
            case .emptyList: return []
            case .slowCache: return PreviewMockFactory.createMockEpisodes()
            case .longList: return PreviewMockFactory.createLongEpisodeList()
            }
        }
    }
}
#endif
