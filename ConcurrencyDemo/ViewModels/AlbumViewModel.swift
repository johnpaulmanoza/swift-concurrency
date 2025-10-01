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
            let fetchedAlbums = try await albumService.fetchAlbums()
            albums = fetchedAlbums
        } catch {
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
