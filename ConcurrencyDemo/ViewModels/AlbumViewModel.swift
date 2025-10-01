import Foundation
import SwiftUI

@MainActor
class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let albumService: AlbumServiceProtocol

    init(albumService: AlbumServiceProtocol = AlbumService()) {
        self.albumService = albumService
    }

    func loadAlbums() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            // Fetch albums from the service (threading handled by service)
            let fetchedAlbums = try await albumService.fetchAlbums()
            
            // Update the albums array
            albums = fetchedAlbums
        } catch {
            // Handle errors by setting the error message and clearing albums
            errorMessage = error.localizedDescription
            albums = []
        }
    }
}

// MARK: - Computed Properties
extension AlbumViewModel {
    var hasAlbums: Bool {
        !albums.isEmpty
    }
}
