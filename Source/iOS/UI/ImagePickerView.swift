//
//  ImagePickerView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-24.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public protocol ImagePickerViewDelegate : class {
	func imagePickerView(imagePickerView: ImagePickerView, pickedImageUpdated image: UIImage)
	func cameraButtonTappedOnImagePickerView(imagePickerView: ImagePickerView)
}

@available(iOS 9.0, *)
public class ImagePickerView: UIView {
	public let backgroundImageView = UIImageView()
	
	private let cameraButtonDescriptionLabelStackView = UIStackView()
	public let cameraButton = UIButton()
	public let descriptionLabel = UILabel()
	
	public var addImageDescription: String = "ADD COVER IMAGE"
	public var editImageDescription: String = "EDIT COVER IMAGE"
	
	public var pickedImage: UIImage? {
		didSet {
			if let pickedImage = pickedImage {
				backgroundImageView.image = pickedImage
				descriptionLabel.text = editImageDescription
			} else {
				backgroundImageView.image = nil
				descriptionLabel.text = addImageDescription
			}
		}
	}
	
	// This related to a tint color bug for AlertViewContrller
	// http://stackoverflow.com/questions/32693369/uialertcontroller-tint-color-defaults-to-blue-on-highlight
	private var _customizedTintColor: UIColor!
	override public var tintColor: UIColor! {
		didSet {
			_customizedTintColor = tintColor
		}
	}
	
	public weak var delegate: ImagePickerViewDelegate?
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		_customizedTintColor = tintColor

		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		backgroundImageView.backgroundColor = UIColor(white: 129.0 / 255.0, alpha: 1.0)
		backgroundImageView.clipsToBounds = true
		backgroundImageView.contentMode = .ScaleAspectFill
		
		cameraButtonDescriptionLabelStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(cameraButtonDescriptionLabelStackView)
		
		cameraButtonDescriptionLabelStackView.alpha = 0.75
		
		cameraButtonDescriptionLabelStackView.axis = .Vertical
		cameraButtonDescriptionLabelStackView.alignment = .Center
		cameraButtonDescriptionLabelStackView.spacing = 13.5 * 2
		
		cameraButtonDescriptionLabelStackView.addArrangedSubview(cameraButton)
		cameraButtonDescriptionLabelStackView.addArrangedSubview(descriptionLabel)
		
		let cameraImage = UIImage(asset: .Camera)
			
		cameraButton.setImage(cameraImage.scaledToMaxWidth(40 * 2, maxHeight: 40 * 2), forState: .Normal)
		cameraButton.addTarget(self, action: "selectPhoto:", forControlEvents: .TouchUpInside)
		
		descriptionLabel.font = UIFont.AvenirMediumFont(12.5 * 2)
		descriptionLabel.textColor = UIColor.whiteColor()
		descriptionLabel.text = addImageDescription
		
		let tapGesture = UITapGestureRecognizer(target: self, action: "selectPhoto:")
		addGestureRecognizer(tapGesture)
		
		setupConstraints()
	}

	private func setupConstraints() {
		backgroundImageView.constrainToFullSizeInSuperview()
		cameraButtonDescriptionLabelStackView.constrainToCenterInSuperview()
	}
}

@available(iOS 9.0, *)
extension ImagePickerView {
	public func selectPhoto(sender: AnyObject) {
		delegate?.cameraButtonTappedOnImagePickerView(self)
		
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		alert.view.tintColor = tintColor
		
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			alert.addAction(UIAlertAction(
				title: "Take Photo",
				style: .Default,
				handler: { (handler) -> Void in
					self.pickImageFromSourceType(.Camera)
			}))
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
			alert.addAction(UIAlertAction(
				title: "Choose From Library",
				style: .Default,
				handler: { (handler) -> Void in
					self.pickImageFromSourceType(.PhotoLibrary)
			}))
		}
		
		alert.addAction(UIAlertAction(
			title: "Cancel",
			style: .Cancel,
			handler: { (handler) -> Void in
		}))
		
		presentingViewController?.presentViewController(alert, animated: true, completion: {
			alert.view.tintColor = self._customizedTintColor
		})
	}
	
	func pickImageFromSourceType(type: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		
		imagePicker.sourceType = type
		if type == .Camera {
			imagePicker.showsCameraControls = true
		}
		
		imagePicker.delegate = self
		imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
		imagePicker.navigationBar.tintColor = tintColor

		presentingViewController?.presentViewController(imagePicker, animated: true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension ImagePickerView : UIImagePickerControllerDelegate {
	
	public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.pickedImage = pickedImage
			delegate?.imagePickerView(self, pickedImageUpdated: pickedImage)
		}
		
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension ImagePickerView : UINavigationControllerDelegate {
	
}
