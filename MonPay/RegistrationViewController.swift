//
//  RegistrationViewController.swift
//  MonPay
//
//  Created by Teodor on 26/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    var pageContainer: UIPageViewController!
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    lazy var registrationViewControllers: [UIViewController] = {
        [unowned self] in
        return [
            self.newRegistrationViewController(step: "One"),
            self.newRegistrationViewController(step: "Two"),
            self.newRegistrationViewController(step: "Three")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        if let registrationStepOne = self.registrationViewControllers.first {
            pageContainer.setViewControllers([registrationStepOne], direction: .forward, animated: true, completion: nil)
        }
        view.addSubview(pageContainer.view)
        view.bringSubview(toFront: dismissButton)
        view.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = registrationViewControllers.count
        pageControl.currentPage = 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = registrationViewControllers.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % registrationViewControllers.count)
        return registrationViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = registrationViewControllers.index(of: viewController)!
        if currentIndex == registrationViewControllers.count - 1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % registrationViewControllers.count)
        return registrationViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = registrationViewControllers.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    private func newRegistrationViewController(step: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationStep\(step)")
    }
}
