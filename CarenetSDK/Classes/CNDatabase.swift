//
//  Database.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 05/10/17.
//

import UIKit
import FirebaseCommunity

class Database: NSObject {
    //Mark: root references
    static func auth()->Auth{
        return Auth.auth()
    }
    
    static func currentUser()->User{
        return auth().currentUser!
    }
    
    static func instanceId()->InstanceID{
        return InstanceID.instanceID()
    }
    
    static func database()->Database{
        return Database.database()
    }
    
    static func databaseReference()->DatabaseReference{
        return database().reference()
    }
    
    static func storage()->Storage{
        return Storage.storage()
    }
    
    static func storageReference()->StorageReference{
        return storage().reference()
    }
}
