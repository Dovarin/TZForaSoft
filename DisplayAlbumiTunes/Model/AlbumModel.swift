import Foundation

struct ResultAlbums: Codable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Codable {
    let collectionId: Int
    let artworkUrl100: String
    let artistName: String
    let collectionName: String
}
