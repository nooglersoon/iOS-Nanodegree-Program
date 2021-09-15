//
//  DetailMemeViewViewController.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 17/08/21.
//

import UIKit

class DetailMemeVC: UIViewController {
    
    
    @IBOutlet weak var detailMemeImageView: UIImageView!
    var _image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let image = _image {
            
            detailMemeImageView.image = image
            
        }
        
    }
    

   

}
