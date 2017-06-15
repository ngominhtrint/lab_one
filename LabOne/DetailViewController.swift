//
//  DetailViewController.swift
//  LabOne
//
//  Created by TriNgo on 6/15/17.
//  Copyright © 2017 Huvvit. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: urlString!) {
            photoImageView.setImageWith(url)
        }
    }
}
