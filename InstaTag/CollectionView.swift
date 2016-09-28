//
//  CollectionView.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class CollectionView: UIView {
    
    var collectionView: UICollectionView!
    var searchBar = UISearchBar()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        initializeView()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeView(){
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: bounds.width , height: 44))
        searchBar.placeholder = "Search"
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        addSubview(collectionView)
        backgroundColor = UIColor.black
        let viewsDict = [
            "collectionView" : collectionView,
            "searchBar": searchBar
        ] as [String : Any]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: viewsDict))
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    func deviceDidRotate(_ notification: Notification)
    {
        UIApplication.shared.isStatusBarHidden = false
    }
}
