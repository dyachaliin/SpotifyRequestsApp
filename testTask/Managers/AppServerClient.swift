//
//  AppServerClient.swift
//  testTask
//
//  Created by Алина Дьяченко on 12.03.2022.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import SwiftUI


struct Constants {
    static let clientID = "4ae63ea913b04e3ea21659ae41ca7ea5"
    static let clientSecret = "22c462d8f65041c3ba0845a0a0341c70"
}
enum GetTracks {
    case success(tracks: [Item])
    case failure(error: Error)
}
enum CustomError: Error {
    case invalidInput
    case notFound
}


extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidInput:
            return "The provided input is not valid."
        case .notFound:
            return "The specified item could not be found."
            
        }
    }
}

class AFManager {
    
    var tokenResult: String?
    var responseItems: [Item] = []
    
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    
    init(){
        self.makeTokenReq(onResult: { res in
            guard (res != nil) else {return}
            self.tokenResult = res!.accessToken
        })
    }
    
    var name: String = ""
    var searchURL: URL? {
        let base = "https://accounts.spotify.com/authorize?"
        let scopes = "user-read-private"
        let redirectURI = "https://whispering-wave-hell.glitch.me/"
        let searchURL = "\(base)response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)"
        return URL(string: searchURL)
    }
    
    func makeTokenReq(onResult: @escaping (URLResult?)->Void) {
        let url = "https://accounts.spotify.com/api/token"
        let params = [ "grant_type" : "client_credentials" ]
        let headers: HTTPHeaders = [ "Authorization" : "Basic NGFlNjNlYTkxM2IwNGUzZWEyMTY1OWFlNDFjYTdlYTU6MjJjNDYyZDhmNjUwNDFjM2JhMDg0NWEwYTAzNDFjNzA=", "Content-Type" :  "application/x-www-form-urlencoded"]
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseDecodable(of: URLResult.self) { response in
            guard let statusCode = response.response?.statusCode, (response.error == nil) else { return }
            if (200..<300).contains(statusCode) {
                if let result = response.value{
                    onResult(result)
                } else {
                    onResult(nil)
                }
                
            }
        }
    }
    
    
    func makeTracksReq(name: String, offset: Int, completion: @escaping (GetTracks) -> Void)  {
        
        if let token = self.tokenResult {
            let getParams = "q=name:\(name)&type=track&limit=10&offset=\(offset)"
            guard let url = URL(string: "https://api.spotify.com/v1/search?" + getParams) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            print("Create request with: \(request)")
            
            session.dataTask(with: request) { [weak self] (data, response, error) in
                var result: GetTracks
                
                guard let strongSelf = self else {
                    result = .failure(error: error!)
                    return
                    
                }
                
                if error == nil, let parseData = data {
                    guard let tracks = try? strongSelf.decoder.decode(TracksResult.self, from: parseData) else {
                        result = .failure(error: CustomError.notFound)
                        return }
                    if tracks.tracks.total > 0 {
                        if let items = tracks.tracks.items {
                            self?.responseItems = items
                            result = .success(tracks: items)
                        } else {
                            result = .failure(error: CustomError.notFound)
                        }
                        
                    } else {
                        result = .failure(error: CustomError.invalidInput )
                    }} else {
                        
                        result = .failure(error: error!)
                    }
                
                DispatchQueue.main.async {
                    completion(result)
                }
                
                
            }.resume()
            
        }
        
    }
    
    
    func makeHREFReq(href: String, onResult: @escaping (DetailInfo)-> Void, onFailure: @escaping (String)-> Void) {
        if let token = self.tokenResult {
            let url = href
            let headers: HTTPHeaders = [ "Authorization" : "Bearer \(token)", "Content-Type" : "application/json"]
            
            print("Create request with: \(url) ")
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseDecodable(of: DetailInfo.self){ response in
                guard let statusCode = response.response?.statusCode, (response.error == nil) else { onFailure("Error 1")
                    return }
                if (200..<300).contains(statusCode) {
                    if let result = response.value{
                        onResult(result)
                    } else {
                        onFailure("Getting result error")
                    }
                    
                } else {
                    onFailure("Response code error!")
                }
            }
        }else{
            onFailure("Token is nil! Cannot create a request")
        }
        
    }
}




