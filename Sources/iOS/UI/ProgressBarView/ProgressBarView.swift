// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public protocol ProgressBarViewDelegate: AnyObject {
    func progressBarView(_ progressBarView: ProgressBarView, willSetToPercent percent: CGFloat)
    func progressBarView(_ progressBarView: ProgressBarView, didSetToPercent percent: CGFloat)
}

open class ProgressBarView: UIView {
    open var forgroundColor = UIColor(white: 0.2, alpha: 1.0) {
        didSet {
            forgroundMeterLayer.backgroundColor = forgroundColor.cgColor
        }
    }

    private let forgroundMeterLayer = CAShapeLayer()

    open var animationDuration: TimeInterval = 1.0
    open var animated: Bool = true
    open var rounded: Bool = true

    open weak var delegate: ProgressBarViewDelegate?

    open var percent: CGFloat = 0.0 {
        didSet {
            precondition(percent >= 0.0 && percent <= 1.0, "Percetn must in range 0.0 to 1.0, inclusive.")
            setNeedsLayout()
            delegate?.progressBarView(self, didSetToPercent: percent)
        }
    }

    open func setPercent(_ percent: CGFloat, animated: Bool = false) {
        self.animated = animated
        self.percent = percent
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        clipsToBounds = true
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        forgroundMeterLayer.backgroundColor = forgroundColor.cgColor

        layer.addSublayer(forgroundMeterLayer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        if animated {
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            CATransaction.setAnimationDuration(animationDuration)
        } else {
            CATransaction.setDisableActions(true)
        }

        forgroundMeterLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width * percent, height: bounds.height)
        CATransaction.commit()

        if rounded {
            layer.cornerRadius = bounds.height / 2.0
            forgroundMeterLayer.cornerRadius = bounds.height / 2.0
        } else {
            layer.cornerRadius = 0
            forgroundMeterLayer.cornerRadius = 0
        }
    }
}
