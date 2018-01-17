//
//  CNDatabase.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 05/10/17.
//

import UIKit
import FirebaseCommunity

class CNDatabase: NSObject {
    
    static var firebaseDatabase: Database!
    static var keepSynchedFlag = false
    
    // MARK: root references
    
    static func auth() -> Auth {
        return Auth.auth()
    }
    
    static func currentUser() -> User? {
        return auth().currentUser
    }
    
    static func database() -> Database {
        if firebaseDatabase == nil {
            firebaseDatabase = Database.database()
        }
        if currentUser() != nil && !keepSynchedFlag {
            firebaseDatabase.reference().child("users/\(currentUser()!.uid)").keepSynced(true)
            keepSynchedFlag = true
        }
        return firebaseDatabase
    }
    
    static func databaseReference() -> DatabaseReference {
        return database().reference()
    }
    
    // MARK: database references
    
    static func integrationDatabaseReference() -> DatabaseReference {
        return databaseReference().child("integration")
    }
    
    static func devicesDatabaseReference(device: String) -> DatabaseReference {
        return databaseReference().child("devices").child(device)
    }
    
    static func connectionsDatabaseReference() -> DatabaseReference {
        return databaseReference().child("connections").child(currentUser()!.uid)
    }
    
    static func userDevicesDatabaseReference() -> DatabaseReference {
        return databaseReference().child("users").child(currentUser()!.uid)
    }
    
    static func deviceConnectionDatabaseReference(key: String) -> DatabaseReference {
        return userDevicesDatabaseReference().child(key).child("connection")
    }
    
    static func fetchConnectionByUser(completion: @escaping ([CNConnection]) -> ()) {
        var connections = [CNConnection]()
        CNDatabase.connectionsDatabaseReference().observeSingleEvent(of: .value, with: { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var connection = CNConnection(data: dictionary)
                connection.dbId = snapshot.key
                connections.append(connection)
            })
            completion(connections)
        })
    }

}
