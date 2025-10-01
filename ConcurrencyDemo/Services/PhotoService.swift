import Foundation

// MARK: - Album Service Protocol
protocol AlbumServiceProtocol {
    func fetchAlbums() async throws -> [Album]
}

// MARK: - Album Service Implementation
class AlbumService: AlbumServiceProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session = URLSession.shared
    
    // MARK: - Public Methods
    
    /// Fetches all albums from the API
    func fetchAlbums() async throws -> [Album] {
        let url = URL(string: "\(baseURL)/albums")!
        return try await performRequest(url: url)
    }
    
    // MARK: - Private Methods
    
    /// Generic method to perform network requests
    private func performRequest<T: Codable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw AlbumServiceError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            if error is AlbumServiceError {
                throw error
            } else {
                throw AlbumServiceError.networkError(error)
            }
        }
    }
}

// MARK: - Error Types
enum AlbumServiceError: LocalizedError {
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}