//
//  MainTableViewController.swift
//  NBG
//
//  Created by David Chadranyan on 10/5/15.
//  Copyright © 2015 David Chadranyan. All rights reserved.
//

import UIKit
import Kanna




class MainTableViewController: UITableViewController , NSXMLParserDelegate ,UISearchResultsUpdating{
    
    
    var rateArray = [CurrencyRate]()
    
    var filteredRateArray = [CurrencyRate]()
    
    var searchController = UISearchController()
    
    var elementName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "type code, example : usd "
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        
        loadData()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // load XML Data
    
    func loadData()
    {
        let parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://www.nbg.ge/rss.php"))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (elementName != nil && elementName == "description" && string.containsString("table"))
        {
            if let doc = Kanna.HTML(html: string, encoding: NSUTF8StringEncoding)
            {
                for tr in doc.css("tr")
                {
                    let tdList = tr.css("td")
                    
                    let rateObj = CurrencyRate()
                    rateObj.currencyCode = tdList[0].text
                    rateObj.currencyName = tdList[1].text
                    rateObj.currencyRate = tdList[2].text
                    rateObj.currencyRateChangeValue = tdList[4].text
                    
                    if tdList[3].toHTML!.containsString("green")
                    {
                        rateObj.increase = true
                    }
                    else
                    {
                        rateObj.increase = false
                    }
                    
                    rateArray.append(rateObj)
                    
                }
            }
        }
        
        
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementName = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.elementName = nil
        
    }
    
    
    
    // Search Controller
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredRateArray.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "currencyCode CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (rateArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredRateArray = array as! [CurrencyRate]
        
        tableView.reloadData()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active
        {
            return filteredRateArray.count
        }
        else
        {
            return rateArray.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)  as! MainTableViewCell

        let rate : CurrencyRate
        if searchController.active
        {
             rate = filteredRateArray[indexPath.row]
        }else
        {
             rate = rateArray[indexPath.row]
        }
        
        cell.rateNameTextView?.text = rate.currencyName
        cell.currencyRateLabel?.text = rate.currencyRate
        cell.rateChangeValue?.text = rate.currencyRateChangeValue
        
        if rate.increase!
        {
            cell.rateChangeValue.textColor = UIColor.init(red: 0, green: 180/255, blue: 0, alpha: 1)
        }
        else
        {
            cell.rateChangeValue.textColor = UIColor.redColor()
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
