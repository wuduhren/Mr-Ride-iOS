//
//  LoginViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
}


// MARK: - Facebook

extension LoginViewController {
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        MrRideUserManager.sharedManager.logInWithFacebook(
            fromViewController: self,
            success: {
                
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RootViewNavigationController") as! UINavigationController
                self.presentViewController(initialViewController, animated: true, completion: nil)
            },
            failure: { [weak self] error in
                
                guard let weakSelf = self else { return }
                
                let alert = UIAlertController(
                    title: NSLocalizedString("Error", comment: ""),
                    message: "\(error)",
                    preferredStyle: .Alert
                )
                
                let ok = UIAlertAction(
                    title: NSLocalizedString("OK", comment: ""),
                    style: .Cancel,
                    handler: nil
                )
                
                alert.addAction(ok)
                
                weakSelf.presentViewController(alert, animated: true, completion: nil)
                
            }
        )

    }
}



// MARK: - setRootViewController

extension LoginViewController {
    
    func setRootViewController() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RootViewNavigationController") as! UINavigationController
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }

    }
}


// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func setupTextField(){
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        heightTextField.keyboardType = .NumbersAndPunctuation
        weightTextField.keyboardType = .NumbersAndPunctuation
        
        heightTextField.text = "Enter Your Height"
        weightTextField.text = "Enter Your Weight"
        
        heightTextField.textColor = .grayColor()
        weightTextField.textColor = .grayColor()
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        
        heightTextField.textColor = .blackColor()
        weightTextField.textColor = .blackColor()
        
        if textField === weightTextField {
            weightTextField.text = ""
        }
        else if textField === heightTextField {
            heightTextField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let defaultName = NSUserDefaults.standardUserDefaults()
        
        if textField === weightTextField {
            guard let weight = Double(weightTextField.text!) else {
                weightTextField.text = ""
                textInputErrorAlert()
                return
            }
            defaultName.setValue(weight, forKey: "weight")
        }
        else if textField === heightTextField {
            guard let height = Double(heightTextField.text!) else {
                heightTextField.text = ""
                textInputErrorAlert()
                return
            }
            defaultName.setValue(height, forKey: "height")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textInputErrorAlert() {
        
        let alert = UIAlertController(
            title: NSLocalizedString("Invalid Input", comment: ""),
            message: "please enter again",
            preferredStyle: .Alert
        )
        
        let ok = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .Cancel,
            handler: nil
        )
        
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
}



// MARK: - Main LifeCycle

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRootViewController()
        setupTextField()
    }
}





