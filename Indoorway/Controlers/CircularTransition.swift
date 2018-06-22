//
//  CircularTransition.swift
//  Indoorway
//
//  Created by Krzysztof Lech on 19.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let firstAnimDuration: Double  = 0.4
    private let pauseDuration: Double      = 0.2
    private let secondAnimDuration: Double = 1.6
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    fileprivate var toView: UIView!
    
    private var topView: UIView!
    private var collectionView: UIView!
    private var bottomView: UIView!
    
    // MARK: - Transitioning Methods
    // ------------------------------------------------------
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return firstAnimDuration + pauseDuration + secondAnimDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? MainViewController,
            let toView = toVC.view
            else { return }
        
        self.transitionContext = transitionContext
        self.toView = toView
        
        guard
            let topView = toVC.topView,
            let collectionView = toVC.collectionContainerView,
            let bottomView = toVC.bottomView
            else { return }
        
        self.topView = topView
        self.collectionView = collectionView
        self.bottomView = bottomView
        
        moveComponentsOutsideView()
        
        let container = transitionContext.containerView
        container.addSubview(fromView)
        container.addSubview(toView)
        
        showCircularAnimation(onView: toView)
    }
    
    private func moveComponentsOutsideView() {
        let topViewOffset = topView.frame.origin.y + topView.frame.size.height
        let viewWidth = UIScreen.main.bounds.size.width
        
        topView.transform = CGAffineTransform(translationX: 0, y: -topViewOffset)
        collectionView.transform = CGAffineTransform(translationX: -(viewWidth - collectionView.frame.origin.x), y: 0)
        bottomView.transform = CGAffineTransform(translationX: 0, y: topViewOffset)
    }
    
    // MARK: - Animation Methods
    // ------------------------------------------------------
    
    private func showCircularAnimation(onView view: UIView) {
        let centerPoint = view.center
        let radius = sqrt(centerPoint.x * centerPoint.x + centerPoint.y * centerPoint.y)
        
        let startCircleRectangle = CGRect(x: centerPoint.x, y: centerPoint.y,width: 0, height: 0)
        let startCirclePath = UIBezierPath(ovalIn: startCircleRectangle)
        let endCirclePath   = UIBezierPath(ovalIn: startCircleRectangle.insetBy(dx: -radius, dy: -radius))
        
        let mask = CAShapeLayer()
        mask.path = startCirclePath.cgPath
        view.layer.mask = mask
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = startCirclePath.cgPath
        maskLayerAnimation.toValue = endCirclePath.cgPath
        maskLayerAnimation.duration = firstAnimDuration
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        maskLayerAnimation.delegate = self
        
        mask.add(maskLayerAnimation, forKey: nil)
    }
    
    fileprivate func showComponentAnimations() {
        let collectionAnimDuration = secondAnimDuration * 0.6
        let bottonAnimDuration = secondAnimDuration * 0.2
        let topAnimDuration = secondAnimDuration * 0.2
        
        // collection view anim
        UIView.animate(withDuration: collectionAnimDuration,
                       delay: pauseDuration,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.7,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
            self.collectionView.transform = .identity
        })
 
        // botton view anim
        UIView.animate(withDuration: bottonAnimDuration,
                       delay: collectionAnimDuration,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.bottomView.transform = .identity
        })
 
        // top view anim
        UIView.animate(withDuration: topAnimDuration,
                       delay: collectionAnimDuration + bottonAnimDuration,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.topView.transform = .identity
        }) { _ in
            self.transitionContext.completeTransition(true)
        }
    }
}

// MARK: - Animation Delegate Methods
// ------------------------------------------------------

extension CircularTransition: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        toView.layer.mask = nil
        showComponentAnimations()
    }
}

// MARK: - Transitioning Delegate Methods
// ------------------------------------------------------

extension CircularTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
