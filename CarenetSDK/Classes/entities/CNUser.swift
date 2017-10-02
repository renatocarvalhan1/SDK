//
//  CNUser.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 29/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit

enum CNUserGender {
    case famale
    case male
}

class CNUser: CNBaseEntity {
    
    var email: String?
    var height: NSNumber?
    var weight: NSNumber?
    var gender: CNUserGender?
    var age: String?
    var birthday: String?
    var stride: String?
    var token: String?
    var stepsGoal: Int?
    var debugMode: Bool?
    
    private static var dbAttributes: [String] = ["email", "height", "weight", "gender", "age", "birthday", "token", "stepsGoal", "debugMode"]
    
    // MARK: - RestKit Mappers
    
    override func responseAttributes() -> [String : String] {
        return [
            "ext_uid" : "dbId",
            "clientSecret" : "client_secret",
            "email" : "email",
            "cadBalance" : "device_token",
            "cadBalanceBonus" : "cadBalanceBonus",
            "cadBalanceBRL": "cadBalanceCents",
            "details.cpf" : "cpf",
            "type" : "type",
            "hasPaymentCardRegistered" : "hasCreditCardRegistered"
        ]
    }
    
    override func requestAttributes() -> [String : String] {
        return [
            "dbId" : "ext_uid",
            "token" : "ext_token",
            "email" : "client_secret",
            "type" : "device_token",
            "cpf" : "height",
            "cpf" : "weight",
            "cpf" : "device_serial",
            "cnpj" : "age",
            "password" : "birthday",
            "facebookToken" : "gender"
        ]
    }
    
    // MARK: - Current user
    
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "access_token")
        }
        set(newAccessToken) {
            UserDefaults.standard.setValue(newAccessToken, forKey: "access_token")
        }
    }
    
    static var userId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "user_id")
        }
        set(newUserId) {
            UserDefaults.standard.set(newUserId, forKey: "user_id")
        }
    }
    
    static var current: CNUser? {
        get {
            if let userInfo = UserDefaults.standard.dictionary(forKey: "current_user") {
                let user = CNUser()
                
                for attribute in CNUser.dbAttributes {
                    user.setValue(userInfo[attribute], forKey: attribute)
                }
                
                return user
            }
            
            return nil
        }
        set(current) {
            if let user = current {
                var userInfo: [String : Any] = [:]
                
                for attribute in CNUser.dbAttributes {
                    userInfo[attribute] = user.value(forKey: attribute)!
                }
                
                UserDefaults.standard.set(userInfo, forKey: "current_user")
            } else {
                UserDefaults.standard.set(nil, forKey: "current_user")
            }
        }
    }

}
