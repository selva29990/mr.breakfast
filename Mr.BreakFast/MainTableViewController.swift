//
//  mainTableViewController.swift
//  mr.bf
//
//  Created by Selva Balaji on 3/24/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import UIKit
import CoreData

class itemsTableViewCell: UITableViewCell{

    //creating context, entities, managedObjects and frc
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var ingradeitentsText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    
    
    
}
class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bfManagedObjects : FoodMenu! = nil
    var cartManagedObjects: Cart! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    //make request and fetch data
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>
    {
        //create a request for bf table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodMenu")
        
        //sorter
        let sorter = NSSortDescriptor(key:"name", ascending:true)
        request.sortDescriptors = [sorter]
        
        // give a pridicate for query
        
        return request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mr.Breakfast"
        
        // background image with blue effect
        tableView.backgroundView = UIImageView(image: UIImage(named: "menu"))
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        //view.addSubview(blurView)
        self.tableView.backgroundView!.addSubview(blurView)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        navigationController?.navigationBar.isHidden = false

        
        //make frc and fetch the data
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{
            try
                frc.performFetch()
        }
        catch{
            print("Core Data Error: FRC Cannot Perform Fetch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (frc.sections?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! itemsTableViewCell
        
        //get the managed object at indexpath from frc
        bfManagedObjects = frc.object(at: indexPath) as! FoodMenu
        
        //use the attributes to fill the cell
        //cell.textLabel?.text = bfManagedObjects.name
        //cell.detailTextLabel?.text = bfManagedObjects.ingredients
        //cell.imageView?.image =  UIImage(named: bfManagedObjects.image!)
        cell.nameText?.text = bfManagedObjects.name
        cell.ingradeitentsText?.text = bfManagedObjects.ingredients
        cell.priceText?.text = bfManagedObjects.price
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(bfManagedObjects)
            do{
                try
                    context.save()
            }
            catch {
                print("CoreData Error: context data doesnt delete")}
        } else if editingStyle == .insert{
            
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

        if segue.identifier == "menuCartSegue"
        {
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
        
        if segue.identifier == "addSegue"
        {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            //get from context the object at index path
            bfManagedObjects = frc.object(at: indexPath!) as! FoodMenu
            
            // get destination controller
            let destination = segue.destination as! ItemsViewController
            
            
            //puhdata
            destination.bfManagedObjects = bfManagedObjects
            
        }
        
    }
    
    
}
