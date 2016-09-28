//
//  CollectionViewCell.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let activityView = ActivityView()
    
    func loadCellUrl(url: URL) {
        backgroundView = activityView

            if (url.cachedImage) != nil
            {
                backgroundView = UIImageView(image: url.cachedImage)
                backgroundView!.contentMode = .scaleAspectFit
                activityView.removeFromSuperview()
            } else {
                url.fetchImage{ image in
                    self.backgroundView = UIImageView(image: image)
                    self.backgroundView!.contentMode = .scaleAspectFit
                    self.activityView.removeFromSuperview()
                }
            }
    }
    
    func loadCellCoreData(index: Int, image: Image){
        backgroundView = UIImageView(image: image.image[index])
        backgroundView!.contentMode = .scaleAspectFit
    }
    
    
}
