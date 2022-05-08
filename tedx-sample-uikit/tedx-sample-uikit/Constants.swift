//
//  Constants.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 4/17/22.
//

import Foundation
import UIKit
import CoreData


struct Constants {
    
    struct Colors {
        static let bg: UIColor = UIColor(named: "bgColor") ?? UIColor.white
        static let text: UIColor = UIColor(named: "textColor") ?? UIColor.black
    }
    
}

struct CoreDataUtils {

    static var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveContext() -> Bool {
        do { try context.save() }
        catch {
            context.rollback()
            return false
        }
        return true
    }
    
    static func upsertSavedFont(name: String, favorited: Bool) -> Bool {
        if let font = fetchSavedFonts(name: name) {
            font.favorited = favorited
        } else {
            let newFont = SavedFont(context: context)
            newFont.fontName = name
            newFont.favorited = favorited
        }
        return saveContext()
    }
    
    static func fetchSavedFonts(name: String) -> SavedFont? {
        do {
            let request = SavedFont.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "fontName == %@", name)
            return try context.fetch(request).first
        } catch {
            print("Error!")
            return nil
        }
    }
    
    static func fetchFavoritedFonts() -> [SavedFont]? {
        do {
            let request = SavedFont.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "favorited == true")
            return try context.fetch(request)
        } catch {
            print("Error!")
            return nil
        }
    }
    
}
