//
//  ViewController.swift
//  UIImagePDFSupport
//
//  Created by Pawel Kijowski Silver on 4/18/17.
//  Copyright © 2017 Pawel Kijowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(pdfFileName: "Icon", desiredSize: CGSize(width: 240, height: 240))
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

