# BraveTabbarController

BraveTabbarController is an swift alternative for UITabbarController. UITabbarController is good but not easy to customize. Such as: if you want to customize tab bar icons, you have to follow apple design guides, which is complicated. Moreover, UITabbarController is good to use in storyboard, but not as well in xib. BraveTabbarController is created to mimic UITabbarController but free developers from apple's complicated design guides.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 9.0+

## Installation

BraveTabbarController is available through [CocoaPods](https://cocoapods.org). To install it, first the beginning add the following line to your Podfile:  
```ruby
pod 'BraveTabbarController'
```

## Usage

### How to create

Subclass your view controller as BraveTabbarController. In your view controller there should be 2 following components: 
1. Buttons for switching selected tab.
2. Content view as container for display selected tab's content.

#### Set up tabbar buttons
- First, set each tabbar buttons' tag value with differentt value in increasing order. 
- Then, drag connect IBOutlet of each tabbar buttons into property `tabButtons`.

#### Set up tabbar contents
- In viewDidLoad method, create an array of view controllers and set into value of viewControllers property of BraveTabbarController. Here is an example:  

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    var viewControllers : Array<UIViewController> = Array();
    for i in 0..<3 {
        var vc : UIViewController
        switch (i) {
        case 0:
            vc = RankingViewController(nibName: String(describing: RankingViewController.self), bundle:nil)
            break
        case 1:
            vc = PostViewController(nibName: String(describing: PostViewController.self), bundle:nil)
            break
        case 2:
            vc = MyPageViewController(nibName: String(describing: MyPageViewController.self), bundle:nil)
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
```

That's all, here is a video demonstrated the above set up (this is for objective c version but the steps are just the same):  
[![IMAGE ALT TEXT HERE](http://i3.ytimg.com/vi/jREqJEXATCY/hqdefault.jpg)](https://youtu.be/jREqJEXATCY)

**Note**: 
- The flow above is just an optional way to set up. You are not forced to always use this way. Instead, you can explore the code in order to perform an initiallize suitable with your own purpose.
- In case you want BraveTabbarController to subclass other classed, please create a wrapper view controller, add BraveTabbarController as child view controller, then subclass the wrapper.

### Access ancestor
Like `UITabbarController`, `BraveTabbarController` also provide an extension which helps you to retrieve tab bar controller from its children by using property `braveTabBarController`
```swift
extension UIViewController {
    /**
     The nearest ancestor in the view controller hierarchy that is BraveTabbarController.
     */
    open var braveTabBarController: BraveTabbarController? { get }
}
```

### Back to root
When click on tab button you may want the corresponding navigation controller to pop to root, `BraveTabbarController`. When this property is `true`, tab button of the currently selected view controller is clicked, and the selected view controller is navigation controller. Then the selected navigation controller will automatically pop to root. The default value is `true`.
If you want more customization, then set it to `false` and override method `onTabClick` or delegate method `shouldSelectAtIndex`.

### Customize
`BraveTabbarController` provide `BraveTabbarControllerDelegate` protocol when you want to augment the behavior of a tab bar. In particular, you can use it to determine whether specific tabs should be selected, to perform actions after a tab is selected. After implementing these methods in your custom object, you should then assign that object to the delegate property of the corresponding `BraveTabbarController` object.
```swift
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
```

### References
Here is the list of all public properties and method you can use:
- `viewControllers`:  An array of the root view controllers displayed by the tab bar interface.
- `selectedIndex`:  The index of the view controller associated with the currently selected tab item.
- `delegate`: The tab bar controller’s delegate object.
- `tabButtons`: Outlet for tab buttons. Make sure buttons' tag is set in increasing order to make it handle select tab button correctly.
- `contentViewContainer`: Container for tabbar selected content.
- `onTabClick`: Event when click on tab item. You can override this method for customization.
- `selectedViewController`: The view controller associated with the currently selected tab item, read only.

## Author

Hien Pham, hienpham@bravesoft.com.vn

## License

BraveTabbarController is available under the MIT license. See the LICENSE file for more info.
