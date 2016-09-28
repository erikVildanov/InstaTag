//
//  DeteilViewController.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 26.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class DeteilViewController: UIViewController, UIScrollViewDelegate {
    
    var image = UIImage()
    let deteilView = DeteilView()
    var index: Int!
    var flag = false
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comment & Image"
        view = deteilView
        
        deteilView.scrollView.delegate = self
        
        initializeImageView()
        setupGestureRecognizer()
        createBarButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createBarButton() {
        let coreDataService = CoreDataService(context: context)
        let fevarites = coreDataService.getAllFevarites()
        
        //поиск совпадений для избранных
        if fevarites.count > 0 {
        DispatchQueue.main.async {
            for i in 0..<fevarites.count{
                if UIImagePNGRepresentation(self.image)! == fevarites[i].image as! Data {
                    let disLike = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(self.deleteFevarites))
                    self.navigationItem.rightBarButtonItem = disLike
                    self.index = i
                    break
                }
            }
        }
        }
        if !self.flag {
            let like = UIBarButtonItem(image: UIImage(named: "disLike"), style: .done, target: self, action: #selector(self.addFevarites))
            self.navigationItem.rightBarButtonItem = like
        } else {
            let disLike = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(self.deleteFevarites))
            self.navigationItem.rightBarButtonItem = disLike
        }
    }
    
    func addFevarites(){
        let disLike = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(deleteFevarites))
        navigationItem.rightBarButtonItem = disLike
        let coreDataService = CoreDataService(context: context)
        if let image = deteilView.imageView.image {
            let comment = deteilView.label.text!
            let data = NSData(data: UIImagePNGRepresentation(image)!)
        _ = coreDataService.createNewFevarites(comment, image: data)
        }
        coreDataService.saveChanges()
    }
    
    func deleteFevarites(){
        let like = UIBarButtonItem(image: UIImage(named: "disLike"), style: .done, target: self, action: #selector(addFevarites))
        navigationItem.rightBarButtonItem = like
        let coreDataService = CoreDataService(context: context)
        var readFevarites: [Fevarites] = coreDataService.getAllFevarites()
        if index == nil {
            index = readFevarites.count-1
        }
        let deleteCoWorker = coreDataService.getByIdFevarites(readFevarites[index].objectID)
        coreDataService.deleteFevarites(deleteCoWorker.objectID)
        readFevarites.remove(at: index)
        coreDataService.saveChanges()
    }
    
    func initializeImageView(){
        deteilView.label.textColor = UIColor.white
        deteilView.label.lineBreakMode = .byWordWrapping
        deteilView.label.numberOfLines = 0
        let width = UIScreen.main.bounds.width
        let height = heightForView(text: deteilView.label.text!, font: deteilView.label.font!, width: width)

        deteilView.scrollLabel.contentSize = CGSize(width: width, height: height)
        deteilView.label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        deteilView.imageView.image = image
        deteilView.imageView.contentMode = UIViewContentMode.center
        deteilView.imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        deteilView.scrollView.contentSize = image.size
        
        let scrollViewFrame = deteilView.scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / deteilView.scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / deteilView.scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        deteilView.scrollView.minimumZoomScale = minScale
        deteilView.scrollView.maximumZoomScale = 1
        deteilView.scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
    }
    
    func centerScrollViewContents(){
        let boundsSize = deteilView.scrollView.bounds.size
        var contentsFrame = deteilView.imageView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        self.deteilView.imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return deteilView.imageView
    }
    
    func setupGestureRecognizer() {
        deteilView.imageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        deteilView.imageView.addGestureRecognizer(doubleTap)
    }
    
    
    func handleDoubleTap() {
        if deteilView.scrollView.zoomScale > deteilView.scrollView.minimumZoomScale {
            deteilView.scrollView.setZoomScale(deteilView.scrollView.minimumZoomScale, animated: true)
        } else {
            deteilView.scrollView.setZoomScale(deteilView.scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        var currHeight:CGFloat!
        let label:UILabel = UILabel(frame: CGRect(x:0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        currHeight = label.frame.height
        label.removeFromSuperview()
        return currHeight
    }
}
