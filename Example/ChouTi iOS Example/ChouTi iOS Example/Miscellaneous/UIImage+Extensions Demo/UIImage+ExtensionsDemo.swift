//
//  UIImage+ExtensionsDemo.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-08-07.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit
import ChouTi

class UIImageExtensionsDemoViewController: UIViewController {
    let sourceImage = UIImage(named: "walk01")
    lazy var sourceImageView: UIImageView = UIImageView(image: self.sourceImage)
    
    let croppedImageView = UIImageView()
    
    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        
        guard let sourceImage = sourceImage else { return }
        
        let croppedImage = sourceImage.croppedImage(withRect: CGRect(
            x: sourceImage.size.width * 0.3,
            y: sourceImage.size.height * 0.3,
            width: sourceImage.size.width * 0.3,
            height: sourceImage.size.height * 0.5)
        )
        croppedImageView.image = croppedImage
        
        let stackView = UIStackView(arrangedSubviews: [sourceImageView, croppedImageView])
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.spacing = 16
        stackView.alignment = .Center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.constrainToCenterInSuperview()
        stackView.constrainTo(size: CGSize(width: 200, height: 300))
    }
}
