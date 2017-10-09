//
//  CNDatabase.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 05/10/17.
//

import UIKit
import FirebaseCommunity

class CNDatabase: NSObject {
    
    // Mark: root references
    static func auth() -> Auth {
        return Auth.auth()
    }
    
    static func currentUser() -> User {
        return auth().currentUser!
    }
    
    static func database() -> Database {
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
        return databaseReference().child("users").child(currentUser().uid).child("devices")
    }
}
