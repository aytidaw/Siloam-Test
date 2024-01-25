//
//  Constants.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

struct Constants {
    static let IS_DEBUG = false
    static let BASE_URL = "http://www.themealdb.com/api/json/v1/1/"
    
    enum ConstantText: String {
        case isLoggin = "isLoggin"
        case Alert = "Alert"
        case SignUp = "Sign Up"
        case MessageInputField = "Please input your username and password"
        case LoginFailed = "Login Failed"
        case LoginFailedMessage = "Your email or password is not registered, please check again"
        case SignUpFailed = "Sign Up Failed"
        case SignUpFailedMessage = "Username already taken. Please choose another one."
        case ErrorMappingData = "Error mapping data"
        case ErrorSomethinWrong = "something went wrong"
        case EmptyStateTitle = "Oopps..."
        case EmptyStateMessage = "Please search for more food"
    }
}
