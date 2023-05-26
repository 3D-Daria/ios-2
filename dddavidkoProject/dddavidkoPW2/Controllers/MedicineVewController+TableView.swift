//
//  MedicineVewController+TableView.swift
//  dddavidkoProject
//
//  Created by Daria D on 26.05.2023.
//

import UIKit

extension MedicineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return meds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MedicineCell
        let currentMed = meds[indexPath.section]
        cell.nameLabel.text = currentMed.name
        
        cell.expiryDateLabel.text = DateFormatter.localizedString(from: currentMed.expires ?? Date.now, dateStyle: .medium, timeStyle: .none)
        changeExpiryDateLabelColor(label: cell.expiryDateLabel, expiryDate: currentMed.expires)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    private func changeExpiryDateLabelColor(label: UILabel, expiryDate: Date?) {
        guard let expiryDate = expiryDate else { return }
        if expiryDate <= Date.now{
            label.textColor = .red
        } else {
            guard let daysLeft = Calendar.current.dateComponents([.day], from: Date.now, to: expiryDate).day else { return }
            guard let monthsLeft = Calendar.current.dateComponents([.month], from: Date.now, to: expiryDate).month else { return }
            if daysLeft < 7 {
                label.textColor = .orange
            } else if monthsLeft < 1 {
                label.textColor = .systemYellow
            } else {
                label.textColor = .systemGreen
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        let editMedAlertController = setupMedAlertController(type: .edit(indexPath.section))
        activateDatePicker()
        self.present(editMedAlertController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.meds[indexPath.section])
            meds.remove(at: indexPath.section)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .left)
            tableView.endUpdates()
        }
    }
}
