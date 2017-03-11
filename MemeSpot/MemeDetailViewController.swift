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
    let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
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
    
}
