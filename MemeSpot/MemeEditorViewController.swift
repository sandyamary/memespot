//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by Udumala, Mary on 2/27/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    let newMemeVC = NewMemeViewController()
    var picture: UIImage!
    let memeTextAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 28)!, NSStrokeWidthAttributeName: -3 ]
    
    @IBOutlet var imagePickerView: UIImageView!

    @IBOutlet var topTextView: UITextView!

    @IBOutlet var bottomTextView: UITextView!
    
    @IBOutlet var topToolBar: UIToolbar!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    @IBOutlet var topTextField: UITextField!
    
    @IBOutlet var bottomTextField: UITextField!
    
    //TextView delegate functions
    func textViewDidBeginEditing(_ textView: UITextView) {
        topTextField.isHidden = false
        bottomTextField.isHidden = false
        textView.text = ""
        shareButton.isEnabled = false
        topTextField.becomeFirstResponder()
    }
    
    //limit the number of chars for the meme text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 60
    }
    
    
    //TextField delegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        assignTextFieldTextToTextView(textView: topTextView, textField: topTextField)
        assignTextFieldTextToTextView(textView: bottomTextView, textField: bottomTextField)
        shareButton.isEnabled = true
        textField.resignFirstResponder()
        return true
    }
    
    func assignTextFieldTextToTextView(textView: UITextView, textField: UITextField) {
        textView.text = textField.text?.uppercased()
        //repeating the text attributes code as a workaround for attributes not getting set as expected for bottom view. KNown swift issue.
        let defaultAttributes = NSAttributedString(string: textView.text, attributes: memeTextAttributes)
        textView.attributedText = defaultAttributes
        textView.textAlignment = .center
    }

    
    func customizeTextViewAttributes(textView: UITextView) {
        let defaultAttributes = NSAttributedString(string: textView.text, attributes: memeTextAttributes)
        textView.attributedText = defaultAttributes
    }
    
    func customizeTextView(textView: UITextView, defaultText: String) {
        textView.text = defaultText
        textView.adjustsFontForContentSizeCategory = true
        textView.textAlignment = .center
        
        customizeTextViewAttributes(textView: textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        customizeTextView(textView: topTextView, defaultText: "TAP TO ADD A CAPTION")
        customizeTextView(textView: bottomTextView, defaultText: "TAP TO ADD A CAPTION")
        topTextView.delegate = self
        bottomTextView.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        imagePickerView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth]
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        imagePickerView.image = self.picture
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        topToolBar.isTranslucent = false
        topToolBar.barTintColor = UIColor.yellow
        shareButton.isEnabled = false
    }

    
    
    @IBAction func cancelMemeEditor(_ sender: Any) {
        imagePickerView.image = nil
        topTextView.text = "TOP"
        bottomTextView.text = "BOTTOM"
        
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func generatedMemedImage() -> UIImage {
        
        //hide toolbar and navbar
        
        self.topToolBar.isHidden = true
        
        //grab the memed image only
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //unhide the navbar and toolbar
        self.topToolBar.isHidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        
        let image = generatedMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                if let nav = self.navigationController {
                    nav.popToRootViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
    //function to save the meme
    func save() {
        let meme = Meme(topText: topTextView.text!, bottomText: bottomTextView.text!, originalImage: imagePickerView.image!, memedImage: generatedMemedImage())
        let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
        appDelegateObject.memes.append(meme)
    }
}

