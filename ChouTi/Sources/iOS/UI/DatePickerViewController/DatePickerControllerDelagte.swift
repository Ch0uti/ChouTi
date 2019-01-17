//
//  Created by Honghao Zhang on 12/12/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

@objc public protocol DatePickerControllerDelagte: AnyObject {
	@objc
    optional func datePickerController(_ datePickerController: DatePickerController, datePicker: UIDatePicker, didScrollToDate date: Date)

	@objc
    optional func datePickerController(_ datePickerController: DatePickerController, willDoneWithDate date: Date)

	@objc
    optional func datePickerController(_ datePickerController: DatePickerController, didDoneWithDate date: Date)

	@objc
    optional func datePickerController(_ datePickerController: DatePickerController, willCancelWithDate date: Date)

	@objc
    optional func datePickerController(_ datePickerController: DatePickerController, didCancelWithDate date: Date)
}
