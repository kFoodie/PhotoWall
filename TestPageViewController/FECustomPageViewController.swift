//
//  ViewController.swift
//  TestUIPageViewController
//
//  Created by testdev on 16/1/8.
//  Copyright © 2016年 testdev. All rights reserved.
//

import UIKit

/// 使用声明：要先addChildViewController，再addSubview；或者直接presentViewController，或者push
class FECustomPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    enum ImageType {
        /// 轮播
        case ImageTypeCarousel
        /// 照片墙
        case ImageTypePhotoWall
    }
    
    private let ImgViewOriginTag = 100
    private var nextIndex: Int = 0
    private var controllers: [UIViewController]! = [UIViewController]()
    private var pageViewController: UIPageViewController!
    private var pageControl: UIPageControl!
    private var timer: NSTimer!
    /// 判断是否为长图
    private var list_isLongPicture: [Bool]! = [Bool]()
    
    /// 是否能够无限滚动
    var canCarousel: Bool = false
    /// 展示图片的类型
    var imageType: ImageType = .ImageTypePhotoWall
    /// 轮播的点击事件
    var tapHandler: (() -> Void)?
    /// 轮播时间
    var timeInterval: NSTimeInterval = 1.0
    /// 图片列表
    var list_image: [UIImage]!
    /// 当前图片的下标
    var currentIndex: Int = 0
    /// 双击的缩放比例
    var scaleForDoubleTap: CGFloat = 2.0
    /// 非当前的圆点的颜色
    var pageColor: UIColor! = UIColor.darkGrayColor()
    /// 当前圆点颜色
    var currentColor: UIColor! = UIColor.whiteColor()
    
    // MARK: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        if list_image.count > 0 {
            
            configurePageViewController()
            configurePageControl()
            
            if self.imageType == .ImageTypeCarousel {
                startTimer()
            }
            
        }
        
    }
    
    deinit {
        
        if controllers.count != 0 {
            controllers.removeAll()
            controllers = nil
        }
        
        if list_image.count != 0 {
            list_image.removeAll()
            list_image = nil
        }
        
        if list_isLongPicture.count != 0 {
            list_isLongPicture.removeAll()
            list_isLongPicture = nil
        }
        
        stopTimer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.imageType == .ImageTypePhotoWall {
            
            let touch = (touches as NSSet).anyObject()
            
            if touch?.tapCount == 2 {
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
            }
            
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.imageType == .ImageTypePhotoWall {
            
            let touch = (touches as NSSet).anyObject()
            
            if touch?.tapCount == 1 {
                
                self.performSelector("singleTapHandler", withObject: nil, afterDelay: 0.20)
                
            } else if touch?.tapCount == 2 {
                
                if let imageView = touch?.view as? UIImageView,
                    let scrollView = imageView.superview as? UIScrollView,
                    let center = touch?.locationInView(imageView) {
                        doubleTapHandler(scrollView, center: center)
                }
                
            }
            
        }
        
    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        let subViews: NSArray = (view.subviews.first?.subviews)!
//        var scrollView: UIScrollView? = nil
//        var pageControl: UIPageControl? = nil
//        
//        for view in subViews {
//            
//            print("view = \(view)")
//            
//            if view.isKindOfClass(UIScrollView) {
//                scrollView = view as? UIScrollView
//            }
//            else if view.isKindOfClass(UIPageControl) {
//                pageControl = view as? UIPageControl
//            }
//        }
//        
//        if (scrollView != nil && pageControl != nil) {
//            
//            print("super = \(pageControl!.superview!)")
//            print("super--super = \(pageControl!.superview?.superview)")
//            
//            pageControl!.superview!.superview!.bringSubviewToFront(pageControl!.superview!)
//            pageControl!.superview!.bringSubviewToFront(pageControl!)
//            
//            pageControl!.superview!.superview!.backgroundColor = UIColor.clearColor()
//            pageControl!.superview!.backgroundColor = UIColor.clearColor()
//            pageControl!.backgroundColor = UIColor.clearColor()
//            
//            pageControl?.hidden = true
//            
//        }
//    }
    
    // MARK: - Actions
    
//    func handlerPinch(pinchGesture: UIPinchGestureRecognizer) {
//        
//        // todo 放大会变模糊，要处理一下。
//        
//        if let imageView = pinchGesture.view as? UIImageView {
//            
//            let controller = controllers[imageView.tag - ImgViewOriginTag]
//            
//            switch pinchGesture.state {
//                
//            case .Changed:
//                
//                let scale = pinchGesture.scale
//                
//                //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
//                imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
////                pageViewController.view.transform = imageView.transform
//                controller.view.transform = imageView.transform
//                
//                configureImage(imageView.image!, imageView: imageView)
//                
//                // 这里要注意
//                pinchGesture.scale = 1.0
//                
//            case .Ended:
//                
//                if imageView.frame.width < width_imageView {
//                    
//                    UIView.animateWithDuration(1, animations: { () -> Void in
//                        
//                        imageView.transform = CGAffineTransformIdentity
//                        self.configureImage(imageView.image!, imageView: imageView)
////                        self.pageViewController.view.transform = imageView.transform
//                        controller.view.transform = imageView.transform
//                        
//                    })
//                    
//                }
//                
//            default:
//                break
//                
//            }
//            
//        }
//        
//    }
    
//    func cutImage() {
//        
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0.0)
//        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIwidth_imageViewriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
//        UIGraphicsEndImageContext()
//        
//    }
    
//    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
//        
//        var message = ""
//        
//        if didFinishSavingWithError == nil {
//            message = "成功保存到相册"
//        } else {
//            message = (didFinishSavingWithError?.debugDescription)!
//        }
//        
//        let controller = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
//        let action = UIAlertAction(title: "确定", style: .Default, handler: nil)
//        
//        controller.addAction(action)
//        
//        self.presentViewController(controller, animated: true, completion: nil)
//        
//    }
    
    func singleTapHandler() {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func doubleTapHandler(scrollView: UIScrollView, center: CGPoint) {
        
        let oldScale = scrollView.zoomScale
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            if (oldScale > 1.0) { // 这么写才能在放大的时候缩回去
                scrollView.zoomScale = 1.0
            } else {
                
                let newScale = scrollView.zoomScale * self.scaleForDoubleTap
                let zoomRect = self.zoomRectForScale(scrollView, scale: newScale, center: center)
                
                scrollView.zoomToRect(zoomRect, animated: true)
                
            }
            
        }
        
    }
    
    func tapGestureHandler(tapGesture: UITapGestureRecognizer) {
        
        if tapGesture.numberOfTapsRequired == 2 {
            
            if let imageView = tapGesture.view as? UIImageView,
                let scrollView = imageView.superview as? UIScrollView {

                doubleTapHandler(scrollView, center: tapGesture.locationInView(scrollView))

            }
            
        } else if tapGesture.numberOfTapsRequired == 1 {
            
            singleTapHandler()
            
        }
    }
    
    func tapAction() {
        
        if let tapHandler = tapHandler {
            tapHandler()
        }
        
    }
    
    func scrollImage() {
        
        pageViewController.setViewControllers([controllers[currentIndex]], direction: .Forward, animated: true, completion: nil)
        pageControl.currentPage = currentIndex
        
        currentIndex = (currentIndex + 1) % list_image.count
        
    }
    
    func resumeTimer() {
        
        if let timer = self.timer {
            timer.fireDate = NSDate.distantPast()
        }
        
    }
    
    func pauseTimer() {
        
        if let timer = self.timer {
            timer.fireDate = NSDate.distantFuture()
        }
        
    }
    
    func stopTimer() {
        
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    
    func startTimer() {
        
        if let timer = self.timer {
            timer.fireDate = NSDate.distantPast()
        } else {
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "scrollImage", userInfo: nil, repeats: true)
            self.timer.fireDate = NSDate.distantPast()
            
        }
        
//        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
//        var currentIndex = currentIndex
//        
//        dispatch_source_set_timer(self.timer, DISPATCH_TIME_FOREVER, 1 * NSEC_PER_SEC, 0)
//        dispatch_source_set_event_handler(self.timer) { () -> Void in
//            
//            currentIndex = (currentIndex + 1) % self.list_image.count
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.pageViewController.setViewControllers([self.controllers[currentIndex]], direction: .Forward, animated: true, completion: nil)
//            })
//            
//        }
//        
//        dispatch_resume(timer)
        
    }
    
    // MARK: - Private Func
    
    private func zoomRectForScale(scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect{
        
        var zoomRect: CGRect = CGRect()
        
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2
        zoomRect.origin.y = center.y - zoomRect.size.height / 2
        
        // 防止越界
        if zoomRect.origin.x + zoomRect.size.width > scrollView.frame.width {
            zoomRect.origin.x = scrollView.frame.width - zoomRect.size.width
        }
        
        if zoomRect.origin.x < self.view.frame.origin.x {
            zoomRect.origin.x = self.view.frame.origin.x
        }
        
        if zoomRect.origin.y + zoomRect.size.height > scrollView.frame.height {
            zoomRect.origin.y = scrollView.frame.height - zoomRect.size.height
        }
        
        if zoomRect.origin.y < self.view.frame.origin.y {
            zoomRect.origin.y = self.view.frame.origin.y
        }
        
        return zoomRect
        
    }
    
    /** 重绘图片 */
    private func resizeImage(var image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.drawInRect(CGRect(x: 0, y: 0, width: width, height: height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func indexOfViewController(controller: UIViewController) -> Int {
        
        let index = controllers.indexOf(controller)
        
        if index == nil {
            return NSNotFound
        }
        
        return index!
        
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        
        return controllers[index]
        
    }

    // MARK: - Configure
    
    private func configureImage(image: UIImage, imageView: UIImageView) {
        
        let width_imageView = imageView.frame.width
        let height_imageView = imageView.frame.height
        let width_image = image.size.width
        let heigth_image = image.size.height
        var radio: CGFloat = 1.0
        // 图尺寸比设定区域大
        if width_image > width_imageView && heigth_image > height_imageView {
            // 宽比高大
            if width_image > heigth_image {
                
                radio = width_image / width_imageView
                imageView.contentMode = .ScaleAspectFill 
                
            } else if heigth_image > width_image {
                
                radio = heigth_image / height_imageView
                imageView.contentMode = .ScaleAspectFit
                
            }
            
            resizeImage(image, width: width_image / radio, height: heigth_image / radio)
            
            list_isLongPicture.append(false)
            
        } else if width_image >= width_imageView {
            
            imageView.contentMode = .ScaleAspectFit
            
            list_isLongPicture.append(false)
            
        } else if heigth_image == height_imageView {
         
            imageView.contentMode = .ScaleAspectFill
            
            list_isLongPicture.append(false)

        } else if heigth_image > height_imageView * (1 + CGFloat.min) {
            
            radio = heigth_image / height_imageView
            resizeImage(image, width: width_image / radio, height: heigth_image / radio)
            imageView.contentMode = .Center
            imageView.frame.size = CGSize(width: width_image / radio, height: heigth_image / radio)
            imageView.center.x = self.view.bounds.width / 2
            
            list_isLongPicture.append(true)
            
        } else {
            
            imageView.contentMode = .Center
            
            list_isLongPicture.append(false)
            
        }
        
    }
    
    private func configurePageControl() {
        
//        let pageControl = UIPageControl.appearance()
        
        print("size = \(self.view.frame.size)")
        
//        pageControl = UIPageControl(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 44, )
            pageControl = UIPageControl()
            pageControl.frame.size = CGSize(width: self.view.frame.width, height: 30)
        pageControl.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.size.height - 30)
        
        print("pageControl frame = \(pageControl.frame)")
        
        pageControl.numberOfPages = list_image.count
        pageControl.currentPage = currentIndex
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = pageColor
        pageControl.currentPageIndicatorTintColor = currentColor
        pageControl.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(pageControl)
        
    }
    
//    private func configureButton() {
//        
//        let btn_cutImage = UIButton(frame: CGRect(x: width_imageView - 100, y: height_imageView - 100, width: 100, height: 40))
//        
//        btn_cutImage.setTitle("截图", forState: .Normal)
//        btn_cutImage.addTarget(self, action: "cutImage", forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(btn_cutImage)
//        
//    }
    
    private func configurePageViewController() {
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        if self.imageType == .ImageTypePhotoWall {
            
            for (index, image) in EnumerateSequence(list_image) {
                
                let imageView = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
                let scrollView = UIScrollView(frame: self.view.bounds)
                let controller = UIViewController()
//                let singleTapGesture = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
//                let doubleTapGesture = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
                
//                doubleTapGesture.numberOfTapsRequired = 2
                
                //这行很关键，意思是只有当没有检测到doubleTapGesture 或者 检测doubleTapGesture失败，singleTapGesture才有效
//                singleTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
                
                imageView.clipsToBounds = true
                imageView.contentMode = .ScaleAspectFill
                imageView.userInteractionEnabled = true
                imageView.tag = ImgViewOriginTag + index
//                imgView.addGestureRecognizer(singleTapGesture)
//                imgView.addGestureRecognizer(doubleTapGesture)
                imageView.image = image
                configureImage(image, imageView: imageView)
                
                scrollView.frame = self.view.bounds
                scrollView.maximumZoomScale = 10.0
                scrollView.minimumZoomScale = 0.5
                scrollView.contentSize = imageView.frame.size
                scrollView.delegate = self
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                
                scrollView.addSubview(imageView)
                
                controller.view.addSubview(scrollView)
                
                controllers.append(controller)
                
            }
            
        } else {
            
            for (index, image) in EnumerateSequence(list_image) {
                
                let imageView = UIImageView(frame: self.view.bounds)
                let controller = UIViewController()
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapAction")
                
                imageView.clipsToBounds = true
                imageView.contentMode = .ScaleAspectFill
                imageView.userInteractionEnabled = true
                imageView.tag = ImgViewOriginTag + index
                imageView.addGestureRecognizer(tapGesture)
                imageView.image = image
                configureImage(image, imageView: imageView)
                
                controller.view.frame = self.view.bounds
                controller.view.addSubview(imageView)
                
                controllers.append(controller)
                
            }
            
        }
        
        self.pageViewController.view.frame = self.view.bounds
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.pageViewController.setViewControllers([controllers[currentIndex]], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view) // 这行不写的话会黑屏
        self.view.gestureRecognizers = pageViewController.gestureRecognizers
        
    }
   
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(self.timeInterval * 1000) * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
            
            self.startTimer()
            
        })
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
       
        stopTimer()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        let controller = viewControllerAtIndex(currentIndex)
        let imageView = controller?.view.subviews[0].subviews[0]
        
        return imageView
        
    }
    
    // 让图片居中
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        if let imageView = scrollView.subviews[0] as? UIImageView {
            
            if list_isLongPicture[imageView.tag - ImgViewOriginTag] {
                imageView.center.x = self.view.bounds.width / 2
            }
            
        }
        
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        if scale < 1.0 {
            scrollView.zoomScale = 1.0
        }
        
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    // 即将完成翻页
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        if let controller = pendingViewControllers.first {

            nextIndex = indexOfViewController(controller)
            
        }
        
    }
    
    // 已经完成翻页
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            if let controller = previousViewControllers.first,
                let scrollView = controller.view.subviews[0] as? UIScrollView {
                    scrollView.zoomScale = 1.0
            }
            
            currentIndex = nextIndex

        }
        
        nextIndex = 0 // 复位
        
        pageControl.currentPage = currentIndex
        
    }
    
    // MARK: - UIPageControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        if canCarousel {
            index = (index + 1) % list_image.count
        } else {
            index = index + 1
        }
        
        if index == controllers.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        if canCarousel {
            
            index = (index - 1 + list_image.count) % list_image.count
            
        } else {
            
            if index == 0 {
                return nil
            }
            
            index = index - 1
            
        }
        
        return viewControllerAtIndex(index)
        
    }
    
    
    // 这两个代理是用来配置pageControl的
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return list_image.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return currentIndex
//    }

}

