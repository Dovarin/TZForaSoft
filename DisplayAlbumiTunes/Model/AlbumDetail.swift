import Foundation

struct AlbumDetail: Codable{
    let resultCount: Int
    let results: [Song]
}

struct Song: Codable {
    let artistName: String
    let collectionName: String
    let trackCensoredName: String?
}
