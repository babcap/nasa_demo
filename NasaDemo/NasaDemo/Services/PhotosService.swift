//
//  PhotosService.swift
//  NasaDemo
//
//  Created by Arthur on 24.08.2023.
//

import Foundation

typealias PhotosCompletion = (Bool, Photos?, String?) -> ()

protocol PhotosServiceProtocol {
    func getPhotos(with: SearchModel, page: Int, completion: @escaping PhotosCompletion)
}

class PhotosService: PhotosServiceProtocol {
    func getPhotos(with searchModel: SearchModel, page: Int, completion: @escaping PhotosCompletion) {
        guard let request = self.createRequest(for: searchModel, page: page) else {
            completion(false, nil, "Error: Can't create request")
            return
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in

            if error != nil{
                print("error While Fetching Data")
            }
            
            guard let data = data else {
                completion(false, nil, "Error: Photos GET Request failed")
                return
            }
            do {
                let model = try JSONDecoder().decode(PhotosResponse.self, from: data)
                completion(true, model.photos, nil)
            } catch  {
                completion(false, nil, "Error: Trying to parse Photos to model")
            }
        }.resume()
    }

    private func createRequest(for searchModel: SearchModel, page: Int) -> URLRequest? {
        let apiKey = "xSoF4b3JLmmNIFCam22TJkXF5mm2KGLw50ZUZHsd"

        var params = searchModel.queryParams()
        let apiKeyParam = URLQueryItem(name: "api_key", value: apiKey)
        params.append(URLQueryItem(name: "page", value: "\(page)"))
        params.append(apiKeyParam)

        var urlComponents = URLComponents(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(searchModel.rover.rawValue.lowercased())/photos")
        urlComponents?.queryItems = params
        let encodedQuery = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        urlComponents?.percentEncodedQuery = encodedQuery ?? ""

        guard let url = urlComponents?.url else {
            return nil
        }

        let request = URLRequest(url: url)
        return request
    }
}
