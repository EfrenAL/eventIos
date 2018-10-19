//
//  LoginViewController.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 21/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var networkManager: UserManager! = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        if(emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            displayMessage(userMessage: "All fields are required!")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        
        let body = ["email" : emailTextField.text!,
                    "password" : passwordTextField.text!] as [String:String]
        
        networkManager.login(body: body) { (user, error) in
            
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if let error = error {
                print(error)
            }
            if let user = user {
                print(user)
                self.displayMessage(userMessage: "Login was successful!")
            }
        }
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        
        self.present(registerViewController, animated: true)
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                print("OK button tapped")
                let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                mainTabViewController.selectedViewController = mainTabViewController.viewControllers?[1]
                
                self.present(mainTabViewController, animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeActivityIndicator( activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    

}
