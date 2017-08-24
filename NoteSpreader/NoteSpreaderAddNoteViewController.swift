//
//  NoteSpreaderAddNoteViewController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit

class NoteSpreaderAddNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyBoardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isHidden = true
        
        textView.delegate = self
        textView.text = "Type note here"
        textView.textColor = UIColor.lightGray

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
    
    // MARK: - Keyboard presentation
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
                self.keyBoardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    
    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
    }
}
