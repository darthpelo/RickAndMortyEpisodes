import SwiftUI

struct EpisodeListView: View {
    @StateObject private var viewModel: EpisodeListViewModel
    @Environment(\.scenePhase) private var scenePhase
    
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
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task {
                        await viewModel.refreshIfNeeded()
                    }
                }
            }
        }
    }
}

// MARK: - Preview Support
#if DEBUG
// Mock classes are now centralized in PreviewMockFactory.swift
// This file focuses only on preview configuration

// MARK: - Preview Variants
struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview: Success State
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .success
                )
            )
            .previewDisplayName("Success State")
            
            // Preview: Loading State
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .loading
                )
            )
            .previewDisplayName("Loading State")
            
            // Preview: Error State
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .networkError
                )
            )
            .previewDisplayName("Network Error")
            
            // Preview: Empty List
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .emptyList
                )
            )
            .previewDisplayName("Empty List")
            
            // Preview: Long List (for testing scrolling)
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .longList
                )
            )
            .previewDisplayName("Long List")
            
            // Preview: Dark Mode
            EpisodeListView(
                viewModel: PreviewMockFactory.createEpisodeListViewModel(
                    scenario: .success
                )
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
#endif
