//
//  DetailViewController.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tapMeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleTf: UITextField!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    var event: Event! = nil
    
    var editModeIsEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        
        setupNormalView()
        
    }
    
    func setupNormalView() {
        datePicker.isHidden = true
        saveButton.isHidden = true
        tapMeButton.setTitle("", for: .normal)

        titleTf.text = event.eventName
        titleTf.isUserInteractionEnabled = false
        
        let base64string = event.eventIcon
        let decodedString = Data(base64Encoded: base64string, options: .ignoreUnknownCharacters)
        let decodedImg = UIImage(data: decodedString!)
        imgView.image = decodedImg

        
        addressTf.text = event.eventAddress
        addressTf.isUserInteractionEnabled = false

        priceTf.text = "$" + String(event.eventPrice)
        priceTf.isUserInteractionEnabled = false

        
        dateLabel.text = event.eventDate
        dateLabel.isUserInteractionEnabled = false
    }
    
    func setupEditView() {
        datePicker.isHidden = false
        saveButton.isHidden = false
        tapMeButton.setTitle("Tap Me", for: .normal)
        
        titleTf.isUserInteractionEnabled = true
        addressTf.isUserInteractionEnabled = true
        priceTf.text = String(event.eventPrice)
        priceTf.isUserInteractionEnabled = true
        dateLabel.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.dateLabel.text = strDate
    }

    @IBAction func tapMeAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func editAction(_ sender: Any) {
        if (!editModeIsEnabled) {
            editModeIsEnabled = true
            setupEditView()
        } else {
            editModeIsEnabled = false
            setupNormalView()
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if (editModeIsEnabled) {
            editModeIsEnabled = false
            
            if priceTf.text != "", titleTf.text != "", addressTf.text != "", dateLabel.text != "", (imgView.image != nil) {
                
                // Build the new Joke.
                // AnyObject is needed because of the votes of type Int.
                
                var uploadImage = imgView.image!
                uploadImage = resizeImage(image: uploadImage, newWidth: 64)
                
                let imgData = UIImagePNGRepresentation(uploadImage)
                
                let base64string = imgData?.base64EncodedString(options: .lineLength64Characters)
                
                
                let newEvent: Dictionary<String, AnyObject> = [
                    "name": titleTf.text as AnyObject,
                    "address": addressTf.text as AnyObject,
                    "price": Float(priceTf.text!) as AnyObject,
                    "date": dateLabel.text as AnyObject,
                    "icon": base64string as AnyObject
                ]
                
                // Send it over to DataService to seal the deal.
                
                DataService.dataService.updateEvent(forKey: event.eventKey, event: newEvent) {
                    (success) in
                    if (success) {
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }
                }
                
                
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            editButton.title = "Save"
        } else {
            editButton.title = "Edit"
        }
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgView.backgroundColor = UIColor.clear
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        tapMeButton.setTitle("", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

