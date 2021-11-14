import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}

    private var baseURL: String {
        return "https://itunes.apple.com/"
    }
    
    func urlForAlbums(term: String) -> String{
        let newTerm = term
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: "+")
        
        return "\(baseURL)search?entity=album&term=\(newTerm)"
    }
    
    func urlForSongsInAlbum(collectionId: Int) -> String {
        return "\(baseURL)lookup?entity=song&id=\(collectionId)"
    }
    
    func fetch<T: Decodable>(dataType: T.Type, url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
