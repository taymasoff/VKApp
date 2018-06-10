//
//  StartingViewController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 19.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift

class StartingViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var authorizeButton: UIButton!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeButtonFadeInAnimation()
    }
    
    // TODO: - Logout
    
    @IBAction func unwindToWebLoginScreen(segue: UIStoryboardSegue) {
        
        //        VKApiAuthorization.logout()
        //        webView.reload()
        
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    private func authorizeButtonFadeInAnimation() {
        self.authorizeButton.isHidden = true
        delay(0) {
            UIView.transition(with: self.welcomeLabel, duration: 1.0, options: [.transitionCrossDissolve], animations: {
                self.welcomeLabel.text = "Welcome"
            }, completion:  { finished in
                
                self.delay(0.5) {
                    UIView.transition(with: self.welcomeLabel, duration: 1.0, options: [.transitionCrossDissolve], animations: {
                        self.welcomeLabel.text = "VK App"
                    }, completion:  { finished in
                        self.authorizeButton.isHidden = false
                    })
                }
                
            })
        }
    }
    
}
