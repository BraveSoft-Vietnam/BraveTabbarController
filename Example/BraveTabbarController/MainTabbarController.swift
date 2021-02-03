//
//  MainTabbarController.swift
//  BSTabbarController_Example
//
//  Created by Hien Pham on 5/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BraveTabbarController

class MainTabbarController: BraveTabbarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var viewControllers : Array<UIViewController> = Array();
        for i in 0..<3 {
            var vc : UIViewController
            switch (i) {
            case 0:
                let ranking = RankingViewController(nibName: String(describing: RankingViewController.self), bundle:nil)
                vc = UINavigationController(rootViewController: ranking)
                break
            case 1:
                vc = MyPageViewController(nibName: String(describing: MyPageViewController.self), bundle:nil)
                break
            case 2:
                vc = PostViewController(nibName: String(describing: PostViewController.self), bundle:nil)
                break;
            default:
                vc = UIViewController();
                vc.view.backgroundColor = UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: 1);
                vc.title = String(format: "Tab %d",  i + 1)
                break;
            }
            viewControllers.append(vc)
        }
        self.viewControllers = viewControllers
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
