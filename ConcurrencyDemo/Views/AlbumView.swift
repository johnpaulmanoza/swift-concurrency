import SwiftUI

// MARK: - Album View
struct AlbumView: View {
    @ObservedObject var viewModel: AlbumViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if viewModel.hasAlbums {
                albumListView
            } else {
                emptyStateView
            }
        }
        .navigationTitle("Albums")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadAlbums()
        }
        .task {
            await viewModel.loadAlbums()
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading albums...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task {
                    await viewModel.loadAlbums()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var albumListView: some View {
        List(viewModel.albums) { album in
            AlbumRowView(album: album)
        }
        .listStyle(PlainListStyle())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Albums")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("No albums available at the moment")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Album Row View
struct AlbumRowView: View {
    let album: Album
    
    var body: some View {
        HStack(spacing: 12) {
            // Album icon
            Image(systemName: "folder.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30, height: 30)
            
            // Album info
            VStack(alignment: .leading, spacing: 4) {
                Text(album.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text("Album ID: \(album.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumView(viewModel: AlbumViewModel())
        }
    }
}
