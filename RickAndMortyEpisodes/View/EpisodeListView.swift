import SwiftUI

struct EpisodeListView: View {
    @StateObject private var viewModel: EpisodeListViewModel
    
    init(viewModel: EpisodeListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading episodes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure(let message):
                    VStack {
                        Text("Error: \(message)")
                        Button("Retry") {
                            Task { await viewModel.fetchEpisodes() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success:
                    List {
                        ForEach(viewModel.episodes) { episode in
                            NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                                VStack(alignment: .leading) {
                                    Text(episode.name)
                                        .font(.headline)
                                    Text(episode.formattedAirDate)
                                        .font(.subheadline)
                                    Text(episode.episode)
                                        .font(.caption)
                                }
                                .padding(.vertical, 4)
                                .onAppear {
                                    Task { await viewModel.loadMoreIfNeeded(currentEpisode: episode) }
                                }
                            }
                        }
                        if viewModel.episodes.count > 0 {
                            Text("End of episode list")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchEpisodes(forceRefresh: true)
                    }
                }
            }
            .navigationTitle("Episodes")
            .task { await viewModel.fetchEpisodes() }
        }
    }
}

// MARK: - Preview mocks (only for SwiftUI preview)
private class PreviewMockFetcher: EpisodeFetching {
    func fetchEpisodes(page: Int) async throws -> EpisodeResponse {
        return EpisodeResponse(
            info: PageInfo(count: 2, pages: 1, next: nil, prev: nil),
            results: [
                Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: ""),
                Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
            ]
        )
    }
    
    // Required by EpisodeFetching protocol
    func fetchCharacter(id: Int) async throws -> Character {
        return Character(
            id: id,
            name: "Preview Character",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: ["url1", "url2"],
            url: "",
            created: ""
        )
    }
}
private class PreviewMockCache: EpisodeCaching {
    func saveEpisodes(_ episodes: [Episode]) {}
    func loadEpisodes() -> [Episode]? { nil }
    func clearEpisodesCache() {}
}

// MARK: - Preview
struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = EpisodeListViewModel(fetcher: PreviewMockFetcher(), cache: PreviewMockCache())
        mockViewModel.episodes = [
            Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: ""),
            Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: "")
        ]
        mockViewModel.state = EpisodeListViewModelState.success
        return EpisodeListView(viewModel: mockViewModel)
    }
}
