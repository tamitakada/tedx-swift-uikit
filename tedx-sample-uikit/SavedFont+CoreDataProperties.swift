//
//  SavedFont+CoreDataProperties.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 5/8/22.
//
//

import Foundation
import CoreData


extension SavedFont {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedFont> {
        return NSFetchRequest<SavedFont>(entityName: "SavedFont")
    }

    @NSManaged public var favorited: Bool
    @NSManaged public var fontName: String?

}

extension SavedFont : Identifiable {

}
