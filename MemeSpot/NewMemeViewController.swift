//
//  NewMemeViewController.swift
//  MemeMe 1.0
//
//  Created by Udumala, Mary on 3/8/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class NewMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var albumButton: UIButton!
        
    @IBOutlet var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButtonsLook(button: albumButton)
        customizeButtonsLook(button: cameraButton)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func customizeButtonsLook(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.yellow
    }
    
    @IBAction func pickNewImage(_ sender: Any) {
        
        guard let button = sender as? UIButton else {
            return
        }
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if button == self.albumButton {
            pickerController.sourceType = .photoLibrary
        } else if button == self.cameraButton {
            pickerController.sourceType = .camera
        }
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.delegate = self
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeEditorVC.picture = image
        }
        dismiss(animated: true, completion: nil)
        self.present(memeEditorVC, animated: true, completion: nil)        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
