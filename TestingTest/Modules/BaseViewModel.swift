//
//  BaseViewModel.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

class BaseViewModel {
    
    var api = CoreApi()
    
    init() {
        api.delegate = self
    }
}

extension BaseViewModel: CoreApiDelegate {
    func finish(interFace: CoreApi, responseHeaders: HTTPURLResponse, data: Data) {
    }
    
    func failed(interFace: CoreApi, result: AnyObject) {
    }
}
