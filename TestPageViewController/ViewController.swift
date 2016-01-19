//
//  ViewController.swift
//  TestPageViewController
//
//  Created by testdev on 16/1/11.
//  Copyright © 2016年 testdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let pageController = FECustomPageViewController()
        
        pageController.list_image = [UIImage(named: "guide_page_one")!, UIImage(named: "guide_page_two")!, UIImage(named: "guide_page_three")!, UIImage(named: "1.pic.jpg")!]
        
//        pageController.imageType = .ImageTypeCarousel
        
        pageController.tapHandler = {
            print("hello")
        }
        
        self.presentViewController(pageController, animated: true, completion: nil)
        
//        pageController.view.frame = CGRect(x: 29, y: 20, width: 200, height: 300)
//        self.addChildViewController(pageController)
//        self.view.addSubview(pageController.view)
    }

}

