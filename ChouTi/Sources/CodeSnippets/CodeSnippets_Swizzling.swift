//
//  Created by Honghao Zhang on 7/2/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

//import UIKit

// MARK: - ViewController Appearance State Swizzling
//extension UIViewController {
//    // Swizzling beginAppearanceTransition/endAppearanceTransition
//    public override class func initialize() {
//        struct Static {
//            static var beginAppearanceTransitionToken: dispatch_once_t = 0
//            static var endAppearanceTransitionToken: dispatch_once_t = 0
//        }
//        
//        // make sure this isn't a subclass
//        if self !== UIViewController.self {
//            return
//        }
//        
//        dispatch_once(&Static.beginAppearanceTransitionToken) {
//            let originalSelector = #selector(UIViewController.beginAppearanceTransition(_:animated:))
//            let swizzledSelector = #selector(UIViewController.zhh_beginAppearanceTransition(_:animated:))
//            
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//            
//            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            
//            if didAddMethod {
//                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod)
//            }
//        }
//        
//        dispatch_once(&Static.endAppearanceTransitionToken) {
//            let originalSelector = #selector(UIViewController.endAppearanceTransition)
//            let swizzledSelector = #selector(UIViewController.zhh_endAppearanceTransition)
//            
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//            
//            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            
//            if didAddMethod {
//                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod)
//            }
//        }
//    }
//    
//    func zhh_beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
//        // Do extra ...
//        // Call original implementation
//        self.zhh_beginAppearanceTransition(isAppearing, animated: animated)
//    }
//    
//    func zhh_endAppearanceTransition() {
//        // Do extra ...
//        // Call original implementation
//        self.zhh_endAppearanceTransition()
//    }
//}
