//
//  TweetTableViewController.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/4/17.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    private var tweets = [Array<Twitter.Tweet>]()
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    
    }
    
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private func searchForTweets() {
    
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing()
                }
                
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //we use the row height in the storyboard as an "estimate"
        tableView.estimatedRowHeight = tableView.rowHeight
        //but use whatever autolayout says the height should be as the actual row height
        tableView.rowHeight = UITableViewAutomaticDimension
        // the row height could alternatively be set
        // using the UITableViewDelegate method heightForRowAt
        
        searchText = "123"
    }
    
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }

    
    // MARK: Search Text Field
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetIdentifier", for: indexPath)

        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet;
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }

}
