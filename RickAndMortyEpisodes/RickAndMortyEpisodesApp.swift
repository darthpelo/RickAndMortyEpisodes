//
//  RickAndMortyEpisodesApp.swift
//  RickAndMortyEpisodes
//
//  Created by Alessio Roberto on 03/07/2025.
//

import SwiftUI

@main
struct RickAndMortyEpisodesApp: App {
    var body: some Scene {
        WindowGroup {
            EpisodeListView(viewModel: EpisodeListViewModel(fetcher: APIService.shared, cache: CacheService.shared))
        }
    }
}
