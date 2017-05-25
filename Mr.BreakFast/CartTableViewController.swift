//
//  CartTableViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/3/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class cartTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    
}

class CartTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var totalText: UILabel!
    @IBAction func placeOrder(_ sender: Any) {
        
        if(cartManagedObjects != nil) {
        let alertController = UIAlertController(title: "Are you Sure!", message: "you want to place the order ?. After clicking ok,  Please press command+L to get the order number", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            let content = UNMutableNotificationContent()
            content.title = "Sweet! Your Order has been placed Successfully."
            content.subtitle = "Your Order number is : \(arc4random_uniform(UInt32(self.limit)))."
            content.body = "You can collect at our nearest branch using your order number, the bill amount is \(self.total)."
            content.sound = UNNotificationSound.default()
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request)
            
            // adding data to history table
            
            let table = NSEntityDescription.entity(forEntityName: "History", in: self.context)
            
            self.historyManagedObjects = History(entity: table!, insertInto: self.context)
            
            self.nameStr = self.nameArr.joined(separator: ", ")
            self.historyManagedObjects.name = self.nameStr
            self.historyManagedObjects.quantity = String(self.quantityInt)
            self.historyManagedObjects.price = String(self.total)
            self.historyManagedObjects.time=self.date
            do{try self.context.save(); print("history data saved")
             self.deleteRecord()
             self.total = 0
             self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            catch{print("Core data not saved into history")}            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Alert!", message: "Please choose any item to buy from food menu", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
    var cartManagedObjects: Cart! = nil
    var bfManagedObjects: FoodMenu! = nil
    var historyManagedObjects: History! = nil
    var managedObjectContext: NSManagedObjectContext!

    var name: String = ""
    var quantity: String = ""
    var price: String = ""
    var total: Float = 0
    var priceVal: Float = 0
    var quantityVal: Float = 0
    var priceop: Float = 0
    var nameArr = [String]()
    var priceArr = [String]()
    var quantityArr = [String]()
    var quantityInt: Int = 0
    var temp: Int = 0
    
    let limit: UInt32 = 1000000
    let date = NSDate()
    var nameStr = String()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    // add to purchase list
    @IBAction func AddToPurchased(_ sender: Any) {
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        
        // have the entity open
        
        //create person object
        historyManagedObjects = History(entity: entity!, insertInto: context)
        
        // give the fields for this person

        historyManagedObjects.name = name
        historyManagedObjects.price = price
        historyManagedObjects.quantity = quantity
        
        let date = NSDate()
        //var dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-mm-yyyy"
        
        
        historyManagedObjects.time = date
        
        //cartManagedObjects.userid = "1"
        //cartManagedObjects.ingredients = ingradientsText.text
        //bfManagedObjects.image = imageText.text
        //let size = nameArr.count

        //save
        do{try context.save()}
        catch{print("CoreData Error: content does not saved")}
        
    }
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        // create a request for people table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
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
    
    func deleteRecord(){
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
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

        self.title = "Cart Items"
        tableView.backgroundView = UIImageView(image: UIImage(named: "cart"))

        //then make a action method :
        
        func action(sender:UIButton!) {
            print("Button Clicked")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! cartTableViewCell

        tableView.contentSize.height = 100
        if(historyManagedObjects == nil){
        // Configure the cell...
        cartManagedObjects = frc.object(at: indexPath) as! Cart
        
        //cell.nameText?.text = name
        name = cartManagedObjects.itemname!
        price = cartManagedObjects.itemprice!
        quantity = cartManagedObjects.itemquantity!
        nameArr.append(cartManagedObjects.itemname!)
        
        cell.nameText?.text = name
        cell.quantityText?.text = quantity
        
        //calculation to display price according to quantity
        priceVal = Float(price)!
        quantityVal = Float(quantity)!
        priceop = priceVal*quantityVal
        price = String(priceop)

        cell.priceText?.text = price
            
        // to the quantity
        temp = Int(quantity)!
        quantityInt = quantityInt + temp
        }
        // for total
        total += Float(price)!
        totalText.text = "Total:" + "€" + String(total)

        return cell
    }
    

    
    /*// Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cartManagedObjects = frc.object(at: indexPath) as! Cart
            context.delete(cartManagedObjects)
            do
            {
                try context.save()
            }
            catch{
                print("CoreData Error: content does not saved")
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
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editCartSegue"
        {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            cartManagedObjects = frc.object(at: indexPath!) as! Cart
            
            let destination = segue.destination as! UpdateViewController
            
            destination.cartManagedObjects = cartManagedObjects
        }
        
    }
    

}
