//
//  AddEventViewController.swift
//  FOCUS_Project
//
//  Created by Nicolas on 16/05/2017.
//  Copyright © 2017 Nicolas Charvoz. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController{

    @IBOutlet weak var tapmeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        let strDate = dateFormatter.string(from: Date())
        dateLabel.text = strDate
        setupImagePickerButton()
        self.hideKeyboardWhenTappedAround() 
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
        
        let name = nameTextField.text
        let price = priceTextField.text
        let address = addressTextField.text
        let date = dateLabel.text
        
        if name != "", price != "", address != "", date != "", (imgView.image != nil) {
            
            // Build the new Joke.
            // AnyObject is needed because of the votes of type Int.
            
            var uploadImage = imgView.image!
            uploadImage = resizeImage(image: uploadImage, newWidth: 64)
            
            let imgData = UIImagePNGRepresentation(uploadImage)
            
            let base64string = imgData?.base64EncodedString(options: .lineLength64Characters)
            
            
            let newEvent: Dictionary<String, AnyObject> = [
                "name": name as AnyObject,
                "address": address as AnyObject,
                "price": Float(price!) as AnyObject,
                "date": date as AnyObject,
                "icon": base64string as AnyObject
            ]
            
            // Send it over to DataService to seal the deal.
            
            DataService.dataService.createNewEvent(event: newEvent)
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
    func setupImagePickerButton()
    {
        tapmeButton.setTitle("Add icon", for: .normal)
        
    }
    
    @IBAction func tapmeAction(_ sender: Any) {
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

}

extension AddEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgView.backgroundColor = UIColor.clear
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        tapmeButton.setTitle("", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
