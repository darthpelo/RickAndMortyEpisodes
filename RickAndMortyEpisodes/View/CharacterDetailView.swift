import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @State private var exportMessage: String?
    @State private var shareURL: URL?
    @State private var isShareSheetPresented = false
    
    init(character: Character) {
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(character: character))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                if let url = viewModel.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                }
                Text(viewModel.name)
                    .font(.title)
                Text("Status: \(viewModel.status)")
                Text("Species: \(viewModel.species)")
                Text("Origin: \(viewModel.originName)")
                Text("Episodes: \(viewModel.episodeCount)")
                Button("Export JSON") {
                    do {
                        let url = try viewModel.exportCharacterDetails()
                        exportMessage = "Exported to: \(url.lastPathComponent)"
                        shareURL = url
                        isShareSheetPresented = true
                    } catch {
                        exportMessage = "Export failed"
                    }
                }
                if let message = exportMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.green)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Character Details")
        .sheet(isPresented: $isShareSheetPresented, onDismiss: { shareURL = nil }) {
            if let url = shareURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
}

// MARK: - Preview
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCharacter = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episodes: ["url1", "url2"],
            url: "",
            created: ""
        )
        CharacterDetailView(character: mockCharacter)
    }
} 
