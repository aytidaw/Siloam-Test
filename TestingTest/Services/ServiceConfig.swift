//
//  ServiceConfig.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation
import Alamofire

private let SEARCH_PATH = "search.php"
private let DETAIL_PATH = "lookup.php"

enum ServiceConfig {
    case getSearchMeal(query: String)
    case getDetail(id: Int)
}

extension ServiceConfig: URLRequestConvertible {
    var baseURL: String {
        switch self {
        case .getDetail, .getSearchMeal :
            return Constants.BASE_URL
        }
    }
    
    var path: String {
        switch self {
        case .getSearchMeal:
            return SEARCH_PATH
        case .getDetail:
            return DETAIL_PATH
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDetail, .getSearchMeal:
            return .get
        }
    }
    
    func createURLEncoding(url: URL, param: [String: Any] = [:]) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        
        do {
            urlRequest.httpMethod = method.rawValue
            urlRequest.timeoutInterval = TimeInterval(30)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: param)
        } catch {
            print("ERROR ENCODE URL REQUEST")
        }
        
        return urlRequest
    }

    public func asURLRequest() throws -> URLRequest {
        switch self {
        
        case .getDetail(let id):
            let link = "\(baseURL)\(path)" + "?i=\(id)"
            let url = URL(string: link)!
            let urlRequest = createURLEncoding(url: url)
            return urlRequest
            
        case .getSearchMeal(query: let query):
            let link = "\(baseURL)\(path)" + "?f=\(query)"
            let urlString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: urlString)!
            let urlRequest = createURLEncoding(url: url)
            return urlRequest
        }
    }
}
