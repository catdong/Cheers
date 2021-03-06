//
//  FriendsViewController.swift
//  Cheers
//
//  Created by Minna Xiao on 3/9/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

import UIKit
import MapKit

class FriendsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // model
    var partyPeople: [DrinkingBuddy] = []
    
    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var chatButton: UIButton!
    
    
    
    // if you do this u can no longer swipe back
    @IBAction func showFluidVC(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "left") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: appDelegate.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: { () -> Void in
            appDelegate.window!.rootViewController = mainVC
        }, completion:nil)
        
    }
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        createFriends()
        
        /*guard let collectionView = collectionView else { return }
        collectionView.mask = GradientMaskView(frame: CGRect(origin: CGPoint.zero, size: collectionView.bounds.size))*/
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        
        configureButtons()
        
        // mask view shit
        /*guard let collectionView = collectionView,
            let maskView = collectionView.mask as? GradientMaskView,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else {
                return
        }
        
        /*
         Update the mask view to have fully faded out any collection view
         content above the navigation bar's label.
         */
        maskView.maskPosition.end = topLayoutGuide.length * 0.8
        
        /*
         Update the position from where the collection view's content should
         start to fade out. The size of the fade increases as the collection
         view scrolls to a maximum of half the navigation bar's height.
         */
        let maximumMaskStart = maskView.maskPosition.end + (topLayoutGuide.length * 0.5)
        let verticalScrollPosition = max(0, collectionView.contentOffset.y + collectionView.contentInset.top)
        maskView.maskPosition.start = min(maximumMaskStart, maskView.maskPosition.end + verticalScrollPosition)
        
        /*
         Position the mask view so that it is always fills the visible area of
         the collection view.
         */
        var rect = CGRect(origin: CGPoint(x: 0, y: collectionView.contentOffset.y), size: collectionView.bounds.size)
        
        /*
         Increase the width of the mask view so that it doesn't clip focus
         shadows along its edge. Here we are basing the amount to increase the
         frame by on the spacing defined in the collection view's layout.
         */
        rect = rect.insetBy(dx: -layout.minimumInteritemSpacing, dy: 0)
        
        maskView.frame = rect
        */
        
 
    }

    // Private
    private struct Constants {
        //static let reuseIdentifier = "FriendCell"
        
        static let sectionInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
    }
    
    private func configureButtons() {
        // not really working right now
        chatButton.layer.cornerRadius = 0.5*chatButton.bounds.size.width
        chatButton.layer.borderColor = UIColor.white.cgColor
        chatButton.clipsToBounds = true
        //chatButton.layer.shadowColor = UIColor.blue.cgColor
        chatButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        chatButton.layer.shadowRadius = 5
        chatButton.layer.shadowOpacity = 1

    }
    
    private func createFriends() {
        let coord = CLLocationCoordinate2D(latitude: 37.445158, longitude: -122.163913)
        let emily = DrinkingBuddy(name: "Emily", status: DrinkingBuddy.Status.dangerZone, title: nil, subtitle: "The Patio", coordinate: coord)
        let catherine = DrinkingBuddy(name: "Catherine", status: DrinkingBuddy.Status.fine, title: nil, subtitle: "The Patio", coordinate: coord)
        let jeremy = DrinkingBuddy(name: "Jeremy", status: DrinkingBuddy.Status.fine, title: nil, subtitle: "The Patio", coordinate: coord)
        let shubha = DrinkingBuddy(name: "Shubha", status: DrinkingBuddy.Status.left, title: nil, subtitle: "The Patio", coordinate: coord)
        partyPeople = [emily, catherine, jeremy, shubha, jeremy, jeremy, jeremy, jeremy]
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // implement the fading collection view thing here maybe? or use a gradient mask
        
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return partyPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let buddy = partyPeople[indexPath.item]
        if buddy.status == DrinkingBuddy.Status.dangerZone {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrunkFriendCell", for: indexPath) as! DrunkFriendCollectionViewCell
            cell.backgroundColor = UIColor.red
            cell.name = buddy.name
            return cell
        
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! FriendCollectionViewCell
            cell.backgroundColor = UIColor.gray
            cell.name = buddy.name
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buddy = partyPeople[indexPath.item]
        var itemsInRow: CGFloat = 2.0
        var paddingSpace = Constants.sectionInsets.left * (itemsInRow + 1)
        var availableWidth = view.frame.width - paddingSpace
        let heightPerItem = availableWidth / itemsInRow
        
        if buddy.status == DrinkingBuddy.Status.dangerZone {
            itemsInRow = 1.0
            paddingSpace = Constants.sectionInsets.left * (itemsInRow + 1)
            availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsInRow
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
        
        return CGSize(width: heightPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
