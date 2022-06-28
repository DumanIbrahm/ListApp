//
//  ViewController.swift
//  ListApp
//
//  Created by İbrahim Duman on 27.06.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var alertController = UIAlertController()
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.fetch()
     
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender : UIBarButtonItem){
        presentAlert(title: "Uyarı",
                     message: "Bütün öğeleri silmek istediğinizden emin misiniz?",
                     defaultButtonTitle: "Evet",
                     cancelButtonTitle: "Vazgeç") { _ in
            // self.data.removeAll()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            for object in self.data{
                managedObjectContext?.delete(object)
            }
            try? managedObjectContext?.save()
            self.fetch()
        }
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: UIBarButtonItem){
        presentAddAlert()
    
}
        func presentAddAlert(){
            presentAlert(title: "Yeni Eleman Ekle",
                         message: nil,
                         defaultButtonTitle: "Ekle",
                         cancelButtonTitle: "Vazgeç",
                         isTextFieldAvailabe: true,
                         defaultButtonhandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != ""{
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ListItem",
                                                           in: managedObjectContext!)
                    let listItem = NSManagedObject(entity: entity!,
                                                          insertInto: managedObjectContext)
                    listItem.setValue(text, forKey: "title")
                    try? managedObjectContext?.save()
                    self.fetch()
                    
                }else{
                    self.presentWarningAlert()
                }
            })
            
        }
        func presentWarningAlert(){
            presentAlert(title:"Uyarı",
                         message:"Listeye Boş Eleman Ekleyemezsin!",
                         preferedStyle: UIAlertController.Style.alert,
                         cancelButtonTitle: "Tamam")
        }
        
            
            
    func presentAlert(title: String? ,
                      message:String? ,
                      preferedStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailabe: Bool = false,
                      defaultButtonhandler: ((UIAlertAction)-> Void)? = nil
                      ){
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        if defaultButtonTitle != nil{
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonhandler)
            alertController.addAction(defaultButton)
        }
        if isTextFieldAvailabe{
            alertController.addTextField()
        }
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { _, _, _ in
            self.presentAlert(title: "Elemanı Düzenle",
                         message: nil,
                         defaultButtonTitle: "Düzenle",
                         cancelButtonTitle: "Vazgeç",
                         isTextFieldAvailabe: true,
                         defaultButtonhandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != ""{
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    if managedObjectContext!.hasChanges{
                        try? managedObjectContext?.save()
                    }
                    self.tableView.reloadData()
                }else{
                    self.presentWarningAlert()
                }
            })
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return config
    }
}
    
