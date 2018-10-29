//
//  AlertControllerDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-05-05.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

@available(iOS 9.0, *)
class AlertControllerDemoViewController : UIViewController {
    
    var rotation: Int = 0 {
        didSet {
            rotation %= 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "⚠️ Alert Controller"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 100.0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.constrainToCenterInSuperview()
        
        let systemAlertButton = Button()
        systemAlertButton.clipsToBounds = true

        systemAlertButton.setBackgroundImageWithColor(ColorPalette.facebookMediumBlueColor, forState: .normal)
        systemAlertButton.setCornerRadius(.halfCircle, forState: .normal)
        systemAlertButton.setTitle("Present Default Alert", for: .normal)
        systemAlertButton.addTarget(self, action: #selector(AlertControllerDemoViewController.presentDefaultAlert(_:)), for: .touchUpInside)
        systemAlertButton.constrainTo(size: CGSize(width: 230, height: 44))
        stackView.addArrangedSubview(systemAlertButton)
        
        let customizedAlertButton = Button()
        customizedAlertButton.clipsToBounds = false
        
        // setup title
        customizedAlertButton.setTitle("Present Customized Alert", for: .normal)
        customizedAlertButton.setTitleColor(.white, for: .normal)
        customizedAlertButton.setTitleColor(UIColor(white: 1.0, alpha: 0.7), for: .highlighted)
        
        // setup color/cornerRadius
        customizedAlertButton.backgroundColor = ColorPalette.lightSeaGreenColor
        customizedAlertButton.layer.cornerRadius = 44 / 2
        
        // setup shadow
        customizedAlertButton.setShadowColor(ColorPalette.lightSeaGreenColor, for: .normal)
        customizedAlertButton.setShadowOpacity(0.5, for: .normal)
        customizedAlertButton.setShadowOffset(CGSize(width: 0, height: 7), for: .normal)
        customizedAlertButton.setShadowRadius(9, for: .normal)
        
        customizedAlertButton.setShadowColor(ColorPalette.lightSeaGreenColor, for: .highlighted)
        customizedAlertButton.setShadowOpacity(0.7, for: .highlighted)
        customizedAlertButton.setShadowOffset(CGSize(width: 0, height: 2), for: .highlighted)
        customizedAlertButton.setShadowRadius(3, for: .highlighted)
        
        customizedAlertButton.addTarget(self, action: #selector(AlertControllerDemoViewController.presentCustomizedAlert(_:)), for: .touchUpInside)
        customizedAlertButton.constrainTo(size: CGSize(width: 270, height: 44))
        stackView.addArrangedSubview(customizedAlertButton)
    }
    
    @objc func presentDefaultAlert(_ sender: Button) {
        let alert = UIAlertController(title: "Default Alert Style", message: "This is system's default alert style.", preferredStyle: .alert)
        
        if rotation <= 0 {
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 1 {
            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 2 {
            alert.addAction(UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 3 {
            alert.addAction(UIAlertAction(
                title: "Extra",
                style: .default,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if alert.actions.isEmpty {
            delay(2.0, task: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
        
        rotation += 1
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func presentCustomizedAlert(_ sender: Button) {
        let alert = AlertController(title: "Customized Alert Style", message: "This is customized alert style.")
        
        delay(1) { 
            alert.message = "This is customized alert style." + " This is customized alert style."
        }
        
        if rotation <= 0 {
            alert.addAction(AlertAction(
                title: "OK",
                style: .default,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 1 {
            alert.addAction(AlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 2 {
            alert.addAction(AlertAction(
                title: "Delete",
                style: .destructive,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if rotation <= 3 {
            alert.addAction(AlertAction(
                title: "Extra",
                style: .default,
                handler: { (handler) -> Void in
                    print("\(handler.title ??? "Unknown") pressed")
            }))
        }
        
        if alert.actions.isEmpty {
            delay(2.0, task: { 
                alert.dismiss(animated: true, completion: nil)
            })
        }
        
        if Bool.random() {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitle("Customized Button", for: .normal)
            button.setTitleColor(ColorPalette.facebookBlueColor, for: .normal)
            button.setTitleColor(ColorPalette.facebookBlueColor.darkerColor(), for: .highlighted)
            alert.addAction(AlertAction(title: "", button: button, handler: { (handler) -> Void in
                print("\(handler.button.currentTitle ??? "Unknown") pressed")
            }))
        }
        
        rotation += 1
        self.present(alert, animated: true, completion: nil)
    }
}
