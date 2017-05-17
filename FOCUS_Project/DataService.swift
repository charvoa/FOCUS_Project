//
//  DataService.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let BASE_URL = "https://focus-project-a3b2d.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _EVENT_REF = FIRDatabase.database().reference()
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var EVENT_REF: FIRDatabaseReference {
        return _EVENT_REF
    }
    
    func createNewEvent(event: Dictionary<String, AnyObject>) {
        
        // Save the Event
        // EVENT_REF is the parent of the new Event: "events".
        // childByAutoId() saves the event and gives it its own ID.
        
        let firebaseNewEvent = EVENT_REF.child("Event").childByAutoId()
        
        // setValue() saves to Firebase.
        
        firebaseNewEvent.setValue(event)
    }
    
    func updateEvent(forKey: String, event: Dictionary<String, AnyObject>, completionHandler: @escaping (_ success: Bool) -> Void) {
        let fbUpdateEvent = EVENT_REF.child("Event").child(forKey)
        
        fbUpdateEvent.updateChildValues(event, withCompletionBlock: { (error, _) in
            if error != nil {
                print(error?.localizedDescription ?? "Failed to set status value")
                completionHandler(false)
            }
            print("Successfully set status value")
            completionHandler(true)

        })
        
    }
    
    func deleteEvent(forKey: String) {
        
        let fbUpdateEvent = EVENT_REF.child("Event").child(forKey)
        
        fbUpdateEvent.removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}
