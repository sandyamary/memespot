//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Udumala, Mary on 3/8/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    var totalAvailableMemes: Int!
    var currentMemeIndex: Int!
    var allMemes = [Meme]()
    
    @IBOutlet var memeDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        self.memeDetailImage.backgroundColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        memeDetailImage.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth]
        memeDetailImage.contentMode = UIViewContentMode.scaleAspectFill
        self.memeDetailImage!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let image = self.memeDetailImage.image
        let controller = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showPreviousImage(_ sender: Any) {
        if currentMemeIndex != 0 {
            memeDetailImage.image = allMemes[currentMemeIndex - 1].memedImage
            currentMemeIndex = currentMemeIndex - 1
        }
    }
    
    @IBAction func showNextImage(_ sender: Any) {
        totalAvailableMemes = allMemes.count
        if currentMemeIndex+1 != totalAvailableMemes {
            memeDetailImage.image = allMemes[currentMemeIndex + 1].memedImage
            currentMemeIndex = currentMemeIndex + 1
        }
    }
    
    
    @IBAction func deleteMeme(_ sender: Any) {
        deletePhotoFromMemes()
        totalAvailableMemes = allMemes.count
        if totalAvailableMemes == 0 {
            self.navigationController?.popToRootViewController(animated: true)
        } else if totalAvailableMemes == currentMemeIndex {
            memeDetailImage.image = allMemes[currentMemeIndex - 1].memedImage
            currentMemeIndex = currentMemeIndex - 1
        } else {
            memeDetailImage.image = allMemes[currentMemeIndex].memedImage
        }
    }
    
    func deletePhotoFromMemes() {
        let collectionVC = self.storyboard!.instantiateViewController(withIdentifier: "sentMemesCollectionView") as! sentMemesCollectionView
        collectionVC.appDelegateObject.memes.remove(at: currentMemeIndex)
        allMemes = collectionVC.appDelegateObject.memes
    }
    
}
