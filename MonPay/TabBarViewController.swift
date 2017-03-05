//
//  TabBarViewController.swift
//  MonPay
//
//  Created by Teodor on 22/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewController = viewController as? UINavigationController {
            if let sendViewController = viewController.childViewControllers.first as? SendViewController {
                sendViewController.refreshData()
            }
            if let transactionsViewController = viewController.childViewControllers.first as? TransfersTableViewController {
                transactionsViewController.refreshData()
            }
            if let beneficiariesViewController = viewController.childViewControllers.first as? RecipientsTableViewController {
                beneficiariesViewController.refreshData()
            }
            if let accountViewController = viewController.childViewControllers.first as? AccountViewController {
                accountViewController.refreshData()
            }
        }
    }
}
