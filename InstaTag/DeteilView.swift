//
//  DeteilView.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 26.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class DeteilView: UIView {
    
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    var label = UILabel()
    let scrollLabel = UIScrollView()
    
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
    
    func initializeView(){
        addSubview(scrollView)
        addSubview(scrollLabel)

        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height-64)
        scrollLabel.frame = CGRect(x: 0, y: 0, width: width, height: 100)
        
        let viewsDict = [
            "scrollView" : scrollView,
            "scrollLabel" : scrollLabel,
        ] as [String : Any]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollLabel]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView][scrollLabel(100)]|", options: [], metrics: nil, views: viewsDict))
        scrollView.addSubview(imageView)
        scrollLabel.addSubview(label)
        
    }
    
}
