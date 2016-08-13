//
//  UIImage+AnimatedImagesDemo.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-08-07.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

class UIImage_AnimatingImagesDemoViewController: UIViewController {
    
    let bearImageView = UIImageView()
    var bearFrames: [UIImage] = []
    
    let croppedBearImageView = UIImageView()
    var croppedBearFrames: [UIImage] = []
    
    let fpsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        title = "Animating Images"
        
        let stackView = UIStackView(arrangedSubviews: [bearImageView, croppedBearImageView])
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.spacing = 16
        stackView.alignment = .Center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.constrainToCenterInSuperview()
        
        for i in 1...8 {
            if let frame = UIImage(named: "bear\(i)") {
                bearFrames.append(frame)
            }
        }
        
        bearImageView.animationImages = bearFrames
        bearImageView.animationFPS = 12
        bearImageView.animationRepeatCount = 0
        
        bearImageView.startAnimating()
        
        bearImageView.contentMode = .ScaleAspectFit
        bearImageView.translatesAutoresizingMaskIntoConstraints = false
        bearImageView.constrainTo(width: screenWidth, height: screenHeight / 3.0)
        
        // Croppped
        croppedBearFrames = bearFrames.flatMap {
            return $0.croppedImage(withRect: CGRect(
                x: $0.size.width * 0.0,
                y: $0.size.height * 0.25,
                width: $0.size.width * 0.3,
                height: $0.size.height * 0.5)
            )
        }
        
        croppedBearImageView.animationImages = croppedBearFrames
        croppedBearImageView.animationDuration = bearImageView.animationDuration
        croppedBearImageView.animationRepeatCount = bearImageView.animationRepeatCount
        
        croppedBearImageView.startAnimating()
        
        croppedBearImageView.layer.borderColor = UIColor.grayColor().CGColor
        croppedBearImageView.layer.borderWidth = 0.5
        
        croppedBearImageView.contentMode = .ScaleAspectFit
        
        // Slider
        let bottomTabBar = UITabBar()
        bottomTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomTabBar)
        bottomTabBar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).activate()
        bottomTabBar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).activate()
        bottomTabBar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).activate()
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        bottomTabBar.addSubview(slider)
        slider.constrainToCenterInSuperview()
        slider.leadingAnchor.constraintEqualToAnchor(bottomTabBar.leadingAnchor, constant: 16).activate()
        slider.trailingAnchor.constraintEqualToAnchor(bottomTabBar.trailingAnchor, constant: -16).activate()
        
        slider.maximumValue = 60
        slider.minimumValue = 1
        
        slider.value = Float(bearImageView.animationFPS)
        
        slider.addTarget(self, action: #selector(UIImage_AnimatingImagesDemoViewController.slide(_:)), forControlEvents: .ValueChanged)
        
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fpsLabel)
        fpsLabel.constrainToCenterHorizontallyInSuperview()
        fpsLabel.constrain(.Top, equalTo: .Bottom, ofView: croppedBearImageView, constant: 16)
        fpsLabel.text = String(format: "FPS: %.1f", slider.value)
    }
    
    func slide(sender: AnyObject?) {
        if let slider = sender as? UISlider {
            fpsLabel.text = String(format: "FPS: %.1f", slider.value)
            
            bearImageView.animationFPS = CGFloat(slider.value)
            bearImageView.startAnimating()
            
            croppedBearImageView.animationFPS = bearImageView.animationFPS
            croppedBearImageView.startAnimating()
        }
    }
}
