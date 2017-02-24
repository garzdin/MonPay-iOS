//
//  CustomPushSegue.swift
//  MonPay
//
//  Created by Teodor on 24/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

class PushSegue: UIStoryboardSegue {
    override func perform() {
        let fromViewController = self.source
        let toViewController = self.destination
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(translationX: fromViewController.view.frame.size.width, y: 0)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { (value: Bool) in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}

class UnwindPushSegue: UIStoryboardSegue {
    override func perform() {
        let fromViewController = self.source
        let toViewController = self.destination
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: fromViewController.view.frame.size.width, y: 0)
        }, completion: { (value: Bool) in
            fromViewController.dismiss(animated: false, completion: nil)
        })
    }
}
