import SwiftUI

@main
struct RickAndMortyEpisodesApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: EpisodeListViewModel
    @StateObject private var backgroundTaskManager: BackgroundTaskManager

    init() {
        // Initialize shared view model instance
        let sharedViewModel = EpisodeListViewModel(fetcher: APIService.shared, cache: CacheService.shared)
        _viewModel = StateObject(wrappedValue: sharedViewModel)

        // Initialize background task manager with shared view model
        let sharedBackgroundTaskManager = BackgroundTaskManager(viewModel: sharedViewModel)
        _backgroundTaskManager = StateObject(wrappedValue: sharedBackgroundTaskManager)

        // Register background tasks during app initialization
        // This must be done before the app finishes launching
        sharedBackgroundTaskManager.registerBackgroundTasks()
    }

    var body: some Scene {
        WindowGroup {
            EpisodeListView(viewModel: viewModel)
        }
        .onChange(of: scenePhase) { _, newPhase in
            handleScenePhaseChange(newPhase)
        }
    }

    // MARK: - Private Methods

    /// Handles scene phase changes to manage background task scheduling
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            // App entered background - schedule background refresh
            backgroundTaskManager.scheduleBackgroundAppRefresh()
        case .active:
            // App became active - no specific action needed
            // Background refresh will happen automatically when scheduled
            break
        case .inactive:
            // App is inactive (e.g., during transitions) - no action needed
            break
        @unknown default:
            break
        }
    }
}
