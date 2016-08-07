//
//  UIImage+CroppedImageDemo.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-08-07.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

class UIImage_CroppedImageDemoViewController: UIViewController {
    let sourceImage = UIImage(named: "bear1")
    lazy var sourceImageView: UIImageView = UIImageView(image: self.sourceImage)
    
    let croppedImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        guard let sourceImage = sourceImage else { return }
        
        let croppedImage = sourceImage.croppedImage(withRect: CGRect(
            x: sourceImage.size.width * 0.25,
            y: sourceImage.size.height * 0.25,
            width: sourceImage.size.width * 0.5,
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
        
        sourceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.constrainToCenterInSuperview()
    }
}
