//
//  Medicine+CoreDataProperties.swift
//  dddavidkoProject
//
//  Created by Daria D on 10.12.2022.
//
//

import Foundation
import CoreData
import UIKit

extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var name: String?
    @NSManaged public var expires: Date?

}

extension Medicine : Identifiable {

}
