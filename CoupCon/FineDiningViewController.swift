//
//  FineDiningViewController.swift
//  CoupCon
//
//  Created by apple on 17/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class FineDiningViewController: UIViewController {
    var dealsDic: NSDictionary!
    
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var dealBackgroundImg: UIImageView!
    @IBOutlet weak var dealLogoImg: UIImageView!
    @IBOutlet weak var dealNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
     weak var currentViewController: UIViewController?
    
    @IBOutlet weak var backLbl: UIButton!
    @IBOutlet weak var pagerView: KIImagePager!
    @IBOutlet weak var likeButton: UIButton!
    var coverPageImagesList: NSMutableArray!

    override func viewDidLoad() {
        
        print(dealsDic)
        
        super.viewDidLoad()
        constructTheOfferReedemJson()
        self.aboutBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        // self.dealBackgroundImg.setImageWithURL(NSURL(string:(dealsDic.valueForKey("BackgroundImage_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        NSUserDefaults.standardUserDefaults().setObject(dealsDic.valueForKey("Image_URL"), forKey: "POPUP_LOGO")
        
        self.backLbl.setTitle(dealsDic.valueForKey("Name") as?String, forState: .Normal)
        
        let offersController : AboutUsViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as? AboutUsViewController)!
        offersController.offersDic = NSDictionary(dictionary: self.dealsDic)
        self.currentViewController = offersController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        self.view.backgroundColor = UIColor.whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FineDiningViewController.showPopUp(_:)), name: "ShowPopUp", object: nil)
        
        navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        self.imageViewAimations()
        
        self.likeButton.selected = CXDataService.sharedInstance.productIsAddedinList(CXAppConfig.resultString(dealsDic.valueForKey("id")!))
        
        //self.hideMapButton()
        
        self.mapBtn.hidden = true
    }
    
    
    func hideMapButton(){
        
       /* print(dealsDic.valueForKey("Latitude"))
      
        if (((dealsDic.valueForKey("") as? String)) != nil) {
            self.mapBtn.hidden = true

        }else{
            
        if ((dealsDic?.valueForKey("Latitude") as? [AnyObject]) != nil) {
            
        }else{
            self.mapBtn.hidden = false
            }
        }
        */
    }
    
    func imageViewAimations(){
        
       // var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerCall()), userInfo: nil, repeats: true)

        self.coverPageImagesList = NSMutableArray()
        let attachements: NSArray = dealsDic.valueForKey("Attachments") as! NSArray
        
        for imageDic in attachements {
            self.coverPageImagesList.addObject(imageDic.valueForKey("URL") as! String)
        }
        self.coverPageImagesList.addObject((dealsDic.valueForKey("BackgroundImage_URL") as?String)!)
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.checkWetherToToggleSlideshowTimer()
        self.pagerView.slideshowTimeInterval = 3
        self.pagerView.reloadData()
        
        
    }
    
    func timerCall(){
        
    }
    
    @IBAction func backBtnAction(sender: UIButton) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func showPopUp(notification: NSNotification){

        let popup = PopupController
            .create(self)
            .customize(
                [
                    .Animation(.SlideUp),
                    .Scrollable(false),
                    .Layout(.Center),
                    .BackgroundStyle(.BlackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
            }
            .didCloseHandler { _ in
        }
        let container = DemoPopupViewController2.instance()
        container.closeHandler = { _ in
            popup.dismiss()
            //print("pop up closed")
        }
        popup.show(container)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func constructTheOfferReedemJson(){
        /*
         json={"list"":[{"ProductName":"Tabla","ProductDescription":"description","ProductImage":"https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477488244540.png","OfferName":"25 off on lunch","ProductId":"196429","OfferId":"9876543210","MacId":"102716-BHJAFCFH"}]}&dt=CAMPAIGNS&category=Notifications&userId=20217&consumerEmail=cxsample@gmail.com
         
         */
        let jsonDic : NSMutableDictionary = NSMutableDictionary()
        jsonDic.setObject((dealsDic.valueForKey("Name") as?String)!, forKey: "ProductName")
        jsonDic.setObject(dealsDic.valueForKey("Image_URL")!, forKey: "productLogo")//productLogo
        jsonDic.setObject((dealsDic.valueForKey("BackgroundImage_URL") as?String)!, forKey: "ProductImage")
        jsonDic.setObject(CXAppConfig.sharedInstance.getTheUserData().macId, forKey: "MacId")
        
        CXAppConfig.sharedInstance.setRedeemDictionary(jsonDic)
        
        /*
        let jsonListArray : NSMutableArray = NSMutableArray()
        jsonListArray.addObject(jsonDic)
        
        let listDic : NSDictionary = NSDictionary(object: jsonListArray, forKey: "list")
        print(listDic)
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(listDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
        
        print(jsonStringFormat)
        
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"RedeemHistory","json":jsonStringFormat!,"dt":"CAMPAIGNS","category":"Notifications","userId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":"yernagulamahesh@gmail.com"]) { (responseDict) in
            print(responseDict)
            let string = responseDict.valueForKeyPath("myHashMap.status")
            print(string)
        }
 */
        
    }
    
    @IBAction func locationButtonAction(sender: AnyObject) {
        if ((dealsDic?.valueForKey("Latitude") as? [AnyObject]) != nil) {
            return;
        }else{
        }
        
//        let sourceLatitude = 17.4436
//        let sourceLongtitude = 78.4458
//        
        
        let destinationLatitude = Double(dealsDic.valueForKey("Latitude")! as! String)
        let destinationLongtitude = Double(dealsDic.valueForKey("Longitude")! as! String)
        let googleMapUrlString = String.localizedStringWithFormat("http://maps.google.com/?daddr=%f,%f", destinationLatitude!, destinationLongtitude!)
        UIApplication.sharedApplication().openURL(NSURL(string:
            googleMapUrlString)!)
        //saddr=%f,%f&
    }
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    
    
    @IBAction func offerButtonAction(sender: UIButton) {
        
        sender.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //mapBtn.backgroundColor = UIColor.lightGrayColor()
        self.aboutBtn.backgroundColor = UIColor.lightGrayColor()
        let offersController : OffersViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("OffersViewController") as? OffersViewController)!
        offersController.offersDic = NSDictionary(dictionary: self.dealsDic)
        offersController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.cycleFromViewController(self.currentViewController!, toViewController: offersController)
        self.currentViewController = offersController
        
    }
    
    @IBAction func aboutButtonAction(sender: UIButton) {
        
        sender.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //mapBtn.backgroundColor = UIColor.lightGrayColor()
        self.offerBtn.backgroundColor = UIColor.lightGrayColor()
        
        let newViewController : AboutUsViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as? AboutUsViewController)!
        newViewController.offersDic = NSDictionary(dictionary: self.dealsDic)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    @IBAction func mapButtonAction(sender: UIButton) {
        
        sender.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        aboutBtn.backgroundColor = UIColor.lightGrayColor()
        self.offerBtn.backgroundColor = UIColor.lightGrayColor()
        
        let newViewController : MapViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController)!
        if (dealsDic.valueForKey("Latitude")) != nil {
            newViewController.lat = Double(dealsDic.valueForKey("Latitude")! as! String)
            newViewController.lon =  Double(dealsDic.valueForKey("Longitude")! as! String)
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        }else{
            let alert = UIAlertController(title: "Alert!!!", message: "Sorry!!Location Not Available!!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                //self.navigationController?.popViewControllerAnimated(true)
                
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //dealsDic.valueForKey("BackgroundImage_URL") as?String)
        //Latitude, Longitude  lat = 17.3850
        // lon = 78.4867
        
    }
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }
    @IBAction func likeBtnAction(sender: AnyObject) {
        let button : UIButton = (sender as? UIButton)!
        LoadingView.show("Loading...", animated: true)
        let dealsDict : NSDictionary = self.dealsDic
        let productId = CXAppConfig.resultString(dealsDict.valueForKey("id")!)
        CXDataService.sharedInstance.productAddedToFavorites(productId, likeStatus: button.selected ? "-1":"1",product: dealsDict) { (responseDict) in
            button.selected = !button.selected
            LoadingView.hide()
        }
        
    }

    @IBAction func callBtnAction(sender: AnyObject) {
//        if primaryNumber != ""{
//             callNumber(primaryNumber!)
//        }
        
         var addressArray : NSMutableArray = NSMutableArray()
        
        if ((dealsDic?.valueForKey("PhoneNumber") as? [String]) != nil) {
            //Array
             addressArray  = NSMutableArray(array: (dealsDic?.valueForKey("PhoneNumber"))! as! NSArray)
        }else{
            //String
            if ((self.dealsDic.valueForKey("PhoneNumber")) != nil){
                let primaryNumber = self.dealsDic.valueForKeyPath("PhoneNumber") as! String!
                addressArray.addObject(primaryNumber)
            }
      
            
        }
        if addressArray.count == 0 {
            return
        }
        if addressArray.count == 1 {
            self.callNumber((addressArray.lastObject as? String)!)

        }else{
        let alert = UIAlertController(title: "Mobile", message: "Please Select Number", preferredStyle: .ActionSheet) // 1
        
        for item in addressArray {
            let firstAction = UIAlertAction(title: item as! String, style: .Default) { (alert: UIAlertAction!) -> Void in
                self.callNumber(alert.title!)
            } // 2
            alert.addAction(firstAction) // 4
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
        }
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion:nil)
        }
       // let actionSheetController: UIAlertController = UIAlertController(title: "Please select Phone Number", message: "Option to select", preferredStyle: .ActionSheet)

 
    }
    
    @IBAction func shareBtnAction(sender: AnyObject) {
        
        let description = "Coupcon"
        let url = self.dealsDic.valueForKey("publicURL") as? String
        //let encodedPublicUrl = String(UTF8String: url!.cStringUsingEncoding(NSUTF8StringEncoding)!)
        
        let encodedPublicUrl = url!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        print(encodedPublicUrl)
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [description,encodedPublicUrl], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    
    private func callNumber(phoneNumber:String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
    }
}

extension FineDiningViewController:KIImagePagerDelegate,KIImagePagerDataSource {
    
    //    }
    
    func contentModeForImage(image: UInt, inPager pager: KIImagePager!) -> UIViewContentMode {
        
        return .ScaleAspectFill
    }
    
    func arrayWithImages(pager: KIImagePager!) -> [AnyObject]! {
        return self.coverPageImagesList as [AnyObject]
    }
    
}

extension String {
    
    /// Returns a new string made from the `String` by replacing all characters not in the unreserved
    /// character set (As defined by RFC3986) with percent encoded characters.
    
    func stringByAddingPercentEncodingForURLQueryParameter(needsLove:String) -> String? {
        let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return safeURL
    }
    
}
