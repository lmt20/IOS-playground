//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Trường Lê Mạnh on 09/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        
        guard let randomImage = accessRandomImage() else {
            return
        }
        
        let imageView = UIImageView(image: randomImage)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        imageView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinchGesture.delegate = self
        imageView.addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotateGesture.delegate = self
        imageView.addGestureRecognizer(rotateGesture)
//
        imageView.isUserInteractionEnabled = true
        
        mainView.addSubview(imageView)
        
    }
    
    
    func accessRandomImage() -> UIImage? {
        let imageFileNames = ["1.1", "2.1", "3.1", "4.1", "5.1"]
        let randomImage = UIImage(named: imageFileNames.randomElement()!)
        return randomImage
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
            return
        }
        
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
        
        let sliceFactor = 0.01 * slideMultiplier
        
        var finalPoint = CGPoint(
            x: gestureView.center.x + (sliceFactor * velocity.x),
            y: gestureView.center.y + (sliceFactor * velocity.y)
        )
        
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)
        
        UIView.animate(withDuration: Double(sliceFactor*2), delay: 0, options: .curveEaseOut, animations: {
            gestureView.center = finalPoint
        })
        
    }
    
    @IBAction func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )
        
        gesture.scale = 1
    }
    
    @IBAction func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(
            by: gesture.rotation
        )
        
        gesture.rotation = 0
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    
    
}

