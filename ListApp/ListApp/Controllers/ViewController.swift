//
//  ViewController.swift
//  ListApp
//
//  Created by İbrahim Duman on 27.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertController = UIAlertController()
   
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender : UIBarButtonItem){
        presentAlert(title: "Uyarı",
                     message: "Bütün öğeleri silmek istediğinizden emin misiniz?",
                     defaultButtonTitle: "Evet",
                     cancelButtonTitle: "Vazgeç") { _ in
            self.data.removeAll()
            self.tableView.reloadData()
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
                    self.data.append((text)!)
                    self.tableView.reloadData()
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text=data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            self.data.remove(at: indexPath.row)
            self.tableView.reloadData()
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
                    self.data[indexPath.row] = text!
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
    
