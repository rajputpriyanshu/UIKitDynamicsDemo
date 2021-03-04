//
//  ViewController.swift
//  UIKitDynamicsDemo
//
//  Created by Priyanshu Rajput on 04/03/21.
//

import UIKit

let thresholdValueToPush: CGFloat = 1000
let paddingForThrowingVelocity: CGFloat = 35

class DynamicsDemoVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var square1ForPosition: UIView!
    @IBOutlet weak var square2ForPosition: UIView!
    
    private var originalImageBounds = CGRect.zero
    private var originalImageCenter = CGPoint.zero
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    @IBAction func handleImageGesture(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.imageView)
        
        switch sender.state {
        case .began:
            animator.removeAllBehaviors()
            
            let centerOffset = UIOffset(horizontal: boxLocation.x - imageView.bounds.midX, vertical: boxLocation.y - imageView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: imageView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            square1ForPosition.center = attachmentBehavior.anchorPoint
            square2ForPosition.center = location
            
            animator.addBehavior(attachmentBehavior)
            
        case .ended:
            animator.removeAllBehaviors()
            
            let velocity = sender.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > thresholdValueToPush {
                let pushBehavior = UIPushBehavior(items: [imageView], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / paddingForThrowingVelocity
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [imageView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), for: imageView)
                animator.addBehavior(itemBehavior)
                
                self.resetPosition()
                
            } else {
                resetPosition()
            }
            
        default:
            attachmentBehavior.anchorPoint = sender.location(in: view)
            square1ForPosition.center = attachmentBehavior.anchorPoint
            
            break
        }
    }
    
    func resetPosition() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.45) {
            self.imageView.bounds = self.originalImageBounds
            self.imageView.center = self.originalImageCenter
            self.imageView.transform = .identity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        originalImageBounds = imageView.bounds
        originalImageCenter = imageView.center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


