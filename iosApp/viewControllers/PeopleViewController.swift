//
//  PeopleViewController.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 16/10/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    var index: Int = -1
    
    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var peopleName: UILabel!
    @IBOutlet weak var peopleEmail: UILabel!
    @IBOutlet weak var peopleDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        peopleImage.layer.cornerRadius = peopleImage.frame.size.width / 2
        peopleImage.clipsToBounds = true
        
        if index != -1 {
            peopleName.text = peopleRepository[index].name
            peopleEmail.text = peopleRepository[index].email
            peopleDescription.text = peopleRepository[index].description
            
            if peopleRepository[index].pictureUrl != nil {
                peopleImage.sd_setImage(with: URL(string: peopleRepository[index].pictureUrl!), placeholderImage: UIImage(named: "peoplePlaceholder.png"))
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
