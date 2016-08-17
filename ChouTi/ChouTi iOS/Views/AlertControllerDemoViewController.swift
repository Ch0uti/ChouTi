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
        
        view.backgroundColor = ColorPalette.slackSidebarBackgroundColor
        title = "⚠️ Alert Controller"
        
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.spacing = 100.0
        stackView.alignment = .Center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.constrainToCenterInSuperview()
        
        let systemAlertButton = Button()
        systemAlertButton.setBackgroundImageWithColor(ColorPalette.facebookMediumBlueColor, forState: .Normal)
        systemAlertButton.setCornerRadius(.HalfCircle, forState: .Normal)
        systemAlertButton.setTitle("Present Default Alert", forState: .Normal)
        systemAlertButton.addTarget(self, action: #selector(AlertControllerDemoViewController.presentDefaultAlert(_:)), forControlEvents: .TouchUpInside)
        systemAlertButton.constrainTo(size: CGSize(width: 230, height: 44))
        stackView.addArrangedSubview(systemAlertButton)
        
        let customizedAlertButton = Button()
        customizedAlertButton.setBackgroundImageWithColor(ColorPalette.lightSeaGreenColor, forState: .Normal)
        customizedAlertButton.setCornerRadius(.HalfCircle, forState: .Normal)
        customizedAlertButton.setTitle("Present Customized Alert", forState: .Normal)
        customizedAlertButton.addTarget(self, action: #selector(AlertControllerDemoViewController.presentCustomizedAlert(_:)), forControlEvents: .TouchUpInside)
        customizedAlertButton.constrainTo(size: CGSize(width: 270, height: 44))
        stackView.addArrangedSubview(customizedAlertButton)
    }
    
    func presentDefaultAlert(sender: Button) {
        let alert = UIAlertController(title: "Default Alert Style", message: "This is system's default alert style.", preferredStyle: .Alert)
        
        if rotation <= 0 {
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 1 {
            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .Cancel,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 2 {
            alert.addAction(UIAlertAction(
                title: "Delete",
                style: .Destructive,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 3 {
            alert.addAction(UIAlertAction(
                title: "Extra",
                style: .Default,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if alert.actions.isEmpty {
            delay(2.0, task: {
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
        rotation += 1
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentCustomizedAlert(sender: Button) {
        let alert = AlertController(title: "Customized Alert Style", message: "This is customized alert style.")
        
        delay(1) { 
            alert.message = "This is customized alert style." + " This is customized alert style."
        }
        
        if rotation <= 0 {
            alert.addAction(AlertAction(
                title: "OK",
                style: .Default,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 1 {
            alert.addAction(AlertAction(
                title: "Cancel",
                style: .Cancel,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 2 {
            alert.addAction(AlertAction(
                title: "Delete",
                style: .Destructive,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if rotation <= 3 {
            alert.addAction(AlertAction(
                title: "Extra",
                style: .Default,
                handler: { (handler) -> Void in
                    print("\(handler.title) pressed")
            }))
        }
        
        if alert.actions.isEmpty {
            delay(2.0, task: { 
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
        if Bool.random() {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
            button.setTitle("Customized Button", forState: .Normal)
            button.setTitleColor(ColorPalette.facebookBlueColor, forState: .Normal)
            button.setTitleColor(ColorPalette.facebookBlueColor.darkerColor(), forState: .Highlighted)
            alert.addAction(AlertAction(title: "", button: button, handler: { (handler) -> Void in
                print("\(handler.button.currentTitle) pressed")
            }))
        }
        
        rotation += 1
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
