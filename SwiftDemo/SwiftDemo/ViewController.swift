//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/3/4.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RowCellIdentifier", for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Calculator" : "Face View"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(CalculatorViewController(), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(FaceViewController(), animated: true)
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

