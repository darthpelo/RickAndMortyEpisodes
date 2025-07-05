import SwiftUI

struct EpisodeDetailView: View {
    @StateObject private var viewModel: EpisodeDetailViewModel
    @State private var selectedCharacterID: Int?
    @StateObject private var loader = CharacterDetailLoaderViewModel()

    init(episode: Episode) {
        _viewModel = StateObject(wrappedValue: EpisodeDetailViewModel(episode: episode))
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Text(viewModel.episode.formattedAirDate)
                    Spacer()
                    Text(viewModel.episode.episode)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            Section(header: Text(LocalizedString.charactersSection).font(.headline)) {
                if viewModel.characterIDs.isEmpty {
                    Text(LocalizedString.noCharactersInEpisode)
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.characterIDs, id: \.self) { id in
                        Button(action: {
                            selectedCharacterID = id
                            Task { await loader.loadCharacter(id: id) }
                        }, label: {
                            HStack {
                                Text(LocalizedString.characterIdFormat(id))
                                Spacer()
                            }
                        })
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(viewModel.episode.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: Binding(
            get: { loader.state.isSuccess },
            set: { isActive in if !isActive { loader.reset() } }
        )) {
            characterDetailDestination
        }
        .overlay(
            Group {
                if loader.state == .loading {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    ProgressView(LocalizedString.loadingCharacter)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .shadow(radius: 10)
                } else if case .failure(let message) = loader.state {
                    VStack {
                        Text(message)
                            .foregroundColor(.red)
                        Button(LocalizedString.dismissButton) { loader.reset() }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .shadow(radius: 10)
                }
            }
        )
    }

    @ViewBuilder
    private var characterDetailDestination: some View {
        if case .success(let character) = loader.state {
            CharacterDetailView(character: character)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Preview
struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockEpisode = Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
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
