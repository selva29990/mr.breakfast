//
//  itemViewController.swift
//  mr.bf
//
//  Created by Selva Balaji on 3/24/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {
    
    
    //@IBOutlet weak var nameText: UITextField!
    //@IBOutlet weak var priceText: UITextField!
    //@IBOutlet weak var ingradientsText: UITextField!
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var ingradientsText: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    
    @IBAction func addOrUpdate(_ sender: Any) {
        if bfManagedObjects == nil {
            saveItem()
        } else {
            updateItem()
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // 2. core data elements
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  bfManagedObjects: FoodMenu! = nil
    
    //3.
    func saveItem() {
        // have the entity open
        let table = NSEntityDescription.entity(forEntityName: "FoodMenu", in: context)
        
        //create person object
        bfManagedObjects = FoodMenu(entity: table!, insertInto: context)
        
        // give the fields for this person
        bfManagedObjects.name = nameText.text
        bfManagedObjects.price = priceText.text
        bfManagedObjects.ingredients = ingradientsText.text
        //bfManagedObjects.image = imageText.text
        
        //save
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
        
        
    }
    
    //4. updating the details
    func updateItem() {
        
        // give the fields for this person
        bfManagedObjects.name = nameText.text
        bfManagedObjects.price = priceText.text
        bfManagedObjects.ingredients = ingradientsText.text
        //bfManagedObjects.image = imageText.text
        
        //save
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate text fields witht managed object data
        if bfManagedObjects != nil{
            nameText.text = bfManagedObjects.name
            priceText.text = bfManagedObjects.price
            ingradientsText.text = bfManagedObjects.ingredients
            itemImage.image = UIImage(named: bfManagedObjects.image!)
            //imageText.text = peopleManagedObject.image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
    }
    
    
}
