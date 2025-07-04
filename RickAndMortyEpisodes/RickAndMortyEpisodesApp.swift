import SwiftUI

@main
struct RickAndMortyEpisodesApp: App {
    var body: some Scene {
        WindowGroup {
            EpisodeListView(viewModel: EpisodeListViewModel(fetcher: APIService.shared, cache: CacheService.shared))
        }
    }
}
