//
//  SearchViewModel.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func success(data: [MealModel])
    func failedReq(message: String)
}

class SearchViewModel: BaseViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    
    var dataSource: [MealModel] = []
    
    func fetchDataList(query: String) {
        api.getRequest(ServiceConfig.getSearchMeal(query: query))
    }
    
    override init() {
        super.init()
    }
    
    override func finish(interFace: CoreApi, responseHeaders: HTTPURLResponse, data: Data) {
        do {
            switch interFace.serviceConfig {
            case .getSearchMeal:
                let response = try JSONDecoder().decode(MealsModel.self, from: data)
                if let validData = response.meals {
                    delegate?.success(data: validData)
                } else {
                    delegate?.success(data: [])
                }
            default:
                break
            }
        } catch _ {
            delegate?.failedReq(message: Constants.ConstantText.ErrorMappingData.rawValue)
        }
    }
    
    override func failed(interFace: CoreApi, result: AnyObject) {
        if let response = result as? String {
            delegate?.failedReq(message: response)
        }else{
            delegate?.failedReq(message: Constants.ConstantText.ErrorSomethinWrong.rawValue)
        }
    }
}

