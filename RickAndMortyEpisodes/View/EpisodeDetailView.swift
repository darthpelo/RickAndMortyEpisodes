import SwiftUI

struct EpisodeDetailView: View {
    @StateObject private var viewModel: EpisodeDetailViewModel
    
    init(episode: Episode) {
        _viewModel = StateObject(wrappedValue: EpisodeDetailViewModel(episode: episode))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.episode.name)
                .font(.title)
            HStack {
                Text(formattedDate(viewModel.episode.air_date))
                Text(viewModel.episode.episode)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            Divider()
            Text("Character IDs:")
                .font(.headline)
            if viewModel.characterIDs.isEmpty {
                Text("No characters in this episode.")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.characterIDs, id: \ .self) { id in
                    Button(action: {
                        print("Tapped character ID: \(id)")
                    }) {
                        Text("Character ID: \(id)")
                            .foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Episode Details")
    }
    
    /// Formats the air date string to dd/MM/yyyy
    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Preview
struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockEpisode = Episode(
            id: 1,
            name: "Pilot",
            air_date: "December 2, 2013",
            episode: "S01E01",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/42"
            ],
            url: "",
            created: ""
        )
        EpisodeDetailView(episode: mockEpisode)
    }
} 