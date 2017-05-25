//
//  itemViewController.swift
//  mr.bf
//
//  Created by Selva Balaji on 3/24/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UIViewController, UITextFieldDelegate{
    
    // outlets and actions
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var ingradientsText: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantityText: UITextField!

    //variables
    var name: String = ""
   
    var  bfManagedObjects: FoodMenu! = nil
    var  cartManagedObjects: Cart! = nil
    var  wishlistManagedObjects: Wishlist! = nil

  
    @IBAction func addToCart(_ sender: Any) {
        if cartManagedObjects == nil {
            saveItem()
        } else {
            updateItem()
            }
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.quantityText.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    @IBAction func addToWishlist(_ sender: Any) {
        
        // variables 
        // have the entity open
        let table = NSEntityDescription.entity(forEntityName: "Wishlist", in: context)
        
        //create person object
        wishlistManagedObjects = Wishlist(entity: table!, insertInto: context)
        
        // give the fields for this person
        wishlistManagedObjects.itemname = nameText.text
        wishlistManagedObjects.itemprice = priceText.text
        wishlistManagedObjects.itemimage = ""
        wishlistManagedObjects.ingredients = ingradientsText.text
        
        //cartManagedObjects.ingredients = ingradientsText.text
        //bfManagedObjects.image = imageText.text
        
        //save
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
    }
    
    
    // 2. core data elements
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //3. do we need to create new context for each save actions
    func saveItem() {

        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        cartManagedObjects = Cart(entity: entity!, insertInto: context)
        
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
                let alertController = UIAlertController(title: "Cool!", message: "The Item \(name) has been successfully added to the shopping cart", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            catch{print("CoreData Error: content does not saved")}
            }
        }
    
    //4. updating the details
    func updateItem() {
       
        // give the fields for this person
        cartManagedObjects.itemname = nameText.text
        cartManagedObjects.itemprice = priceText.text
        cartManagedObjects.itemquantity = quantityText.text
        cartManagedObjects.userid = "1"
        //cartManagedObjects.ingredients = ingradientsText.text
        //bfManagedObjects.image = imageText.text
        
        //save
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bg image with blur effect
        //tableView.backgroundView = UIImageView(image: UIImage(named: "menu"))
        
        /*let imageView = UIImageView(image: UIImage(named: "item"))
        imageView.frame = view.bounds
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imageView.bounds
        view.addSubview(blurredEffectView)*/
        
        // populate text fields witht managed object data
        if bfManagedObjects != nil{
            nameText.text = bfManagedObjects.name
            priceText.text = bfManagedObjects.price
            ingradientsText.text = bfManagedObjects.ingredients
            itemImage.image = UIImage(named: bfManagedObjects.image!)
            //imageText.text = peopleManagedObject.image
            name =  bfManagedObjects.name!

        }
        
        if cartManagedObjects != nil{
            nameText.text = cartManagedObjects.itemname
            priceText.text = cartManagedObjects.itemprice
            //ingradientsText.text = bfManagedObjects.ingredients
            //itemImage.image = UIImage(named: bfManagedObjects.image!)
            //imageText.text = peopleManagedObject.image
            name =  cartManagedObjects.itemname!

        }
        quantityText.delegate = self
        quantityText.keyboardType = UIKeyboardType.numberPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet(charactersIn: "123456789").inverted
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "testSegue" {
            if(cartManagedObjects != nil){
                let controller = segue.destination as! CartTableViewController
                controller.cartManagedObjects = cartManagedObjects
            }else{
                let alertController = UIAlertController(title: "Cart is empty!", message: "please add some item to cart to dsiplay", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        if segue.identifier == "cartSegue"{
            let controller = segue.destination as! CartTableViewController
            controller.cartManagedObjects = cartManagedObjects
            
        }
        if segue.identifier == "wishlistSegue"{
            let controller = segue.destination as! WishlistTableViewController
            controller.wishlistManagedObjects = wishlistManagedObjects
        }
    }
    
    
}
