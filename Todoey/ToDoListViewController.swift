import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Harvey Specter", "Loius Litt", "Donna Paulson"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
//MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item
        return cell
    }
    
  //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if var item = textField.text {
                self.itemArray.append(item)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { alterTextField in
            alterTextField.placeholder = "ToDoey Item"
            textField = alterTextField
        }
        
        present(alert, animated: true)
    }
}

