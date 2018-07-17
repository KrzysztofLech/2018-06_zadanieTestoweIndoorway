//
//  PopTransition.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 17.07.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        let cellView = presenting ? toView : fromView
        
        let initialFrame = presenting ? originFrame : cellView.frame
        let finalFrame = presenting ? cellView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            (initialFrame.height - 20) / finalFrame.height :
            (finalFrame.height - 20) / initialFrame.height
        
        let scaleTransform = CGAffineTransform.init(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            cellView.transform = scaleTransform
            cellView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            cellView.clipsToBounds = true
            cellView.layer.cornerRadius = 4/xScaleFactor
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: cellView)
        
        UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                       animations: {
                        if self.presenting {
                            cellView.transform = CGAffineTransform.identity
                            cellView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                            cellView.layer.cornerRadius = 0
                        } else {
                            cellView.transform = scaleTransform
                            cellView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY - 10)
                            cellView.layer.cornerRadius = 4/xScaleFactor
                        }
        }, completion: { _ in
            if !self.presenting { self.dismissCompletion?() }
            transitionContext.completeTransition(true)
        })
    }
}
