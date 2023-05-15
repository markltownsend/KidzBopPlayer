//
//  ViewController.swift
//  Kidz Bop Player
//
//  Created by Mark Townsend on 8/17/17.
//

import UIKit
import AppleMusicKit

class MainViewController: UITableViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppleMusicManager.shared.requestAuthorization(parentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

