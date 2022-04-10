//
//  Network.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

protocol INetworkService
{
    func loadData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: INetworkService
{
    private let session: URLSession

    init(configuration: URLSessionConfiguration? = nil) {
        if let configuration = configuration {
            self.session = URLSession(configuration: configuration)
        }
        else {
            self.session = URLSession(configuration: URLSessionConfiguration.default)
        }
    }

    func loadData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: "https://limehd.online/playlist/") else { fatalError("Сообщение") }

        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
//                    print("[NETWORK] \(response)")
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

