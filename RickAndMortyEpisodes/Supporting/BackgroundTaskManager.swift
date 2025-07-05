import BackgroundTasks
import Foundation

/// Manages background task scheduling and execution for the Rick and Morty Episodes app
@MainActor
final class BackgroundTaskManager: ObservableObject {
    // MARK: - Constants

    /// Unique identifier for background app refresh task
    /// Must match the identifier in Info.plist
    private static let backgroundRefreshTaskIdentifier = "com.rickandmorty.episodes.refresh"

    // MARK: - Properties

    private let viewModel: any EpisodeListViewModelProtocol

    // MARK: - Initialization

    init(viewModel: any EpisodeListViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Public Methods

    /// Registers background task handlers with the system
    /// Must be called during app launch before applicationDidFinishLaunching completes
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.backgroundRefreshTaskIdentifier,
            using: nil
        ) { [weak self] task in
            Task {
                await self?.handleBackgroundAppRefresh(task: task as! BGAppRefreshTask)
            }
        }
    }

    /// Schedules a background app refresh task
    /// Should be called when the app enters background
    func scheduleBackgroundAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundRefreshTaskIdentifier)

        // Set earliest begin date to avoid too frequent refreshes
        // Recommend refreshing no more often than every 15 minutes
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background app refresh scheduled successfully")
        } catch {
            print("❌ Failed to schedule background app refresh: \(error)")
        }
    }

    // MARK: - Private Methods

    /// Handles background app refresh task execution
    /// Called by the system when the app is launched for background refresh
    private func handleBackgroundAppRefresh(task: BGAppRefreshTask) async {
        // Schedule the next background refresh immediately
        scheduleBackgroundAppRefresh()

        // Set up expiration handler
        task.expirationHandler = {
            print("⚠️ Background refresh task expired")
            task.setTaskCompleted(success: false)
        }

        // Perform the actual background refresh
        let success = await viewModel.performBackgroundRefresh()

        // Mark task as completed
        task.setTaskCompleted(success: success)

        if success {
            print("✅ Background refresh completed successfully")
        } else {
            print("❌ Background refresh failed")
        }
    }
}

// MARK: - Debugging Support

#if DEBUG
extension BackgroundTaskManager {
    /// Debug method to simulate background app refresh
    /// Use this in debugger: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.rickandmorty.episodes.refresh"]
    func simulateBackgroundAppRefresh() {
        print("🔍 Simulating background app refresh...")
        // This method can be used for testing purposes
        // The actual simulation should be done via Xcode debugger commands
    }
}
#endif
