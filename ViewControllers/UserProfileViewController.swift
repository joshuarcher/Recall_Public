//
//  UserProfileViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import RealmSwift

class UserProfileViewController: UIViewController {
    
    private let cellNibName: String = "ProfileCollectionViewCell"
    private let cellReuseId: String = "profileRecallCell"
    
    var realmProfilePhotos: Results<PhotoProfileRealm>?

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForCollection()
        self.collectionView.backgroundView = nil
        self.collectionView.backgroundColor = UIColor.clearColor()
        getRealmPhotos()
        // panGestureRecognizer.addTarget(self, action: "handleGesture:")
        // Do any additional setup after loading the view.
    }
    
    func getRealmPhotos() {
        realmProfilePhotos = RealmHelper.getAllProfilePhotos()
        print(realmProfilePhotos)
        
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
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        showSettingsViewController()
    }
    
    func showSettingsViewController() {
        let nextVc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.presentViewControllerFromTopViewController(nextVc)
    }
    
    /*
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
        
        if indexPath.row != 9 {
            cell.label.text = "word"
        }
        
        return cell
    }
    
    // Flow Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth/2
        
        let row = indexPath.row
        
        if row == 0 || row == 1 {
            let size: CGSize = CGSizeMake(cellWidth, cellWidth + 4)
            return size
        } else {
            let size: CGSize = CGSizeMake(cellWidth, cellWidth)
            return size
        }
        
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