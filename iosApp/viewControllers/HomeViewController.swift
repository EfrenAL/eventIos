//
//  HomeViewController.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 21/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SDWebImage



class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var userManager: UserManager! = UserManager()
    private var eventManager: EventsManager! = EventsManager()
    var events: [Event]?
    var users: [User]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    let collectionViewBIdentifier = "EventsCollectionView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestEvents()        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.collectionView){
            if self.events == nil {
                return 1
            }
            else{
                return (self.events!.count + 1)
            }
        }else {
            if self.users == nil{
                return 0
            } else{
                return self.users!.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
            if indexPath.row == 0 {
                cell.imgImage.image = UIImage(named: "pluse")
            } else {
                cell.imgImage.sd_setImage(with: URL(string: events![indexPath.row - 1 ].thumbnailUrl), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            return cell
        } else {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCollectionViewCell", for: indexPath) as! PeopleCollectionViewCell
            
            cell.peopleName.text = users![indexPath.row].name
            cell.peopleDescription.text = users![indexPath.row].description
            
            if(users![indexPath.row].pictureUrl == nil){
                cell.peopleImage.image = UIImage(named: "profile")
            }else {
                cell.peopleImage.layer.cornerRadius = cell.peopleImage.frame.size.width / 2
                cell.peopleImage.clipsToBounds = true
                
                cell.peopleImage.sd_setImage(with: URL(string: users![indexPath.row].pictureUrl!), placeholderImage: UIImage(named: "peoplePlaceholder.png"))
            }
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPeople(_:))))
            return cell
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            if(index.row == 0){
                showInputDialog()
            }else{
                requestUsersEvent(eventId: String(self.events![index.row - 1].id))
            }
        }
    }
    
    @objc func tapPeople(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.peopleCollectionView)
        let indexPath = self.peopleCollectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "PeopleViewController") as! PeopleViewController
            
            registerViewController.index = index.row
            self.navigationController!.pushViewController(registerViewController, animated: true)
            //self.present(registerViewController, animated: true)
            print("Got clicked on index: \(index)!")
        }
    }
    
    
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter event code!", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            //getting the input values from user
            let code = alertController.textFields?[0].text
            print(code)
            self.signupEvent(code: code!)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in textField.placeholder = "Enter Code" }
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserToken() -> [String:String] {
        let userToken: String? = KeychainWrapper.standard.string(forKey: "userToken")
        let token = ["Auth" : userToken] as! [String:String]
        return token
    }
    
    func requestEvents(){
        userManager.userEvents(token: getUserToken()) { (eventsResponse, error) in
            //self.removeActivityIndicator(activityIndicator: activityIndicator)
            if let error = error {
                print(error)
            }
            if let events = eventsResponse {
                self.events = events
                print(self.events ?? "")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                //self.displayMessage(userMessage: "Account created successfully!")
            }
        }
    }
    
    func signupEvent(code: String){
        userManager.signUpEvent(token: getUserToken(), code: code){ (eventsResponse, error) in
            if let error = error {
                print(error)
            }
            if let events = eventsResponse {
                self.events = events
                print(self.events ?? "")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func requestUsersEvent(eventId: String){
        eventManager.getPeopleEvent(token: getUserToken() , eventId: eventId) { (usersResponse, error) in

            if let error = error {
                print(error)
            }
            if let users = usersResponse {
                self.users = users
                print(self.users ?? "")
                DispatchQueue.main.async {
                    self.peopleCollectionView.reloadData()
                }
            }
        }
    }
    
}
