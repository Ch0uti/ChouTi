//
//  UIImage+CroppedImageDemo.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-07.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import Foundation

class UIImage_CroppedImageDemoViewController: UIViewController {
    let sourceImage = UIImage(named: "bear1")
    lazy var sourceImageView = UIImageView(image: self.sourceImage)

    let croppedImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        title = "Cropped Image"

        guard let sourceImage = sourceImage else {
            return
        }

        let croppedImage = sourceImage.imageCroppedWithRect(CGRect(
            x: sourceImage.size.width * 0.0,
            y: sourceImage.size.height * 0.25,
            width: sourceImage.size.width * 0.5,
            height: sourceImage.size.height * 0.5)
        )
        croppedImageView.image = croppedImage
        croppedImageView.layer.borderColor = UIColor.gray.cgColor
        croppedImageView.layer.borderWidth = 0.5

        let stackView = UIStackView(arrangedSubviews: [sourceImageView, croppedImageView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.alignment = .center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        sourceImageView.translatesAutoresizingMaskIntoConstraints = false

        stackView.constrainToCenterInSuperview()
    }
}
