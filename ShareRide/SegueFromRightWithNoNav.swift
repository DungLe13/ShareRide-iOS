//
//  SegueFromRightWithNoNav.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/24/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  TRANSITION ANIMATION (used when Seque from Right without Navigation Controller)

import UIKit

class SegueFromRightWithNoNav: UIStoryboardSegue {
    override func perform() {
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        src.view.layer.add(transition, forKey: kCATransition)
        src.present(dst, animated: true, completion: nil)
    }
}
