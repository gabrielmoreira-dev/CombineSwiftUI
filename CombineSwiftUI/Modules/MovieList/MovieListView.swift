import Combine
import SwiftUI

struct MovieListView: View {
    @State private var viewModel: MovieListViewModel
    @State private var search = String()

    init(viewModel: MovieListViewModel = MovieListViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.movies) { movie in
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
            viewModel.setupSearch()
        }
        .onChange(of: search) {
            viewModel.searchMovies(search)
        }
    }
}

#Preview {
    NavigationStack {
        MovieListView()
    }
}
