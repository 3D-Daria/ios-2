//
//  MedicineViewController.swift
//  dddavidkoProject
//
//  Created by Daria D on 9.12.2022.
//

import UIKit
import CoreData

final class MedicineViewController: UIViewController {
    var tableView: UITableView!
    
    let addButton: UIButton = {
        let control = UIButton()
        control.backgroundColor = .blue
        control.setTitle(NSLocalizedString("BUTTON_ADD", comment: ""), for: .normal)
        control.setTitleColor(.white, for: .normal)
        control.titleLabel?.textAlignment = .center
        control.layer.cornerRadius = 15
        control.layer.masksToBounds = true
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let titleLabel: UILabel = {
        let control = UILabel()
        control.text = NSLocalizedString("TITLE", comment: "")
        control.textAlignment = .left
        control.font = .systemFont(ofSize: 40, weight: .bold)
        control.textColor = .black
        return control
    }()
    
    let datePicker: UIDatePicker = {
        let control = UIDatePicker()
        control.datePickerMode = .date
        control.preferredDatePickerStyle = .wheels
        control.frame.size = CGSize(width: 0, height: 300)
        return control
    }()
    
    var dateInputTextField: UITextField!
    var date: Date?
    
    let cellId = "medCell"
    var meds = [Medicine]()
    let cellSpacingHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMeds()
        setupTableView()
        setupUI()
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    public func activateDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
    }
    
    private func getMeds() {
        let medFetch: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Medicine.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
            medFetch.sortDescriptors = [sortByName]
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                let results = try managedContext.fetch(medFetch)
                meds = results
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
    }
    
    @objc
    private func addButtonPressed() {
        let alertController = setupMedAlertController(type: .new)
        activateDatePicker()
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func dateChange(datePicker: UIDatePicker) {
        dateInputTextField.text = datePicker.date.formatted(date: .numeric, time: .omitted)
        date = datePicker.date
    }
    
    private func setupTableView() {
        let rect = CGRect(x: 10, y: 110, width: view.frame.width - 30, height: view.frame.height - 110 - 40)
        tableView = UITableView(frame: rect)
        tableView.register(MedicineCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .systemGray6
    }
    
    
    
    private func setupUI() {
        self.view.backgroundColor = .systemGray6
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(addButton)
        
        titleLabel.pinTop(to: self.view, 60)
        titleLabel.pinLeft(to: self.view, 10)
        
        addButton.pin(to: self.view, [.left: 24, .right: 24])
        addButton.pinBottom(to: self.view, 20)
    }
}
