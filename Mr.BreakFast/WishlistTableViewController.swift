//
//  wishlistTableViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/3/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData

class wishlistTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
   
}

class WishlistTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var  wishlistManagedObjects: Wishlist! = nil
    var cartManagedObjects: Cart! = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    @IBAction func clearData(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you Sure!", message: "you want to wipe all the Wishlist records ?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            //delete the records
            self.deleteRecord()
            // save the changes
            do{try self.context.save()}
            catch{print("CoreData Error: content does not saved")}
            //go back to home screen
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    // 2. functions
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        // create a request for people table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Wishlist")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "itemname", ascending: true)
        request.sortDescriptors = [sorter]
        
        // give a pridicate for query
        //let predicate =  NSPredicate(format: "%K >= %@", "name", "selva")
        //request.predicate = predicate
        
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // function to remove all the records
    func deleteRecord(){
        print("Into delete method")
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Wishlist")
        
        if let result = try? context.fetch(fetchReq) {
            for item in result{
                context.delete(item as! NSManagedObject)
            }
        }
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
        tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wishlist Items"
        tableView.backgroundView = UIImageView(image: UIImage(named: "wishlistimage"))

        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do { try frc.performFetch() }
        catch { print("Core Data Error !! frc cannot perform fetch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (frc.sections?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistCell", for: indexPath) as! wishlistTableViewCell
        
        // Configure the cell...
        wishlistManagedObjects = frc.object(at: indexPath) as! Wishlist
        
        cell.nameText?.text = wishlistManagedObjects.itemname
        cell.priceText?.text = wishlistManagedObjects.itemprice
        //cell.quantityText?.text = wishlistManagedObjects.itemquantity
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            wishlistManagedObjects = frc.object(at: indexPath) as! Wishlist
            context.delete(wishlistManagedObjects)
            do
            {
                try context.save()
            }
            catch{
                
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
        
        if segue.identifier == "wishCartSegue"{
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
    }
    
}
