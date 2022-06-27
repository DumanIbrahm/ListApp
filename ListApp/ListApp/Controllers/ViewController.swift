//
//  ViewController.swift
//  ListApp
//
//  Created by İbrahim Duman on 27.06.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertController = UIAlertController()
   
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text=data[indexPath.row]
        return cell
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

        
    
