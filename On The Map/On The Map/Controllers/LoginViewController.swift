//
//  ViewController.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.setMainStyle()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        activityIndicator.isHidden = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
   
    @IBAction func signUpTapped(_ sender: Any) {
        
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        whileLogingIn(true)
        
        OTMClient.userLogin(email: emailTextField.text!, password: passwordTextField.text!, completion: userLoggingInHandler(complete:error:))
        
    }
    
    func userLoggingInHandler(complete: Bool, error: Error?){
        
        whileLogingIn(false)
        
        if complete {
            
            let viewController = storyboard!.instantiateViewController(withIdentifier: "mainContentVC")
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        
        } else {
            DispatchQueue.main.async {
                self.showAlert()
            }
            
        }
        
    }
    
    func whileLogingIn(_ logginIn: Bool){
        
        if logginIn {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.loginButton.isEnabled = false
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.loginButton.isEnabled = true
            }
            
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !logginIn
            self.emailTextField.isEnabled = !logginIn
            self.passwordTextField.isEnabled = !logginIn
            self.loginButton.isEnabled = !logginIn
        }
        
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Account not found or invalid credentials", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

