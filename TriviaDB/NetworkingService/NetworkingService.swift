//
//  NetworkingService.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/6/19.
//

import Foundation

class NetworkingService {
    
    static let shared = NetworkingService()
    private init() {}
    
    public func getData(completion: @escaping(Question) -> ()) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=20&type=boolean") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do {
                let decoded = try JSONDecoder().decode(Question.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
}


