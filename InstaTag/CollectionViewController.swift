//
//  ViewController.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    let collectionView = CollectionView()
    var collectionData = CollectionDataSource()
    let refreshControl = UIRefreshControl()
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tag = ""
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = collectionView
        
        collectionView.collectionView.delegate = self
        collectionView.searchBar.delegate = self
        collectionView.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
        self.navigationItem.hidesBackButton = !flag
        if flag {
            collectionView.searchBar.removeFromSuperview()
            navigationItem.title = "Offline Mode"
        }
        else {
            createBarButtonLogOut()
            refreshCollection()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionData = CollectionDataSource()
        
        loadData()
    }
    
    func createBarButtonLogOut(){
        
        self.navigationItem.titleView = collectionView.searchBar
        let logOutButton = UIBarButtonItem(image: UIImage(named: "Exit"), style: .plain, target: self, action: #selector(logout))
        self.navigationItem.setRightBarButton(logOutButton, animated: true)
        let fevarites = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(showFevarites))
        self.navigationItem.setLeftBarButton(fevarites, animated: true)

    }
    
    func logout() {
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func showFevarites(){
        DispatchQueue.main.async {
        self.flag = true
        self.collectionData = CollectionDataSource()
        let back = UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(self.backCollection))
        self.navigationItem.setLeftBarButton(back, animated: true)
        self.loadData()
        }
    }
    
    func backCollection(){
        DispatchQueue.main.async {
        let disLike = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(self.showFevarites))
        self.navigationItem.setLeftBarButton(disLike, animated: true)
        self.flag = false
        self.collectionData = CollectionDataSource()
        self.loadData()
        }
    }
    
    func refreshCollection(){
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView.collectionView.addSubview(refreshControl)
    }

    func refresh() {
        refreshControl.beginRefreshing()
        loadJson {
            self.collectionView.collectionView.reloadSections(IndexSet(integer: 0))
            self.refreshControl.endRefreshing()
        }
        
        
    }

    func loadJson(_ completion: ((Void) -> Void)?){
        let feedJsonParser = FeedParser()
        feedJsonParser.parseFeed(feedUrl: "https://www.instagram.com/explore/tags/" + tag, completionHandler:
            {
                (json: Image) -> Void in
                self.collectionData.imageUrl = json
                DispatchQueue.main.async(execute: {
                    completion?()
                })
        })
    }

    func doLogin() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func loadData(){
        
        //reloadCV()
        if !flag {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadJson{
            self.collectionView.collectionView.reloadSections(IndexSet(integer: 0))
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        } else {
            collectionData.flag = true
            let coreDataService = CoreDataService(context: context)
            let fevarites = coreDataService.getAllFevarites()
            for i in 0..<fevarites.count {
                collectionData.imageUrl.image.append(UIImage(data: fevarites[i].image as! Data)!)
                collectionData.imageUrl.comment.append(fevarites[i].comment!)
                
            }
        }
        collectionView.collectionView.dataSource = collectionData
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let frame : CGRect = self.view.frame
        let margin  = (frame.width - 90 * 3) / 6.0
        return UIEdgeInsetsMake(10, margin, 10, margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deteilViewController = DeteilViewController()
        if !flag {
        if (collectionData.imageUrl.url[indexPath.row].cachedImage) != nil
        {
            deteilViewController.image = collectionData.imageUrl.url[indexPath.row].cachedImage!
            deteilViewController.deteilView.label.text = collectionData.imageUrl.comment[indexPath.row]
            self.navigationController?.pushViewController(deteilViewController, animated: true)
        }
        } else {
            let coreDataService = CoreDataService(context: context)
            let fevarites = coreDataService.getAllFevarites()
            deteilViewController.index = indexPath.row
            deteilViewController.flag = flag
            deteilViewController.image = UIImage(data: fevarites[indexPath.row].image as! Data)!
            deteilViewController.deteilView.label.text = collectionData.imageUrl.comment[indexPath.row]
            self.navigationController?.pushViewController(deteilViewController, animated: true)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tag = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refresh), object: nil)
        self.perform(#selector(refresh), with: nil, afterDelay: 0.5)
    }


    func reloadCV() {
        collectionView.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
        collectionView.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.collectionView.searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




























