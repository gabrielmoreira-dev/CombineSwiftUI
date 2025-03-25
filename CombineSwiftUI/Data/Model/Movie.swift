import Foundation

struct MovieResponse: Decodable {
    let search: [Movie]

    private enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Identifiable, Decodable {
    let title: String
    let year: String
    let id: String
    let poster: URL?

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case poster = "Poster"
    }
}
