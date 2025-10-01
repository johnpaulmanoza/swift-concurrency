import Foundation
import SwiftUI

// MARK: - Album ViewModel
@MainActor
class AlbumViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let albumService: AlbumServiceProtocol
    
    // MARK: - Initialization
    init(albumService: AlbumServiceProtocol = AlbumService()) {
        self.albumService = albumService
    }
    
    // MARK: - Public Methods
    
    /// Loads all albums from the API
    func loadAlbums() async {
        await performAsyncOperation { [self] in
            self.isLoading = true
            self.errorMessage = nil
            
            do {
                self.albums = try await self.albumService.fetchAlbums()
            } catch {
                self.errorMessage = error.localizedDescription
                self.albums = []
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Private Methods
    
    /// Helper method to perform async operations with proper error handling
    private func performAsyncOperation(_ operation: @escaping () async -> Void) {
        Task {
            await operation()
        }
    }
}

// MARK: - Computed Properties
extension AlbumViewModel {
    var hasAlbums: Bool {
        !albums.isEmpty
    }
}