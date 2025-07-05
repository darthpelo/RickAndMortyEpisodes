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
                Text(LocalizedString.statusFormat(viewModel.status))
                Text(LocalizedString.speciesFormat(viewModel.species))
                Text(LocalizedString.originFormat(viewModel.originName))
                Text(LocalizedString.episodeCountFormat(viewModel.episodeCount))
                Button(LocalizedString.exportJsonButton) {
                    do {
                        let url = try viewModel.exportCharacterDetails()
                        exportMessage = LocalizedString.exportedToFormat(url.lastPathComponent)
                        shareURL = url
                        isShareSheetPresented = true
                    } catch {
                        exportMessage = LocalizedString.exportFailed
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
        .navigationTitle(LocalizedString.characterDetailsTitle)
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
            episode: ["url1", "url2"],
            url: "",
            created: ""
        )
        CharacterDetailView(character: mockCharacter)
    }
}
