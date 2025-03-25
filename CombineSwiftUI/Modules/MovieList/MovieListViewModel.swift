import Combine
import Foundation

@Observable
final class MovieListViewModel {
    private let apiClient: ApiClient
    private let searchSubject = CurrentValueSubject<String, Never>(String())
    private var cancellables = Set<AnyCancellable>()
    private(set) var movies = [Movie]()

    init(apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    func setupSearch() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadMovies(search: $0)
            }
            .store(in: &cancellables)
    }

    func searchMovies(_ search: String) {
        searchSubject.send(search)
    }

    private func loadMovies(search: String) {
        apiClient.fetchMovies(search)
            .sink { _ in } receiveValue: { [weak self] in
                self?.movies = $0
            }
            .store(in: &cancellables)
    }
}
