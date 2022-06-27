//
//  APIClient.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

enum NetworkError: Error {
    case emptyData
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        let allowedCharacters = CharacterSet.urlQueryAllowed
        
        guard let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
              let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else { fatalError() }
        
        urlSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                return completionHandler(nil, error)
            }
            
            guard let data = data else {
                completionHandler(nil, NetworkError.emptyData)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: String]
                let token = dict?["token"]
                completionHandler(token, nil)
                
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
}
