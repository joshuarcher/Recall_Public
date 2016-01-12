//
//  UserProfileViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    private let cellNibName: String = "ProfileCollectionViewCell"
    private let cellReuseId: String = "profileRecallCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForCollection()
        self.collectionView.backgroundView = nil
        self.collectionView.backgroundColor = UIColor.clearColor()
        // panGestureRecognizer.addTarget(self, action: "handleGesture:")
        // collectionView.scrollEnabled = false
        // Do any additional setup after loading the view.
    }
    
    private func registerCellForCollection() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellReuseId)
    }
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("profile view dismissed")
        }
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer) {
        
        // let constraintConstant = collectionTopLeadingConstraint.constant
        
        switch (gesture.state) {
        case .Began:
            print("startingLocation: \(gesture.locationInView(gesture.view))")
            
            break
        case .Changed:
            print("changingLocation: \(gesture.locationInView(gesture.view))")
            
            break
        case .Ended:
            print("endingLocation: \(gesture.locationInView(gesture.view))")
            
            break
        default:
            break
        }
        
        
        
        /*
        if gesture.state == .Began {
            print("startingLocation: \(gesture.locationInView(gesture.view))")
        }
        
        if gesture.state == .Changed {
            print("changingLocation: \(gesture.locationInView(gesture.view))")
            
            let translation = gesture.translationInView(gesture.view)
            print("translation: \(translation))")
            
            if constraintConstant <= 200 && constraintConstant >= 0 {
                collectionTopLeadingConstraint.constant = constraintConstant + translation.y
            }
            
            print("constant: \(constraintConstant)")
            
        }
        
        if gesture.state == .Ended {
            print("endingLocation: \(gesture.locationInView(gesture.view))")
        }
        
        if constraintConstant < 0 {
            collectionTopLeadingConstraint.constant = 0
        } else if constraintConstant > 200 {
            collectionTopLeadingConstraint.constant = 200
        }
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    // Flow Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth/2
        let size: CGSize = CGSizeMake(cellWidth, cellWidth)
        
        return size
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
    
}

extension UserProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.collectionView == scrollView {
            let yOffset = scrollView.contentOffset.y
            
            if yOffset < 0 {
                self.viewHeightConstraint.constant = 200 + (-1 * yOffset)
            } else if yOffset > 0 {
                self.viewHeightConstraint.constant = 200 + (-1 * yOffset)
            } else if yOffset == 0 {
                self.viewHeightConstraint.constant = 200
            }
        }
    }
    
    
}