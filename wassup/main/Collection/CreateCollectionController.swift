//
//  CreateCollectionController.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma

class CreateCollectionController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    @IBAction func goBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        let md = Collection()
        let avatarData = UIImagePNGRepresentation(img.image!)
        let name = self.name.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if name == "" || avatarData == nil {
            let alert = UIAlertView(title: Localization("Thông báo"), message: Localization("Tên và ảnh đại diện không được rỗng"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        md.createCollection(name!, icon: avatarData!) {
            (result: AnyObject?) in
            print(result)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

extension CreateCollectionController: FusumaDelegate {
    func fusumaImageSelected(image: UIImage) {
        img.image = image
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
}