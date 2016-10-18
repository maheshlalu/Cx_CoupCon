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
    
    @IBOutlet weak var dealBackgroundImg: UIImageView!
    @IBOutlet weak var dealLogoImg: UIImageView!
    @IBOutlet weak var dealNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
     weak var currentViewController: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dealBackgroundImg.setImageWithURL(NSURL(string:(dealsDic.valueForKey("BackgroundImage_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        self.dealLogoImg.setImageWithURL(NSURL(string:(dealsDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        self.dealNameLbl.text = dealsDic.valueForKey("Name") as?String
        print(dealsDic.valueForKey("BackgroundImage_URL") as?String)
        
        //Background Image_URL
        //Image_URL
        //Name
        
        // Do any additional setup after loading the view.
        
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func offerButtonAction(sender: AnyObject) {
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OffersViewController")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
        
        
    }
    
    @IBOutlet weak var offerButtonAction: UIButton!
    @IBAction func aboutButtonAction(sender: AnyObject) {
        
        
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    @IBAction func mapButtonAction(sender: AnyObject) {
        
        let newViewController : MapViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController)!
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
        newViewController.lat = dealsDic.valueForKey("Latitude") as?Double
        newViewController.lon = dealsDic.valueForKey("Longitude") as?Double
        self.currentViewController = newViewController
        //dealsDic.valueForKey("BackgroundImage_URL") as?String)
        //Latitude, Longitude
        
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
}