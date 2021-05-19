import Foundation

public class APIService {
    
    public static let shared = APIService()
    
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    public func getJSON<T: Decodable>(urlString: String, completion: @escaping (Result<T,APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
            }
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async{
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async{
                completion(.failure(.error(NSLocalizedString("Error: Data is corrupt.", comment: ""))))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async{
                completion(.success(decodedData))
                }
                return
            } catch let decodingError {
                DispatchQueue.main.async{
                completion(.failure(APIError.error("Error \(decodingError.localizedDescription)")))
                }
            }
        }.resume()
    }
}








