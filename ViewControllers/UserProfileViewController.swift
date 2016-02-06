//
//  UserProfileViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import RealmSwift
import Parse

class UserProfileViewController: UIViewController {
    
    private let cellNibName: String = "ProfileCollectionViewCell"
    private let cellReuseId: String = "profileRecallCell"
    
    var realmProfilePhotos: Results<PhotoProfileRealm>?

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForCollection()
        self.collectionView.backgroundView = nil
        self.collectionView.backgroundColor = UIColor.clearColor()
        // panGestureRecognizer.addTarget(self, action: "handleGesture:")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        getRealmPhotos()
        setUpUserDefaults()
    }
    
    func setUpUserDefaults() {
        if let currentUser = PFUser.currentUser(), username = currentUser.username {
            self.userProfileName.text = username
        }
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

}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let realmProfilePhotos = realmProfilePhotos {
            return realmProfilePhotos.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let realmProfilePhotos = realmProfilePhotos {
            let realmPhoto = realmProfilePhotos[indexPath.row]
            cell.realmPhoto = realmPhoto
            if let imagePath = realmPhoto.imageSentFilePath {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                dispatch_async(queue, { () -> Void in
                    let image = FileManager.getProfileImage(fromPath: imagePath)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (image != nil) {
                            cell.imageView.image = image
                        } else {
                            NSLog("No image at file path for index")
                        }
                    })
                })
            }
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