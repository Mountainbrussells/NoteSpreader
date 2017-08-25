//
//  NoteSpreaderAddNoteViewController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class NoteSpreaderAddNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyBoardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    let coreDataController = BARCoreDataController.sharedInstance
    let locationController = BARLocationController()
    
    var noteID: NSManagedObjectID?
    var note: Note?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if noteID == nil {
            textView.text = "Type note here"
            textView.textColor = UIColor.lightGray
            doneButton.isHidden = true
            locationButton.isHidden = true
            
        } else {
            note = coreDataController.container.viewContext.object(with: noteID!) as? Note
            
            textView.text = note?.text
            doneButton.isHidden = true
            saveButton.isHidden = true
            locationButton.isHidden = false
        }
        
        
        textView.delegate = self
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type note here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Keyboard presentation and dismissal
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                doneButton.isHidden = true
                self.keyBoardHeightLayoutConstraint?.constant = 0.0
            } else {
                doneButton.isHidden = false
                saveButton.isHidden = false
                self.keyBoardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // MARK: - Button implimentation
    
    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard textView.text.characters.count > 0 && textView.text != "Type note here" else {
            let alertController = UIAlertController(title: "No text", message: "there is nothing to save", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        if note == nil {
            note = Note(context: coreDataController.container.viewContext)
            let location = Location(context: coreDataController.container.viewContext)
            location.lattitude = (locationController.location?.coordinate.latitude)!
            location.longitude = (locationController.location?.coordinate.longitude)!
            note?.location = location
        }
        
        note?.text = textView.text
        
        coreDataController.saveContext()
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showLocation(_ sender: Any) {
        guard let location = note?.location else {
            let alertController = UIAlertController(title: "No Location", message: "there is no location for this note", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        locationController.showLocation(location)
    }
    
    
}
