//
//  LaunchViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/10/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.animationImages = [
            UIImage(named:"update")!,
            UIImage(named:"item")!,
            UIImage(named:"menu")!,
            UIImage(named:"bg")!,
            UIImage(named:"cart")!
        ]
        
        imageView.animationDuration = 3
        imageView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
