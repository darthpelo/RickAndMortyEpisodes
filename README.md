# Rick and Morty Episodes App

**Important Note on Development Tools**: I have been working for over a year at a company that actively encourages the use of GitHub Copilot as a development support tool. For more than a year now, having an IDE with generative AI that supports and accelerates my development and learning has become an integral part of my workflow. For this assignment, I utilized **GitHub Copilot** and **Cursor IDE with Claude-4-Sonnet** as development/learning assistance tools. This AI support was especially valuable because in the last three years I have not used SwiftUI professionally, and in the past year I have worked in a team focused mainly on payment logic, with very little UI work (and only simple, non-reactive interfaces).

A SwiftUI iOS app that displays episodes from the Rick and Morty TV series using the official API. The project follows MVVM, SOLID principles, TDD, and includes full localization (English, Dutch) and code quality enforcement with SwiftLint.

## Features

- List and detail views for episodes and characters
- Pagination and pull-to-refresh
- Background data refresh using BGTaskScheduler
- Local caching with UserDefaults
- Error handling and loading states
- JSON export and share for character details
- Complete localization (en, nl) with dynamic date formatting
- Comprehensive unit tests

## Architecture

- **MVVM**: Protocol-based ViewModels, dependency injection
- **Services**: APIService (network), CacheService (persistence)
- **BackgroundTaskManager**: Centralized BGTaskScheduler integration
- **SOLID**: Clean separation of concerns, protocol-driven

## Background App Refresh

- Uses BGTaskScheduler with identifier: `com.alessioroberto.RickAndMortyEpisodes.refresh`
- Automatic rescheduling and optimized background execution
- Info.plist:

  ```xml
  <key>UIBackgroundModes</key>
  <array>
      <string>background-fetch</string>
  </array>
  <key>BGTaskSchedulerPermittedIdentifiers</key>
  <array>
      <string>com.alessioroberto.RickAndMortyEpisodes.refresh</string>
  </array>
  ```

## Code Quality

- **SwiftLint**: Strict configuration, pre-commit hook, custom rules
- **Zero tolerance**: All code must pass linting before commit

## Setup

1. Clone the repository
2. Install SwiftLint: `brew install swiftlint`
3. Open `RickAndMortyEpisodes.xcodeproj` in Xcode 15+
4. Build and run (⌘R)

### Requirements

- iOS 18.0+
- Xcode 15.0+
- Swift 5.9+

## Testing

- Full unit test coverage for ViewModels and services
- Mock implementations for all dependencies
- No UI tests (focus on unit and integration tests)

## Localization

- All user-facing text and dates localized (en, nl)
- String Catalogs (.xcstrings) and centralized helper

---

For details on architecture, testing, and quality standards, see `.cursor/rules/project-rules.mdc`.

## Limitations

- The UI does **not** display a timestamp for the last content refresh (nice to have requirement, omitted due to time constraints).
- UI tests were **not implemented** (focus was placed on comprehensive unit test coverage and core functionality).
