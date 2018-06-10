//
//  MapKitView.swift
//  VKApp
//
//  Created by Тимур Таймасов on 13.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import MapKit
import CoreLocation

protocol PinLocationDelegate {
    func pinLocation(place: String)
}

class MapKitView: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    
    var delegate: PinLocationDelegate?
    var lastPinLocation: CLLocationCoordinate2D?
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.showAnimate()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapKitView.addPinOnLongTap))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
        
    }
    
    // MARK: - Private Methods
    
    // MARK: Animations
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
        }, completion:{ (finished : Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        });
    }
    
    // MARK: Geocoding
    private func getLocationFromCoordinates(_ coordinates: CLLocationCoordinate2D, completionHandler: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: (lastPinLocation?.latitude)!, longitude: (lastPinLocation?.longitude)!)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error == nil {
                let place = placemarks?[0].compactAddress!
                completionHandler(place)
            } else {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                completionHandler(nil)
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func cancelMap(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        guard lastPinLocation != nil else {
            self.removeAnimate()
            return
        }
        
        if delegate != nil {
            getLocationFromCoordinates(lastPinLocation!){ [weak self] place in
                self?.delegate?.pinLocation(place: place!)
            }
        }
        
        self.removeAnimate()
    }
    
    // MARK: Gesture Recognizer
    @IBAction func addPinOnLongTap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchPoint = sender.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
        lastPinLocation = newCoordinates
    }
    
}
