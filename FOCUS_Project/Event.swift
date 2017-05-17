//
//  Event.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Event {
    private var _eventRef: FIRDatabaseReference!
    
    private var _eventKey: String!
    private var _eventName: String!
    private var _eventAddress: String!
    private var _eventPrice: Float!
    private var _eventDate: String!
    private var _eventIcon: String!
    
    var eventKey: String {
        return _eventKey
    }
    
    var eventName: String {
        return _eventName
    }
    
    var eventAddress: String {
        return _eventAddress
    }
    
    var eventPrice: Float {
        return _eventPrice
    }
    
    var eventDate: String {
        return _eventDate
    }
    
    var eventIcon: String {
        return _eventIcon
    }
    
    
    // Initialize the new event
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._eventKey = key
        
        // Within the event, or Key, the following properties are children
        
        if let name = dictionary["name"] as? String {
            self._eventName = name
        }
        
        if let address = dictionary["address"] as? String {
            self._eventAddress = address
        }
        
        if let price = dictionary["price"] as? Float {
            self._eventPrice = price
        }
        
        if let date = dictionary["date"] as? String {
            self._eventDate = date
        }
        
        if let icon = dictionary["icon"] as? String {
            self._eventIcon = icon
        }
        
        // The above properties are assigned to their key.
        
        self._eventRef = DataService.dataService.EVENT_REF.child(self.eventKey)
    }
}
