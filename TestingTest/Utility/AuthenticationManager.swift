//
//  AuthenticationManager.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

class AuthenticationManager {
    
    private static let keyPrefix = "UserData_"
    
    // MARK: - Sign Up
    static func signUp(username: String, password: String) -> Bool {
        
        if userExists(username: username) {
            return false
        }
        
        // Store user data in UserDefaults with a unique key for each user
        let userDefaultsKey = keyForUsername(username: username)
        var userData = UserDefaults.standard.dictionary(forKey: userDefaultsKey) ?? [:]
        userData[username] = username
        userData[password] = password
        UserDefaults.standard.set(userData, forKey: userDefaultsKey)
        return true
    }
    
    // MARK: - Sign In
    static func signIn(username: String, password: String) -> Bool {
        
        let userDefaultsKey = keyForUsername(username: username)
        guard let userData = UserDefaults.standard.dictionary(forKey: userDefaultsKey),
              let storedUsername = userData[username] as? String,
              let storedPassword = userData[password] as? String
        else {
            print("User does not exist.")
            return false
        }
    
        if username == storedUsername && password == storedPassword {
            print("Sign in successful.")
            return true
        } else {
            print("Invalid credentials. Sign in failed.")
            return false
        }
    }
    
    private static func userExists(username: String) -> Bool {
        let userDefaultsKey = keyForUsername(username: username)
        if let userData = UserDefaults.standard.dictionary(forKey: userDefaultsKey),
           let storedUsername = userData[username] as? String {
            return storedUsername == username
        }
        return false
    }
    
    private static func keyForUsername(username: String) -> String {
        return keyPrefix + username
    }
}

