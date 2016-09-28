//
//  CollectionDataSource.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var imageUrl = Image()
    var flag = false
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !flag {
        return imageUrl.url.count
        } else {
            return imageUrl.image.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.activityView.frame = cell.frame
        if !flag {
        cell.loadCellUrl(url: imageUrl.url[indexPath.row])
        } else {
            cell.loadCellCoreData(index: indexPath.row, image: imageUrl)
        }

        return cell
    }
    
}
