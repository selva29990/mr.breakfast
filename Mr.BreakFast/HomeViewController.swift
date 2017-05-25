//
//  HomeViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/8/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var bgView: UIImageView!
    //@IBOutlet weak var home: UIImageView!
    //@IBOutlet weak var home: UIButton!
    @IBOutlet weak var home: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyMotionEffect(toView: bgView)
        applyMotionEffect(toView: home)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func applyMotionEffect(toView view: UIView){
        
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        print("code here")
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.minimumRelativeValue = max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
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
