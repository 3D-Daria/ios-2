//
//  MedicineViewController+Alerts.swift
//  dddavidkoProject
//
//  Created by Daria D on 26.05.2023.
//

import UIKit

extension MedicineViewController {
    enum AlertType {
        case new, edit(Int)
    }
    
    func setupMedAlertController(type: AlertType) -> UIAlertController {
        let title: String
        switch type {
        case .new:
            title = NSLocalizedString("NEW_MED_ALERT_TITLE", comment: "")
        case .edit(_):
            title = NSLocalizedString("EDIT_MED_ALERT_TITLE", comment: "")
        }
        let alertController = UIAlertController(title: title, message: NSLocalizedString("ALERT_MESSAGE", comment: ""), preferredStyle: .alert)
        alertController.addTextField{
            (textField) in
            switch type {
            case .new:
                textField.placeholder = NSLocalizedString("ALERT_NAME_FIELD_PH", comment: "")
            case .edit(let index):
                textField.text = self.meds[index].name
            }
        }
        alertController.addTextField{
            (textField) in
            self.dateInputTextField = textField
            textField.inputView = self.datePicker
            switch type {
            case .new:
                textField.placeholder = NSLocalizedString("ALERT_EXPIRY_FIELD_PH", comment: "")
            case .edit(let index):
                textField.text = self.meds[index].expires?.formatted(date: .numeric, time: .omitted)
                self.datePicker.date = self.meds[index].expires ?? .now
            }
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
            let nameTextfield = alertController?.textFields![0]
            guard let name = nameTextfield?.text else {
                return
            }
            
            if name != "" && self.date != nil {
                switch type {
                case .new:
                    self.addNewMed(name: name, date: self.date)
                case .edit(let index):
                    self.editMed(newName: name, date: self.date, at: index)
                }
                
                self.meds = self.meds.sorted(by: { $0.name ?? "" < $1.name ?? "" })
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON", comment: ""), style: .cancel, handler: nil))
        
        return alertController
    }
    
    private func addNewMed(name: String, date: Date?) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newMed = Medicine(context: managedContext)
        newMed.setValue(name, forKey: #keyPath(Medicine.name))
        newMed.setValue(self.date, forKey: #keyPath(Medicine.expires))
        self.meds.append(newMed)
    }
    
    private func editMed(newName: String, date: Date?, at index: Int) {
        meds[index].setValue(newName, forKey: #keyPath(Medicine.name))
        meds[index].setValue(date, forKey: #keyPath(Medicine.expires))
        meds[index].name = newName
        meds[index].expires = date
    }
}
