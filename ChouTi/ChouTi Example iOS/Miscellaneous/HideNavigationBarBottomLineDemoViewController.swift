//
//  Created by Honghao Zhang on 12/02/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

class HideNavigationBarBottomLineDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.hideBottomHairline()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            // Being poped
            navigationController?.navigationBar.showBottomHairline()
        } else if isMovingToParent {
            // Being pushed
        }
    }
}
