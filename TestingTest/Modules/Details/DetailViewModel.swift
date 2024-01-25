//
//  DetailViewModel.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func success(data: MealModel)
    func failedReq(message: String)
}

class DetailViewModel: BaseViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    var dataSource: MealsModel?
    
    var id = 0
    
    var tempData = [IndigrientsModel]()
    
    func fetchDetailData() {
        api.getRequest(ServiceConfig.getDetail(id: id))
    }
    
    override init() {
        super.init()
    }
    
    override func finish(interFace: CoreApi, responseHeaders: HTTPURLResponse, data: Data) {
        do {
            switch interFace.serviceConfig {
            case .getDetail:
                let response = try JSONDecoder().decode(MealsModel.self, from: data)
                if let meals = response.meals {
                    meals.forEach { meal in
                        delegate?.success(data: meal)
                    }
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

