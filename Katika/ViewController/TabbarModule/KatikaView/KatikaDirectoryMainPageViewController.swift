//
//  KatikaDirectoryMainPageViewController.swift
//  SportLite
//
//  Created by Spotable_04 on 14/09/17.
//  Copyright © 2017 Spotable. All rights reserved.
//

import UIKit

class KatikaDirectoryMainPageViewController: UIPageViewController {

  weak var profileDelegate: KatikaDirectoryMainPageViewControllerDelegate?
  
  fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
    // The view controllers will be shown in this order
    return [
        self.newColoredViewController("Katika"),
        self.newColoredViewController("KatikaDirectory")]
    
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.removeSwipeGesture()
    
    dataSource = self
    delegate = self
    
    //Deseble Scrolling between two controller
    for view in self.view.subviews {
        if let subView = view as? UIScrollView {
            subView.isScrollEnabled = false
        }
    }

    if let initialViewController = orderedViewControllers.first {
      scrollToViewController(initialViewController)
    }
    
    profileDelegate?.KatikaDirectoryMainPageViewController(self,
                                             didUpdatePageCount: orderedViewControllers.count)
  }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
  /**
   Scrolls to the next view controller.
   */
  func scrollToNextViewController() {
    if let visibleViewController = viewControllers?.first,
      let nextViewController = pageViewController(self,
                                                  viewControllerAfter: visibleViewController) {
      scrollToViewController(nextViewController)
    }
  }
  func scrollToPreviewsViewController(indexCall : Int) {
    self.scrollToViewController(index : indexCall)
  }
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    //        pageControl.setSelectedSegmentIndex((pages as NSArray).index(of: pendingViewControllers.last), animated: true)
  }
  
  
  
  /**
   Scrolls to the view controller at the given index. Automatically calculates
   the direction.
   
   - parameter newIndex: the new index to scroll to
   */
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,
      let currentIndex = orderedViewControllers.index(of: firstViewController) {
      let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = orderedViewControllers[newIndex]
      scrollToViewController(nextViewController, direction: direction)
    }
    
    if let firstViewController = viewControllers?.last,
      let currentIndex = orderedViewControllers.index(of: firstViewController) {
      let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .reverse : .reverse
      let nextViewController = orderedViewControllers[newIndex]
      scrollToViewController(nextViewController, direction: direction)
    }
  }
  
  fileprivate func newColoredViewController(_ color: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil) .
      instantiateViewController(withIdentifier: "\(color)ViewController")
  }
  
  /**
   Scrolls to the given 'viewController' page.
   
   - parameter viewController: the view controller to show.
   */
  fileprivate func scrollToViewController(_ viewController: UIViewController,
                                          direction: UIPageViewController.NavigationDirection = .forward) {
    setViewControllers([viewController],
                       direction: direction,
                       animated: true,
                       completion: { (finished) -> Void in
                        // Setting the view controller programmatically does not fire
                        // any delegate methods, so we have to manually notify the
                        // 'tutorialDelegate' of the new index.
                        self.notifyTutorialDelegateOfNewIndex()
    })
  }
  
  /**
   Notifies '_tutorialDelegate' that the current page index was updated.
   */
  fileprivate func notifyTutorialDelegateOfNewIndex() {
    if let firstViewController = viewControllers?.first,
      let index = orderedViewControllers.index(of: firstViewController) {
      profileDelegate?.KatikaDirectoryMainPageViewController(self,
                                               didUpdatePageIndex: index)
    }
  }
  
}

// MARK: UIPageViewControllerDataSource

extension KatikaDirectoryMainPageViewController : UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard orderedViewControllers.count > previousIndex else {
      return nil
    }
    
    return orderedViewControllers[previousIndex]
    
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = orderedViewControllers.count
    
    guard orderedViewControllersCount != nextIndex else {
      return nil
    }
    
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    
    return orderedViewControllers[nextIndex]
    
  }
  
}

extension KatikaDirectoryMainPageViewController : UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    notifyTutorialDelegateOfNewIndex()
  }
  
}

protocol KatikaDirectoryMainPageViewControllerDelegate : class {
  
  /**
   Called when the number of pages is updated.
   
   - parameter HomePageViewController: the HomePageViewController instance
   - parameter count: the total number of pages.
   */
  func KatikaDirectoryMainPageViewController(_ KatikaDirectoryMainPageViewController: KatikaDirectoryMainPageViewController,
                              didUpdatePageCount count: Int)
  
  /**
   Called when the current index is updated.
   
   - parameter HomePageViewController: the HomePageViewController instance
   - parameter index: the index of the currently visible page.
   */
  func KatikaDirectoryMainPageViewController(_ KatikaDirectoryMainPageViewController: KatikaDirectoryMainPageViewController,
                              didUpdatePageIndex index: Int)
  
}
