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
            if let viewController = viewController.childViewControllers.first as? SendViewController {
                viewController.getAccounts()
                viewController.getCurrencies()
                viewController.getRecipients()
            }
            if let viewController = viewController.childViewControllers.first as? TransfersTableViewController {
                viewController.getTransfersData()
            }
            if let viewController = viewController.childViewControllers.first as? RecipientsTableViewController {
                viewController.getRecipientsData()
            }
            if let viewController = viewController.childViewControllers.first as? AccountViewController {
                viewController.getAccountInfo()
            }
        }
    }
}
