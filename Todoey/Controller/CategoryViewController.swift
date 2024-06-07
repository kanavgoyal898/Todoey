import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let defaults = UserDefaults()
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        defaults.setValue(Date(), forKey: "lastOpened")
        print("Category ViewController: \(defaults.value(forKey: "lastOpened") as! Date)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadCategories()
    }
    

    // MARK: - UITableViewDataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name

        return cell
    }
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }

    }
 
    //MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if let category = textField.text {
                
                let newCategory = Category(context: self.context)
                newCategory.name = category
                self.categories.append(newCategory)
                
                self.saveCategories()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func saveCategories() {
        self.tableView.reloadData()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
}
