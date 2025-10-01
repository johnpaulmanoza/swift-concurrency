import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AlbumViewModel()
    
    var body: some View {
        NavigationView {
            AlbumView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}