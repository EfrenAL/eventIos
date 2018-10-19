//
//  SignupViewController.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 21/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var networkManager: UserManager! = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        if(nameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            displayMessage(userMessage: "All fields are required!")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        
        let body = ["name" : nameTextField.text!,
                    "email" : emailTextField.text!,
                    "password" : passwordTextField.text!] as [String:String]
        
        networkManager.sigunUp(body: body) { (user, error) in
            
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if let error = error {
                print(error)
            }
            if let user = user {
                print(user)
                self.displayMessage(userMessage: "Account created successfully!")
            }
        }
    }
    
    func removeActivityIndicator( activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func loginLinkTapped(_ sender: Any) {        
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                    print("OK button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}
