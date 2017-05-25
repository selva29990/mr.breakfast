//
//  HistoryTableViewController.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/9/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData


class historyTableViewCell: UITableViewCell{
    
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var purDate: UILabel!
    
    //@IBOutlet weak var purchasedDate: UILabel!
    
}


class HistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var date = NSDate()
    var price: Float = 0
    var temp: Float = 0
    
    @IBOutlet weak var totalText: UILabel!
    
    @IBAction func clearAll(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you Sure!", message: "you want to wipe all the history records ?", preferredStyle: UIAlertControllerStyle.alert)
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
    
    var  cartManagedObjects: Cart! = nil
    var historyManagedObjects: History! = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil

    // 2. functions to fetch the data and reload
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        // create a request for people table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "name", ascending: true)
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
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
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

        self.title = "Purchased History"
        tableView.backgroundView = UIImageView(image: UIImage(named: "history"))

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyTableViewCell

        // Configure the cell...
        historyManagedObjects = frc.object(at: indexPath) as! History

        cell.nameText?.text = historyManagedObjects.name
        cell.priceText?.text = historyManagedObjects.price
        cell.quantityText?.text = historyManagedObjects.quantity
        cell.purDate?.text = String(describing: historyManagedObjects.time!)

        temp = Float(historyManagedObjects.price!)!
        price += temp
        
        totalText.text = "Total Spending :" + "€" + String(price)

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
            // Delete the row from the data source
            historyManagedObjects  = frc.object(at: indexPath) as! History
            context.delete(historyManagedObjects)
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
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "purCartSegue" {
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
