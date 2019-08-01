//
//  MainTabbarViewController.swift
//  StarsCommunityNews
//
//  Created by Yamada, Masaya on 8/1/19.
//  Copyright © 2019 Yamada, Masaya. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class MainTabbarViewController: SwipeableTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
        //isCyclingEnabled = true
    }

}
