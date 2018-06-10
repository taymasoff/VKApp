//
//  NewPostPopUpVC.swift
//  VKApp
//
//  Created by Тимур Таймасов on 13.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import CoreLocation

protocol IsAllowedToScrollDelegate {
    func isAllowedToScroll(_ bool: Bool)
}

class NewPostPopUpVC: UIViewController, PinLocationDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textLabel: UITextView!
    
    // MARK: - Variables
    
    var delegate: IsAllowedToScrollDelegate?
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLabel.text = ""
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.showAnimate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if delegate != nil {
            self.delegate?.isAllowedToScroll(false)
        }
    }
    
    // MARK: - PinLocation Delegate
    
    func pinLocation(place: String) {
        textLabel.text.append("\n\n\t📌 \(place)")
    }
    
    // MARK: - Private Methods, Animations
    
    private func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    private func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{ (finished : Bool)  in
            if finished {
                self.view.removeFromSuperview()
            }
        });
    }
    
    // MARK: - Action Buttons
    
    @IBAction func addLocation(_ sender: Any) {
        let newPostMapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newPostMapVC") as! MapKitView
        self.addChildViewController(newPostMapVC)
        self.view.addSubview(newPostMapVC.view)
        newPostMapVC.didMove(toParentViewController: self)
        
        newPostMapVC.delegate = self
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        if delegate != nil {
            self.delegate?.isAllowedToScroll(true)
        }
        
        self.removeAnimate()
    }
    
    @IBAction func createPost(_ sender: Any) {
        let text = textLabel.text
        NewsService.newPost(text: text!)
        
        if delegate != nil {
            self.delegate?.isAllowedToScroll(true)
        }
        
        self.removeAnimate()
    }
    
}
