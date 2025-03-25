import SwiftUI

@main
struct CombineSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MovieListView()
            }
        }
    }
}
