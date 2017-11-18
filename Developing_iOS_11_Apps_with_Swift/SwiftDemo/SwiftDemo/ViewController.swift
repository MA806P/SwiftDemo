//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 2017/11/18.
//  Copyright © 2017年 MYZ. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let dataArray = ["Concentration"]
    
    
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
            
            self.navigationController?.present(ConcentrationController(), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.tableView.register(UINib.init(nibName: "RowCell", bundle: nil), forCellReuseIdentifier: "RowCellIdentifier")
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "RowCellIdentifier")
    }

    


}

