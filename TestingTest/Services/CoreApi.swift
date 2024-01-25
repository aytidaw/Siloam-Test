//
//  CoreApi.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation
import Alamofire

@objc protocol CoreApiDelegate {
    @objc func finish(interFace : CoreApi, responseHeaders : HTTPURLResponse, data : Data)
    @objc func failed(interFace : CoreApi, result : AnyObject)
}

class CoreApi : NSObject {
    
    weak var delegate : CoreApiDelegate?
    var serviceConfig: ServiceConfig?

    func getRequest(_ serviceConfig: ServiceConfig){
        
        AF.request(serviceConfig).responseData { response in
            if Constants.IS_DEBUG {
                print("Header >>> \(String(describing: response.request?.allHTTPHeaderFields))\n")
                print("URL Request >>> \(String(describing: response.request))\n")
                if let requestBody = response.request?.httpBody {
                    do {
                        let json = try JSONSerialization.jsonObject(with: requestBody, options: .allowFragments) as? [String:Any]
                        let jsonData = try JSONSerialization.data(withJSONObject: json ?? [:], options: [])
                        let responseString = String(data: jsonData, encoding: .utf8)!
                        print("Param >>> \(String(describing: responseString))\n")
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
                print("statusCode >>> \(String(describing: response.response?.statusCode))\n")
                // result of response
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments) as? [String:Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: json ?? [:], options: [])
                    let responseString = String(data: jsonData, encoding: .utf8)!
                    print("Response \(String(describing: responseString))")
                } catch {
                    print(error)
                }
                
            }

            self.serviceConfig = serviceConfig
            
            if Helper.isConnectedToInternet() {
                switch response.result {
                case .success( _):
                    // do your statement
                    let statusCode = response.response?.statusCode
                    switch (statusCode) {
                    case 200, 201:
                        guard let responseHeader = response.response else { return }
                        guard let data = response.data else { return }
                        self.success(responseHeaders: responseHeader, data: data)
                    default:
                        self.failed(data: response.data as AnyObject)
                    }
                case .failure(let error):
                    switch error {
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .timedOut:
                        print("Request timeout!")
                        self.delegate?.failed(interFace: self, result: "Slow Internet Connection" as AnyObject)
                    default:
                        self.delegate?.failed(interFace: self, result: error as AnyObject)
                    }
                }
                
            } else {
                self.delegate?.failed(interFace: self, result: "No Internet Connection" as AnyObject)
            }
        }
    }
    
    //MARK : RESPONSE SUCCESS
    func success(responseHeaders : HTTPURLResponse, data : Data) {
        delegate?.finish(interFace: self, responseHeaders : responseHeaders, data : data)
    }
    
    //MARK : RESPONSE FAILED
    func failed(data : AnyObject) {
        delegate?.failed(interFace: self, result: data)
    }

}
