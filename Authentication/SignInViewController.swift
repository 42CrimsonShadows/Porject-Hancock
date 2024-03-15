//
//  SignInViewController.swift
//  Hancock
//
//  Created by Casey on 5/29/19.
//  Copyright © 2019 Chris Ross. All rights reserved.
//

import UIKit


// User State Vars
public var user = ""
public var pass = ""

class SignInViewController: UIViewController {

    @IBOutlet weak var IDField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    var success = false
    
    @IBAction func ForgotPasswordPopup(_ sender: UIButton) {
        print("forgot password?")
        let alert = UIAlertController(title: "Change Password", message: "To change your password go to 'https://abcgoapp.org/login' and click on 'I've forgotten my username/password.'", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                    print("default")

                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func Login(_ sender: Any) {
        
    print("Logging in...")
        guard let username = IDField.text else { return }
        guard let password = PassField.text else { return }
        
        // api calls run on a background thread, so we use this lambda to get the result from Service and use it in main thread
        // Call login, set success, and call segue on main thread
        
        //This is where the call to sign in is
        Service.login(username:username, password:password) 
        {
            (isSuccess) in self.success = true
            DispatchQueue.main.async{
                self.doSegue(username: username, password:password)
            }
        }
    }
    
    public func TestLogin(){
        Service.login(username:"", password:"")
        {
            (isSuccess) in self.success = true
            DispatchQueue.main.async{
                self.doSegue(username: "", password:"")
            }
        }
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        print("Loading Registration Forms...")
    }
    
    
    override func viewDidLoad() {
        print("HI")
        super.viewDidLoad()
        //lock rotation
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func doSegue(username: String, password: String)
    {
        // check for successful auth, set error label, and login successful and if not already logged in
        if(success)
        {
            ErrorLabel.text = ""

            if(user == "" && pass == "")
            {
                user = username
                pass = password
                print("LOGIN")
                self.performSegue(withIdentifier: "toHomePage", sender: self)
            }
        }
        else
        {
            print("Invalid Username or Password")
            ErrorLabel.text = "Invalid Username or Password"
        }
    }
    
    @IBAction func creditsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "creditsTapped", sender: self)
    }
    
}

