//
//  PhotosViewController.swift
//  InstagramLab
//
//  Created by VietCas on 3/9/16.
//  Copyright © 2016 com.hoangphuong. All rights reserved.
//

import UIKit
import AFNetworking


class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageData: NSArray = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: "refreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
        loadData(false)
 
        
    }
    
    
    func refreshHandler(refreshControl: UIRefreshControl) {
        
        loadData(true)
        
    }
    
    
    func loadData(isRefreshAction:Bool) {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.imageData = responseDictionary["data"] as! NSArray
                            
                            self.tableView.reloadData()
                            
                            
                            if isRefreshAction {
                                self.refreshControl.endRefreshing()
                            }
                            
                            
                    }
                }
        });
        task.resume()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)! as NSIndexPath
        
        
        vc.photoUrl = getUrlFromIndex(indexPath.row)
        
    }
    
    
    
    
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell") as! ImageViewCell
        
        
        
        let urlStr = getUrlFromIndex(indexPath.section)
        
        let url = NSURL(string: urlStr)
        cell.profileView.setImageWithURL(url!)
        
        print(urlStr)
        return cell
        
    }
    
    func getUrlFromIndex(index:Int) -> String{
        let rowInfo = imageData[index] as! NSDictionary
        
        let urlStr = (rowInfo["images"]!["low_resolution"] as! NSDictionary) ["url"] as! String
        
        return urlStr
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return imageData.count
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y:10, width: 30, height: 30))
        
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.9).CGColor
        profileView.layer.borderWidth = 1
        
        headerView.addSubview(profileView)
        
        return headerView
        
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
        
    }

}
