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
	func imagePickerView(_ imagePickerView: ImagePickerView, pickedImageUpdated image: UIImage)
	func cameraButtonTappedOnImagePickerView(_ imagePickerView: ImagePickerView)
}

@available(iOS 9.0, *)
open class ImagePickerView: UIView {
	open let backgroundImageView = UIImageView()
	
	fileprivate let cameraButtonDescriptionLabelStackView = UIStackView()
	open let cameraButton = UIButton()
	open let descriptionLabel = UILabel()
	
	open var addImageDescription: String = "ADD COVER IMAGE"
	open var editImageDescription: String = "EDIT COVER IMAGE"
	
	open var pickedImage: UIImage? {
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
	fileprivate var _customizedTintColor: UIColor!
	override open var tintColor: UIColor! {
		didSet {
			_customizedTintColor = tintColor
		}
	}
	
	open weak var delegate: ImagePickerViewDelegate?
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	fileprivate func commonInit() {
		_customizedTintColor = tintColor

		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		backgroundImageView.backgroundColor = UIColor(white: 129.0 / 255.0, alpha: 1.0)
		backgroundImageView.clipsToBounds = true
		backgroundImageView.contentMode = .scaleAspectFill
		
		cameraButtonDescriptionLabelStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(cameraButtonDescriptionLabelStackView)
		
		cameraButtonDescriptionLabelStackView.alpha = 0.75
		
		cameraButtonDescriptionLabelStackView.axis = .vertical
		cameraButtonDescriptionLabelStackView.alignment = .center
		cameraButtonDescriptionLabelStackView.spacing = 13.5 * 2
		
		cameraButtonDescriptionLabelStackView.addArrangedSubview(cameraButton)
		cameraButtonDescriptionLabelStackView.addArrangedSubview(descriptionLabel)
		
		let cameraImage = UIImage(asset: .Camera)
			
		cameraButton.setImage(cameraImage?.scaledToMaxWidth(40 * 2, maxHeight: 40 * 2), for: .normal)
        cameraButton.addTarget(self, action: #selector(ImagePickerView.selectPhoto(_:)), for: .touchUpInside)
		
		descriptionLabel.font = UIFont.AvenirMediumFont(12.5 * 2)
		descriptionLabel.textColor = UIColor.white
		descriptionLabel.text = addImageDescription
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePickerView.selectPhoto(_:)))
		addGestureRecognizer(tapGesture)
		
		setupConstraints()
	}

	fileprivate func setupConstraints() {
		backgroundImageView.constrainToFullSizeInSuperview()
		cameraButtonDescriptionLabelStackView.constrainToCenterInSuperview()
	}
}

@available(iOS 9.0, *)
extension ImagePickerView {
	public func selectPhoto(_ sender: AnyObject) {
		delegate?.cameraButtonTappedOnImagePickerView(self)
		
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.view.tintColor = tintColor
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			alert.addAction(UIAlertAction(
				title: "Take Photo",
				style: .default,
				handler: { (handler) -> Void in
					self.pickImageFromSourceType(.camera)
			}))
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			alert.addAction(UIAlertAction(
				title: "Choose From Library",
				style: .default,
				handler: { (handler) -> Void in
					self.pickImageFromSourceType(.photoLibrary)
			}))
		}
		
		alert.addAction(UIAlertAction(
			title: "Cancel",
			style: .cancel,
			handler: { (handler) -> Void in
		}))
		
		presentingViewController?.present(alert, animated: true, completion: {
			alert.view.tintColor = self._customizedTintColor
		})
	}
	
	func pickImageFromSourceType(_ type: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		
		imagePicker.sourceType = type
		if type == .camera {
			imagePicker.showsCameraControls = true
		}
		
		imagePicker.delegate = self
		imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
		imagePicker.navigationBar.tintColor = tintColor

		presentingViewController?.present(imagePicker, animated: true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension ImagePickerView : UIImagePickerControllerDelegate {
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.pickedImage = pickedImage
			delegate?.imagePickerView(self, pickedImageUpdated: pickedImage)
		}
		
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
}

@available(iOS 9.0, *)
extension ImagePickerView : UINavigationControllerDelegate {
	
}
