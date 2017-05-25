//
//  UpdateViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/9/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData

class UpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var quantityText: UITextField!
    
    var cartManagedObjects: Cart! = nil
    var wishlistManagedObjects: Wishlist! = nil

    @IBAction func addToCart(_ sender: Any) {
        if(wishlistManagedObjects == nil){
            saveItem()
        }
        if(cartManagedObjects == nil) {
            //wishListSave()
            }
    }
    
    //variables
    var name: String = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //3. do we need to create new context for each save actions
    func saveItem() {
        
       // let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
       // cartManagedObjects = Cart(entity: entity!, insertInto: context)
        
        // give the fields for this person
        cartManagedObjects.itemname = nameText.text
        cartManagedObjects.itemprice = priceText.text
        cartManagedObjects.itemquantity = quantityText.text
        // validation for quantity
        if (cartManagedObjects.itemquantity == nil || cartManagedObjects.itemquantity == ""){
            let alertController = UIAlertController(title: "Alert!", message: "Please enter the quantity", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            cartManagedObjects.userid = "1"
            //save
            do{try (context.save())
                print("items saved")
                //alert message after saivng the data
                let alertController = UIAlertController(title: "Sweet!", message: "The Item \(name) has been successfully updated to the shopping cart", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            catch{print("CoreData Error: content does not saved")}
        }
    }

    func wishListSave() {
        
        // let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        // cartManagedObjects = Cart(entity: entity!, insertInto: context)
        
        // give the fields for this person
        wishlistManagedObjects.itemname = nameText.text
        wishlistManagedObjects.itemprice = priceText.text
        //cartManagedObjects.itemquantity = "1"
        // validation for quantity
        if (cartManagedObjects.itemquantity == nil || cartManagedObjects.itemquantity == ""){
            let alertController = UIAlertController(title: "Alert!", message: "Please enter the quantity", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            //cartManagedObjects.userid = "1"
            //save
            do{try (context.save())
                print("items saved")
                //alert message after saivng the data
                let alertController = UIAlertController(title: "Sweet!", message: "The Item \(name) has been successfully updated to the shopping cart", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            catch{print("CoreData Error: content does not saved")}
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(wishlistManagedObjects == nil){
            nameText.text = cartManagedObjects.itemname
            priceText.text = cartManagedObjects.itemprice
            //ingradientsText.text = bfManagedObjects.ingredients
            //itemImage.image = UIImage(named: bfManagedObjects.image!)
            //imageText.text = peopleManagedObject.image
            name =  cartManagedObjects.itemname!
            quantityText.text = cartManagedObjects.itemquantity
        }
        
        if(cartManagedObjects == nil){
            nameText.text = wishlistManagedObjects.itemname
            priceText.text = wishlistManagedObjects.itemprice
            quantityText.text = wishlistManagedObjects.ingredients
        }
        quantityText.delegate = self
        quantityText.keyboardType = UIKeyboardType.numberPad
        
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
