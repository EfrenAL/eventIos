//
//  ProfileViewController.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 11/10/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CommonCrypto


class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userDescription: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    private var networkManager: UserManager! = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapDetected))
        singleTap.numberOfTapsRequired = 1
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(singleTap)
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        if userRepository.id != -1 {
            userName.text = userRepository.name
            userEmail.text = userRepository.email
            userDescription.text = userRepository.description
            if userRepository.pictureUrl != nil {
                userImage.sd_setImage(with: URL(string: userRepository.pictureUrl!), placeholderImage:UIImage(named: userRepository.email), options: .refreshCached)                
            }
        }        
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Camara", "Photo Library", "Camera Roll"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpdateTap(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
     
        let body = ["email" : userEmail.text!,
                    "description" : userDescription.text!,
                    "name" : userName.text!] as [String:String]
        
        networkManager.editProfile(token: getUserToken(),body: body) { (user, error) in
            
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if let error = error {
                print(error)
            }
            if let user = user {
                print("Everything work out")
                print(user)                
            }
        }
    }
    
    func removeActivityIndicator( activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func getUserToken() -> [String:String] {
        let userToken: String? = KeychainWrapper.standard.string(forKey: "userToken")
        let token = ["Auth" : userToken] as! [String:String]
        return token
    }
    
    //Action
    @objc func tapDetected() {
        picker.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("No image found")
            return
        }
        let manager = AwsManager()
        manager.uploadData(image: image, name: MD5(string:userEmail.text!) + ".png", token: getUserToken())        
    }
    
    
    func MD5(string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        picker.isHidden = true
        
        let vc = UIImagePickerController()
        switch row {
        case 1:
            vc.sourceType = .camera
        case 2:
            vc.sourceType = .photoLibrary
        case 3:
            vc.sourceType = .savedPhotosAlbum
        default:
            vc.sourceType = .camera
        }            
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


}
