 //
//  LeftViewController.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

 class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var leftTableview: UITableView!
    @IBOutlet weak var dpNameLbl: UILabel!
    
    let managedObjectContext:NSManagedObjectContext! = nil
    var previousSelectedIndex  : NSIndexPath = NSIndexPath()
    var nameArray = ["HOME","PROFILE & MEMBERSHIP","REDEEM & HISTORY","HOW TO USE","HELP","SIGN OUT"]
    var imageArray = ["HomeImage","Profile & membershipImage","sidePanelRedeem20","HowtoUseImage","Helpimage","PowerBtn"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        dispatch_async(dispatch_get_main_queue(), {
            let imageUrl = userProfileData.userPic
            if (imageUrl != ""){
                self.userImage.sd_setImageWithURL(NSURL(string: imageUrl!))
            }
        })
        self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage.layer.cornerRadius = 60
        self.userImage.layer.borderWidth = 5
        self.userImage.clipsToBounds = true
        
        self.dpNameLbl.text = userProfileData.firstName
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.leftTableview.registerNib(nib, forCellReuseIdentifier: "TableViewCell")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return nameArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.textLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
        
        leftTableview.allowsSelection = true
        
        //[cell setBackgroundColor:[UIColor clearColor]];
        cell .backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        leftTableview.separatorStyle = .None
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        leftTableview.rowHeight = 50
        return 50
        
    }
    /* if NSUserDefaults.standardUserDefaults().valueForKey("USER_ID") != nil{
     let orders = storyBoard.instantiateViewControllerWithIdentifier("ORDERS") as! OrdersViewController
     self.navigationController!.pushViewController(orders, animated: true)
     }else{
     let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
     self.navigationController!.pushViewController(signInViewCnt, animated: true)
     }*/
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let revealController : SWRevealViewController  = self.revealViewController()
        
        if indexPath == previousSelectedIndex {
            revealController.revealToggleAnimated(true)
            return
        }
        previousSelectedIndex = indexPath
        //self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let itemName : String =  nameArray[indexPath.row]
        if itemName == "HOME"{
            let homeView = storyBoard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            let navCntl = UINavigationController(rootViewController: homeView)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "PROFILE & MEMBERSHIP"{
            let aboutUs = storyBoard.instantiateViewControllerWithIdentifier("PROFILE_MEMBERSHIP") as! ProfileMembershipViewController
            let navCntl = UINavigationController(rootViewController: aboutUs)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "REDEEM & HISTORY"{
            let redeem = storyBoard.instantiateViewControllerWithIdentifier("REDEEM_HISTORY") as! ReedemViewController
            let navCntl = UINavigationController(rootViewController: redeem)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "HOW TO USE"{
            let howToUse = storyBoard.instantiateViewControllerWithIdentifier("HOW_TO_USE") as! HowToUseViewController
            let navCntl = UINavigationController(rootViewController: howToUse)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "HELP" {
            //            let wishlist = storyBoard.instantiateViewControllerWithIdentifier("WISHLIST") as! NowfloatWishlistViewController
            //            self.navController.pushViewController(wishlist, animated: true)
            
        }else if itemName == "SIGN OUT"{
            
            showAlertView("Are You Sure??", status: 1)
            
        }
        
    }
    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title: "CoupoCon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
                //Db Clear
                self.clearDbFiles()
                
                //Delete userID from nsuserdeafults
                NSUserDefaults.standardUserDefaults().removeObjectForKey("USERID")
                
                // for FB signout
                let appDelVar:AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
                // for Google signout
                GIDSignIn.sharedInstance().signOut()
                GIDSignIn.sharedInstance().disconnect()
                appDelVar.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
                //self.navigationController?.popViewControllerAnimated(true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearDbFiles(){
        
        let fileManager = NSFileManager.defaultManager()
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        
        do {
            let filePaths = try fileManager.contentsOfDirectoryAtPath("\(documentsUrl)")
            for filePath in filePaths {
                try fileManager.removeItemAtPath(NSTemporaryDirectory() + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
 }




extension LeftViewController{
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return.LightContent
    }
    
    func drawerControllerWillOpen(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = false;
    }
    
    func drawerControllerDidClose(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = true;
        
    }
}
