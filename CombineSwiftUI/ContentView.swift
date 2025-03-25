import Combine
import SwiftUI

struct ContentView: View {
    private let apiClient: ApiClient
    @State private var movies = [Movie]()
    @State private var search = String()
    @State private var cancellables = Set<AnyCancellable>()
    private var searchSubject = CurrentValueSubject<String, Never>(String())

    init(apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    var body: some View {
        List(movies) { movie in
            HStack {
                AsyncImage(url: movie.poster) {
                    $0.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                } placeholder: {
                    ProgressView()
                }
                Text(movie.title)
            }
        }
        .searchable(text: $search)
        .onAppear {
            setupSearch()
        }
        .onChange(of: search) {
            searchSubject.send(search)
        }
    }

    private func setupSearch() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { loadMovies(search: $0) }
            .store(in: &cancellables)
    }

    private func loadMovies(search: String) {
        apiClient.fetchMovies(search)
            .sink { _ in } receiveValue: { movies = $0 }
            .store(in: &cancellables)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
