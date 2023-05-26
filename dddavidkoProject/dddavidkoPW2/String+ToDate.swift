//
//  String+ToDate.swift
//  dddavidkoProject
//
//  Created by Daria D on 16.12.2022.
//

import Foundation

extension String {
    func toDate(style: Date.FormatStyle.DateStyle) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.date(from: self)
    }
}
