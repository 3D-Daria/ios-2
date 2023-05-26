//
//  MedicineCell.swift
//  dddavidkoProject
//
//  Created by Daria D on 9.12.2022.
//

import UIKit

final class MedicineCell: UITableViewCell {
    let nameLabel: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        control.textAlignment = .left
        control.textColor = .black
        return control
    }()
    
    let expiryDateLabel: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 16, weight: .light)
        control.textAlignment = .right
        control.textColor = .green
        return control
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        addSubview(nameLabel)
        addSubview(expiryDateLabel)
        
        nameLabel.pinLeft(to: self, 10)
        nameLabel.pinTop(to: self, 10)
        expiryDateLabel.pinRight(to: self, 10)
        expiryDateLabel.pinTop(to: self, 10)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
}
