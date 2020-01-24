//
//  MovieController.swift
//  MovieSearch
//
//  Created by Devin Singh on 1/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit


class MovieController {
    // MARK: - Properties
    static private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    static private let apiKey = "39d904dde4dc4dde066f480c7b98650c"
    static private let movieQuery = "query"
    // MARK: - Methods
    static func getMovies(withTitle title: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        // API handles case sensitivity
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let pageQuery = URLQueryItem(name: movieQuery, value: title)
        
        // Adds query to queryItems array of components
        components?.queryItems = [apiKeyQuery, pageQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        // Grabbing data from url
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noDataFound))}
            
            do {
                
                let people = try JSONDecoder().decode(TopLevelObject.self, from: data)
                return completion(.success(people.results))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func getImageFromPath(urlPath: String, completion: @escaping(Result<UIImage, NetworkError>) -> Void) {
        guard let baseURL = URL(string: "https://image.tmdb.org/t/p/w500") else { return completion(.failure(.invalidURL))}
        
        let finalURL = baseURL.appendingPathComponent(urlPath)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noDataFound))}
            
            guard let image = UIImage(data: data) else { return completion(.failure(.noDataFound)) }
            
            return completion(.success(image))
        }.resume()
    }
}

