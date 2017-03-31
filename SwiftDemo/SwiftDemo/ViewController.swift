//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/3/4.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let dataArray = ["Calculator", "Face View", "Cassini", "Test View"]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RowCellIdentifier", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(CalculatorViewController(), animated: true)
        } else if indexPath.row == 1 {
            let faceItSplitViewController = UIStoryboard.init(name: "FaceIt", bundle: nil).instantiateInitialViewController()!
            self.navigationController?.present(faceItSplitViewController, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let cassiniSplitViewController = UIStoryboard.init(name: "Cassini", bundle: nil).instantiateInitialViewController()!
            //self.navigationController?.pushViewController(splitViewController, animated: true)
            self.navigationController?.present(cassiniSplitViewController, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            self.navigationController?.pushViewController(UIStoryboard.init(name: "TestStoryboard", bundle: nil).instantiateInitialViewController()!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.tableView.register(UINib.init(nibName: "RowCell", bundle: nil), forCellReuseIdentifier: "RowCellIdentifier")
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "RowCellIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.title = "SwiftDemo"
    }


}

