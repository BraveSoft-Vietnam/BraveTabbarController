//
//  BraveTabbarController.swift
//  BraveTabbarController
//
//  Created by Hien Pham on 05/08/2019.
//  Copyright (c) 2019 Hien Pham. All rights reserved.
//

import UIKit
@objc public protocol BraveTabbarControllerDelegate: NSObjectProtocol {
    /**
     Asks the delegate whether the specified index should be selected.
     */
    @objc optional func tabBarController(_ tabBarController: BraveTabbarController, shouldSelectAtIndex selectedIndex: Int) -> Bool
    /**
     Tells the delegate that the user selected an item in the tab bar.
     */
    @objc optional func tabBarController(_ tabBarController: BraveTabbarController, didSelectAtIndex selectedIndex: Int)
}

open class BraveTabbarController: UIViewController {
    /**
     An array of the root view controllers displayed by the tab bar interface.
     */
    public var viewControllers: [UIViewController] = [] {
        didSet {
            didChangeViewControllers(oldValue: oldValue, newValue: viewControllers)
        }
    }
    
    /**
     The index of the view controller associated with the currently selected tab item.
     */
    open var selectedIndex: Int = 0 {
        didSet {
            didChangeSelectedIndex(oldIndex: oldValue, newIndex: selectedIndex)
        }
    }
    
    /**
     The tab bar controller’s delegate object.
     */
    public weak var delegate: BraveTabbarControllerDelegate?
    

    /**
     Outlet for tab buttons. Make sure buttons' tag is set in increasing order to make it handle select tab button correctly.
     */
    @IBOutlet public var tabButtons: [UIButton]?
    
    /**
     Container for tabbar selected content.
     */
    @IBOutlet public weak var contentViewContainer: UIView!
    
    /**
     Event when click on tab item.
     */
    @objc open func onTabClick(_ button: UIButton) {
        guard let newIndex: Int = tabButtons?.firstIndex(of: button) else { return }
        let shouldSelect: Bool = delegate?.tabBarController?(self, shouldSelectAtIndex: newIndex) ?? true
        guard shouldSelect == true else { return }
        if newIndex != selectedIndex {
            selectedIndex = newIndex
            delegate?.tabBarController?(self, didSelectAtIndex: selectedIndex)
        } else {
            if backToRootWhenTabClicked == true, let navigationController = selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    /**
     The view controller associated with the currently selected tab item.
     */
    public var selectedViewController: UIViewController {
        return viewControllers[selectedIndex]
    }
    
    /**
     When this property is `true`, tab button of the currently selected view controller is clicked, and the selected view controller is navigation controller. Then the selected navigation controller will automatically pop to root.
     */
    public var backToRootWhenTabClicked: Bool = true
    
    fileprivate var isFirstTimeDisplay: Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tab buttons
        tabButtons?.sort(by: { (objA, objB) -> Bool in
            if objA.tag == objB.tag {
                print("Warning: Tab button tag is the same, instead of in increasing order. Tab buttons will not be handled correctly. Please set tab button tag in increasing order")
            }
            return objA.tag < objB.tag
        })
        tabButtons?.forEach({ (button) in
            button.addTarget(self, action: #selector(onTabClick(_:)), for: .touchDown)
        })
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display for first time
        if isFirstTimeDisplay == true {
            isFirstTimeDisplay = false
            didChangeSelectedIndex(oldIndex: -1, newIndex: selectedIndex, isFirstTimeDisplay: true)
        }
    }
    
    fileprivate func addAndDisplayChildViewController(_ childViewController: UIViewController) {
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewContainer.addSubview(childViewController.view)
        childViewController.view.leadingAnchor.constraint(equalTo: contentViewContainer.leadingAnchor).isActive = true
        childViewController.view.trailingAnchor.constraint(equalTo: contentViewContainer.trailingAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: contentViewContainer.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: contentViewContainer.bottomAnchor).isActive = true
        childViewController.willMove(toParent: self)
        addChild(childViewController)
    }
    
    fileprivate func removeAndDismissChildViewController(_ childViewController: UIViewController) {
        childViewController.view.removeFromSuperview()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
    }
        
    fileprivate func selectTabButton(_ button: UIButton) {
        button.isSelected = true
    }
    
    fileprivate func deselectTabButton(_ button: UIButton) {
        button.isSelected = false
    }

    /**
     When isFirstTimeDisplay == true, oldIndex will be ignored
     */
    fileprivate func didChangeSelectedIndex(oldIndex: Int, newIndex: Int, isFirstTimeDisplay: Bool = false) {
        assert(newIndex < viewControllers.count, "View controller index out of bounds")
        if isViewLoaded == true, newIndex != oldIndex {
            if (isFirstTimeDisplay == false) && (oldIndex < viewControllers.count) {
                if let fromButton: UIButton = tabButtons?[oldIndex] {
                    deselectTabButton(fromButton)
                }
                let fromViewController: UIViewController = viewControllers[oldIndex]
                removeAndDismissChildViewController(fromViewController)
            }
            
            if let toButton: UIButton = tabButtons?[newIndex] {
                selectTabButton(toButton)
            }
            
            let toViewController: UIViewController = viewControllers[newIndex]
            addAndDisplayChildViewController(toViewController)
        }
    }
    
    
    fileprivate func didChangeViewControllers(oldValue: [UIViewController], newValue: [UIViewController]) {
        // Remove the old child view controllers.
        for viewController: UIViewController in viewControllers {
            removeAndDismissChildViewController(viewController)
        }
        
        // This follows the same rules as UITabBarController for trying to
        // re-select the previously selected view controller.
        if selectedIndex < oldValue.count {
            let oldSelectedViewController: UIViewController = oldValue[selectedIndex]
            if let newIndex: Int = viewControllers.firstIndex(of: oldSelectedViewController) {
                selectedIndex = newIndex
            } else {
                selectedIndex = 0
            }
        }
    }
}

extension UIViewController {
    /**
     The nearest ancestor in the view controller hierarchy that is BraveTabbarController.
     */
    open var braveTabbarController: BraveTabbarController? {
        var parent: UIViewController? = self.parent
        while parent != nil && parent is BraveTabbarController == false {
            parent = parent?.parent
        }
        let tabBarController: BraveTabbarController? = parent as? BraveTabbarController
        return tabBarController
    }
}
