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
    
    var photoTakingHelper: PhotoTakingHelper?
    
    private let cellNibName: String = "ProfileCollectionViewCell"
    private let cellReuseId: String = "profileRecallCell"
    
    var realmProfilePhotos: Results<PhotoProfileRealm>?
    
    var parsePhotos: [Photo]?

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Control Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePhotos()
        registerCellForCollection()
        self.collectionView.backgroundView = nil
        self.collectionView.backgroundColor = UIColor.clearColor()
        setUpUserDefaults()
    }
    
    override func viewDidAppear(animated: Bool) {
        addPhotoTouchEvent()
        
    }
    
    // MARK: - Init Methods
    
    private func addPhotoTouchEvent() {
        let tap = UITapGestureRecognizer(target: self, action: "chooseProfilePhoto")
        tap.numberOfTapsRequired = 1
        userProfileImage.userInteractionEnabled = true
        userProfileImage.addGestureRecognizer(tap)
        
    }
    
    private func initializePhotos() {
        self.userProfileImage.layer.cornerRadius = 50
        self.userProfileImage.layer.masksToBounds = true
        parsePhotos = []
        fetchSavedPhotosParse()
    }
    
    private func registerCellForCollection() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellReuseId)
    }
    
    func setUpUserDefaults() {
        if let currentUser = PFUser.currentUser(), username = currentUser.username {
            self.userProfileName.text = username
        }
    }
    
    func getRealmPhotos() {
        realmProfilePhotos = RealmHelper.getAllProfilePhotos()
        print(realmProfilePhotos?.count)
        
    }
    
    func fetchSavedPhotosParse() {
        ParseHelper.savedPhotosRequestTimeline { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results {
                if let photos = results.map({ $0[ParseHelper.ParseSavedPhoto] }) as? [Photo] {
                    self.parsePhotos = photos
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        showSettingsViewController()
    }
    
    func showSettingsViewController() {
        let nextVc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.presentViewController(nextVc, animated: true) { () -> Void in
            print("settings presented")
        }
    }
    
    func chooseProfilePhoto() {
        // instanstiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            guard let image = image else {return}
            self.userProfileImage.image = image
        })
        
    }

}

// MARK: - Collection View methods

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let parsePhotos = parsePhotos else { return 0 }
        
        return parsePhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let parsePhotos = parsePhotos else { return cell }
        
        let photo = parsePhotos[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        
        return cell
    }
    
    // MARK: - Flow Layout
    
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

// MARK: - Scroll View

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