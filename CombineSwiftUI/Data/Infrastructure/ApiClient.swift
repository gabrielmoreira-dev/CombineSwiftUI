import Combine
import Foundation

final class ApiClient {
    private let apiKey = "<YOUR KEY>"

    func fetchMovies(_ search: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.urlEncoded,
              let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=\(apiKey)") else {
            return Fail(error: NetworkError.malformedURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleData)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.search)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func handleData(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        switch httpResponse.statusCode {
        case 400..<500:
            throw NetworkError.badRequest
        case 500..<600:
            throw NetworkError.badResponse
        default:
            break
        }
        return data
    }
}
