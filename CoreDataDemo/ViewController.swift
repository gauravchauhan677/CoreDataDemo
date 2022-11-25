//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by GauravChauhan677 on 20/11/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items:[Person]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bar Items"
        view.backgroundColor = .systemPink
       // navigationController?.navigationBar.backgroundColor = UIColor.green
        
        //Get Items from coreData
        fetchPeople()
        
    }
    
    func fetchPeople() {
        //Fetch the data from coredata to display in tableview.
        do{
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //set the filtering and sorting on the request
//            let pred = NSPredicate(format: "name CONTAINS[cd] %@", "ted")
//            request.predicate = pred
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }

        
    }

    @IBAction func addTapped(_ sender: Any) {
        //create Alert
        let alert = UIAlertController(title: "Add Person", message: "What is thier name?", preferredStyle: .alert)
        alert.addTextField()
        
        //configure button handle
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action)  in
            
            //Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Create a person object.
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            //TODO: Save the data.
            do {
                try self.context.save()
            } catch {
                
            }
            
            //TOdo: refetch the data
            self.fetchPeople()
            
        }
        // Add button
        alert.addAction(submitButton)
        
        //show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  return the number of people
        return self.items?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        //Get the person from array and set the label
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Selected Person
        let person = self.items![indexPath.row]
        
        //Create a alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        //Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            //Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            //TODO: Edit name property of person object
            person.name = textfield.text
            
            //TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            //TODO: refetch the Data
            self.fetchPeople()
            
        }
        //Add button
        alert.addAction(saveButton)
        
        //Show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // create a swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //TODO: Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //TODO: Remove the person
            self.context.delete(personToRemove)
            
            //TODO: save the data
            do {
                try self.context.save()
                
            } catch {
                
            }
            //TODO: refetch the data
            self.fetchPeople()
            
        }
        // return swipe action
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    
    
}
