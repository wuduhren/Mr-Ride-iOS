//
//  LoginViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Amplitude_iOS

class LoginViewController: UIViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextFieldBackground: UIView!
    @IBOutlet weak var weightTextFieldBackground: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    deinit {
        //print("LoginViewController deinit at \(self)")
    }

}



// MARK: - Setup

extension LoginViewController {
    
    private func setup() {
        inputViewSetup()
        setupLoginButton()
        setupBackground()
    }
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.MRLightblueColor().CGColor, UIColor.MRPineGreen50Color().CGColor]
        gradientLayer.locations = [0.5, 1]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1)
    }

    private func inputViewSetup() {
        //TextFieldBackground
        let topRightBottomRightRoundedLayerForHeightTextFieldBackground = CAShapeLayer()
        let topRightBottomRightRoundedLayerForWeightTextFieldBackground = CAShapeLayer()
        let topRightBottomRightRoundedPath = UIBezierPath(
            roundedRect: heightTextFieldBackground.bounds,
            byRoundingCorners: [ .TopRight, .BottomRight ],
            cornerRadii: CGSize(width: 4.0, height: 4.0)
        )
        topRightBottomRightRoundedLayerForHeightTextFieldBackground.path = topRightBottomRightRoundedPath.CGPath
        topRightBottomRightRoundedLayerForWeightTextFieldBackground.path = topRightBottomRightRoundedPath.CGPath
        heightTextFieldBackground.layer.mask = topRightBottomRightRoundedLayerForHeightTextFieldBackground
        weightTextFieldBackground.layer.mask = topRightBottomRightRoundedLayerForWeightTextFieldBackground
        
        
        //HeightandWeightLabel
        let topLeftBottomLeftRoundedLayerForHeightLabel = CAShapeLayer()
        let topLeftBottomLeftRoundedLayerForWeightLabel = CAShapeLayer()
        let topLeftBottomLeftRoundedPath = UIBezierPath(
            roundedRect: heightLabel.bounds,
            byRoundingCorners: [ .TopLeft, .BottomLeft ],
            cornerRadii: CGSize(width: 4.0, height: 4.0)
        )
        topLeftBottomLeftRoundedLayerForHeightLabel.path = topLeftBottomLeftRoundedPath.CGPath
        topLeftBottomLeftRoundedLayerForWeightLabel.path = topLeftBottomLeftRoundedPath.CGPath
        heightLabel.layer.mask = topLeftBottomLeftRoundedLayerForHeightLabel
        weightLabel.layer.mask = topLeftBottomLeftRoundedLayerForWeightLabel
    }
    
    private func setupLoginButton() {
        loginButton.layer.cornerRadius = 30
        loginButton.clipsToBounds = true
    }
}


// MARK: - Facebook

extension LoginViewController {
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        
        Amplitude.instance().logEvent("select_log_in_facebook_in_loginView")
        
        if !weightAndHeightDidSet() {
            return
        }
        
        MrRideUserManager.sharedManager.logInWithFacebook(
            fromViewController: self,
            success: {
                
                RootViewManager.sharedManager.changeRootViewController(
                    viewController: RootViewController.controller(),
                    animated: false,
                    success: nil,
                    failure: nil
                )
            },
            failure: { [weak self] error in
                
                guard let weakSelf = self else { return }
                weakSelf.ErrorAlert("Error",errorMessage: "\(error)")
                //double check please
            }
        )

    }
}



// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    private func setupTextField(){
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        heightTextField.keyboardType = .NumbersAndPunctuation
        weightTextField.keyboardType = .NumbersAndPunctuation
        
        heightTextField.textColor = .grayColor()
        weightTextField.textColor = .grayColor()
        
        heightTextField.text = "Enter Your Height"
        weightTextField.text = "Enter Your Weight"
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        
        heightTextField.textColor = .MRDarkSlateBlueColor()
        weightTextField.textColor = .MRDarkSlateBlueColor()
        
        if textField === weightTextField {
            weightTextField.text = ""
            
            Amplitude.instance().logEvent("select_weight_text_field_in_loginView")
        }
        else if textField === heightTextField {
            heightTextField.text = ""
            
            Amplitude.instance().logEvent("select_height_text_field_in_loginView")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let defaultName = NSUserDefaults.standardUserDefaults()
        
        if textField === weightTextField {
            guard let weight = Double(weightTextField.text!) else {
                weightTextField.text = ""
                ErrorAlert("Invalid Input", errorMessage: "please enter again")
                return
            }
            defaultName.setValue(weight, forKey: "weight")
        }
        else if textField === heightTextField {
            guard let height = Double(heightTextField.text!) else {
                heightTextField.text = ""
                ErrorAlert("Invalid Input", errorMessage: "please enter again")
                return
            }
            defaultName.setValue(height, forKey: "height")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private func weightAndHeightDidSet() -> Bool {
        if weightTextField.text == "" || heightTextField.text == "" {
            ErrorAlert("Unable to Login", errorMessage: "please enter your height and weight")
            return false
            
        } else if weightTextField.text == "Enter Your Height" || heightTextField.text == "Enter Your Height" {
            ErrorAlert("Unable to Login", errorMessage: "please enter your height and weight")
            return false
            
        } else { return true }
    }
    
    private func ErrorAlert(errorTitle: String, errorMessage: String) {
        
        let alert = UIAlertController(
            title: NSLocalizedString(errorTitle, comment: ""),
            message: errorMessage,
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
        setup()
        setupTextField()
        
        Amplitude.instance().logEvent("view_in_loginView")
    }
    
    private func setRootViewController() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            
            RootViewManager.sharedManager.changeRootViewController(
                viewController: RootViewController.controller(),
                animated: false,
                success: nil,
                failure: nil
            )
        }
        
    }
}



// MARK: -  Initializer

extension LoginViewController {
    
    class func controller() -> LoginViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
    }
}





