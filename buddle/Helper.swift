//
//  Helper.swift
//  buddle
//
//  Created by Vu Quang Huy on 15/11/2021.
//

import Foundation
import UIKit
import FirebaseAuth

class Helper {
    static let helper = Helper()
    
    // switch to success view
    func switchToHomePageViewController() {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main storyboard, instantiate success view
        let homePageVC = storyboard.instantiateViewController(identifier: "HomeVC") as? ProfileVC
        
        // get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set the success view controller as root view controller
        appDelegate.window?.rootViewController = homePageVC
    }
    
    // switch to login scene
    func switchToLoginViewController() {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main storyboard, instantiate success view
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")
        
        // get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set the success view controller as root view controller
        appDelegate.window?.rootViewController = logInVC
    }
    
    // log out function
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        
        // switch to loginViewController
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main storyboard, instantiate success view
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")
        
        // get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set the success view controller as root view controller
        appDelegate.window?.rootViewController = logInVC
        
    }
    
}

