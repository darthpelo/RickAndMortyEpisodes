import Foundation

/// Helper class to provide easy access to localized strings
enum LocalizedString {
    
    // MARK: - Episode List
    
    static let episodesTitle = NSLocalizedString("episodes_title", comment: "Title for episodes screen")
    static let loadingEpisodes = NSLocalizedString("loading_episodes", comment: "Loading message for episodes")
    static let endOfEpisodeList = NSLocalizedString("end_of_episode_list", comment: "Message shown at end of episode list")
    static let retryButton = NSLocalizedString("retry_button", comment: "Retry button text")
    
    // MARK: - Episode Detail
    
    static let charactersSection = NSLocalizedString("characters_section_title", comment: "Section title for characters")
    static let noCharactersInEpisode = NSLocalizedString("no_characters_in_episode", comment: "Message when no characters in episode")
    static let loadingCharacter = NSLocalizedString("loading_character", comment: "Loading message for character")
    static let dismissButton = NSLocalizedString("dismiss_button", comment: "Dismiss button text")
    
    // MARK: - Character Detail
    
    static let characterDetailsTitle = NSLocalizedString("character_details_title", comment: "Title for character details screen")
    static let exportJsonButton = NSLocalizedString("export_json_button", comment: "Export JSON button text")
    static let exportFailed = NSLocalizedString("export_failed", comment: "Export failed message")
    
    // MARK: - Error Messages
    
    static let failedToLoadCharacter = NSLocalizedString("failed_to_load_character", comment: "Error message when character loading fails")
    
    // MARK: - Formatted Strings
    
    static func errorFormat(_ message: String) -> String {
        return String(format: NSLocalizedString("error_format", comment: "Error message format"), message)
    }
    
    static func characterIdFormat(_ id: Int) -> String {
        return String(format: NSLocalizedString("character_id_format", comment: "Character ID format"), id)
    }
    
    static func statusFormat(_ status: String) -> String {
        return String(format: NSLocalizedString("status_format", comment: "Status format"), status)
    }
    
    static func speciesFormat(_ species: String) -> String {
        return String(format: NSLocalizedString("species_format", comment: "Species format"), species)
    }
    
    static func originFormat(_ origin: String) -> String {
        return String(format: NSLocalizedString("origin_format", comment: "Origin format"), origin)
    }
    
    static func episodeCountFormat(_ count: Int) -> String {
        return String(format: NSLocalizedString("episode_count_format", comment: "Episode count format"), count)
    }
    
    static func exportedToFormat(_ filename: String) -> String {
        return String(format: NSLocalizedString("exported_to_format", comment: "Exported to format"), filename)
    }
    
    // MARK: - Date Formatting
    
    /// Formats an air date string from the API format to a localized display format
    /// - Parameter airDate: The air date string from the API (e.g., "December 2, 2013")
    /// - Returns: A localized formatted date string (e.g., "02/12/2013" for Dutch)
    static func formatAirDate(_ airDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // API format is always English
        inputFormatter.dateFormat = "MMMM d, yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current // Use system locale for display
        outputFormatter.dateStyle = .medium
        
        if let date = inputFormatter.date(from: airDate) {
            return outputFormatter.string(from: date)
        }
        
        // Fallback: try parsing as dd/MM/yyyy format
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
        fallbackFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = fallbackFormatter.date(from: airDate) {
            return outputFormatter.string(from: date)
        }
        
        // Return original string if parsing fails
        return airDate
    }
} 