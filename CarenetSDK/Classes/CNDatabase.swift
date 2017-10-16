//
//  CNDatabase.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 05/10/17.
//

import UIKit
import FirebaseCommunity

class CNDatabase: NSObject {
    
    static var firebaseDatabase: Database?
    static var keepSynchedFlag = false
    
    // Mark: root references
    static func auth() -> Auth {
        return Auth.auth()
    }
    
    static func currentUser() -> User {
        return auth().currentUser!
    }
    
    static func database() -> Database {
        
//        if firebaseDatabase == nil {
//            firebaseDatabase = Database.database()
//        }
//        
//        if currentUser() != nil && !keepSynchedFlag {
//            firebaseDatabase?.reference().child("users/" + currentUser().uid).keepSynced(true)
//        }
        
        return Database.database()
    }
    
    static func databaseReference() -> DatabaseReference {
        return database().reference()
    }
    
    static func storage() -> Storage{
        return Storage.storage()
    }
    
    static func storageReference() -> StorageReference {
        return storage().reference()
    }
    
    // Mark: database references
    static func integrationDatabaseReference() -> DatabaseReference {
        return databaseReference().child("integration")
    }
    
    static func devicesDatabaseReference(integration: String) -> DatabaseReference {
        return databaseReference().child("devices").child(integration)
    }
    
    static func userDevicesDatabaseReference() -> DatabaseReference {
        return databaseReference().child("users").child("3cGuDoyx5zThyjkPhHXg6Cx2mZj2").child("devices")
//        return databaseReference().child("users").child(currentUser().uid).child("devices")
    }
    
    static func deviceConnectionDatabaseReference(device: String) -> DatabaseReference {
        return userDevicesDatabaseReference().child(device).child("connection")
    }

}
