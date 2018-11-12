//
//  ButtonsDemoViewController.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2017-06-05.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import UIKit

class ButtonsDemoViewController: UIViewController {

    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        title = "Button Demo"
    }

    // MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}

	private func setupViews() {
        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 80.0
        stackView.alignment = .center

        stackView.constrainToCenterInSuperview()

        // Adjusted background image
        let flatButton1 = Button()
        flatButton1.adjustsImageWhenHighlighted = true
        flatButton1.setBackgroundImageWithColor(ColorPalette.turquoiseGreen, forState: .normal)
        flatButton1.clipsToBounds = true
        flatButton1.setCornerRadius(.halfCircle, forState: .normal)
        flatButton1.setTitle("Turquoise", for: .normal)
        flatButton1.constrainTo(size: CGSize(width: 240, height: 44))
        stackView.addArrangedSubview(flatButton1)

        // Different color
        let flatButton2 = Button()
        flatButton2.adjustsImageWhenHighlighted = false
        flatButton2.setBackgroundImageWithColor(ColorPalette.belizeHoleBlue, forState: .normal)
        flatButton2.setBackgroundImageWithColor(ColorPalette.nephritisGreen, forState: .highlighted)
        flatButton2.clipsToBounds = true
        flatButton2.setCornerRadius(.halfCircle, forState: .normal)
        flatButton2.setCornerRadius(.relative(percent: 0.25, attribute: .height), forState: .highlighted)
        flatButton2.setTitle("Belize Hole", for: .normal)
        flatButton2.setTitle("Nephritis", for: .highlighted)
        flatButton2.constrainTo(size: CGSize(width: 240, height: 44))
        stackView.addArrangedSubview(flatButton2)

        // Glowing Button
        let blurButton1 = Button()
        blurButton1.clipsToBounds = false

        // Setup title
        blurButton1.setTitle("Red Blur", for: .normal)
        blurButton1.setTitleColor(ColorPalette.cloudsWhite, for: .normal)
        blurButton1.setTitleColor(ColorPalette.cloudsWhite.withAlphaComponent(0.7), for: .highlighted)

        // Setup color
        blurButton1.setBackgroundColor(ColorPalette.pomegranateRed, forState: .normal)
        blurButton1.setBackgroundColor(ColorPalette.pomegranateRed.darkerColor(brightnessDecreaseFactor: 0.9), forState: .highlighted)

        // Setup corner radius
        blurButton1.setCornerRadius(.halfCircle, forState: .normal)

        // Setup transform
        blurButton1.setTransform(.identity, forState: .normal)
        blurButton1.setTransform(CGAffineTransform(scaleX: 0.99, y: 0.99), forState: .highlighted)

        // Setup shadow
        blurButton1.setShadowColor(ColorPalette.pomegranateRed, for: .normal)
        blurButton1.setShadowOpacity(0.5, for: .normal)
        blurButton1.setShadowOffset(CGSize(width: 0, height: 7), for: .normal)
        blurButton1.setShadowRadius(9, for: .normal)

        blurButton1.setShadowColor(ColorPalette.pomegranateRed, for: .highlighted)
        blurButton1.setShadowOpacity(0.7, for: .highlighted)
        blurButton1.setShadowOffset(CGSize(width: 0, height: 2), for: .highlighted)
        blurButton1.setShadowRadius(3, for: .highlighted)

        blurButton1.constrainTo(size: CGSize(width: 240, height: 44))
        stackView.addArrangedSubview(blurButton1)
	}
}
