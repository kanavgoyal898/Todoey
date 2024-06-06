import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var defaults = UserDefaults.standard
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        defaults.set(Date(), forKey: "lastOpened")
        print(defaults.object(forKey: "lastOpened") as! Date)
    }
  
//MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
  //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let item = textField.text {
                
                let newItem = Item(context: self.context)
                newItem.title = item
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { alterTextField in
            alterTextField.placeholder = "ToDoey Item"
            textField = alterTextField
        }
        
        present(alert, animated: true)
    }
    
    func saveItems() {
        self.tableView.reloadData()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", (searchBar.text ?? ""))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty ?? false) {
            self.loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", (searchBar.text ?? ""))
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }
    }
    
}
