//
//  ViewController.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Firebase
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        print(ref)

        /* ============= */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        
        // CONFIGURATION
        
        // observeEventType is called whenever anything changes in the Firebase - new Jokes or Votes.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        DataService.dataService.EVENT_REF.observe(.value, with: { snapshot in
            
            // The snapshot is a current look at our event data.
            
            //print(snapshot.value ?? "null")
            
            self.events = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our events array for the tableView.
                    
                    if let events = snap.children.allObjects as? [FIRDataSnapshot] {
                        for event in events {
                            if let postDictionary = event.value as? Dictionary<String, AnyObject> {
                                let key = event.key
                                let newEvent = Event(key: key, dictionary: postDictionary)
                                
                                // Items are returned chronologically, but it's more fun with the newest jokes first.
                                self.events.insert(newEvent, at: 0)
                            }
                        }
                    }
                }
                
            }
            
            // Be sure that the tableView updates when there is new data.
            
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        destination.event = events[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            DataService.dataService.deleteEvent(forKey:events[indexPath.row].eventKey)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventViewCell
        
        cell.initCell(event: events[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }


}

