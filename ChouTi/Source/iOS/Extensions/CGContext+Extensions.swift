//
//  Created by Honghao Zhang on 09/03/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

public extension CGContext {
    func flipCoordinatesVertically() {
        self.translateBy(x: 0.0, y: CGFloat(self.height))
        self.scaleBy(x: 1.0, y: -1.0)
    }
}
