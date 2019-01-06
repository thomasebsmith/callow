//
//  DataManager.swift
//  Callow
//
//  Created by Thomas Smith on 9/12/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    // MARK: - Class Proprties
    private let persistentContainer : NSPersistentContainer
    
    private let itemName = "Item"
    private let titleKey = "title"
    private let dateKey = "date"
    private let descKey = "desc"
    
    private var updateListeners: [(_ day: Date) -> ()] = []
    
    // MARK: - Initializer
    init(_ container : NSPersistentContainer) {
        persistentContainer = container
    }
    
    // MARK: - Private Methods
    private func callUpdate(day: Date) {
        for listener in updateListeners {
            listener(day)
        }
    }
    
    private func saveData(_ possibleDay: Date?) -> Bool {
        let context = persistentContainer.viewContext
        do {
            try context.save()
            if let day = possibleDay {
                callUpdate(day: day)
            }
            return true
        }
        catch {
            print("Error saving to Core Data\n")
        }
        return false
    }
    
    // MARK: - Public Methods
    func addItem(title: String, date: Date, desc: String) -> Bool {
        let context = persistentContainer.viewContext
        let possibleEntity = NSEntityDescription.entity(forEntityName: itemName, in: context)
        if let entity = possibleEntity {
            let newItem = NSManagedObject(entity: entity, insertInto: context)
            newItem.setValue(title, forKey: titleKey)
            newItem.setValue(date, forKey: dateKey)
            newItem.setValue(desc, forKey: descKey)
            return saveData(date)
        }
        return false
    }
    
    func deleteItem(_ item: Item) -> Bool {
        let context = persistentContainer.viewContext
        let day = item.date
        context.delete(item)
        return saveData(day)
    }
    
    func getItemsForDay(day: Date) -> [Item] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: itemName)
        var result : [Item] = []
        do {
            let items = try context.fetch(request)
            for genericItem in items {
                if let item = genericItem as? Item {
                    if let date = item.date {
                        if Calendar.current.isDate(date, inSameDayAs: day) {
                            result.append(item)
                        }
                    }
                }
            }
        }
        catch {
            print("Error getting items for date \(day)\n")
        }
        return result
    }
    
    func hasEventsAfter(day: Date) -> Bool {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: itemName)
        do {
            let items = try context.fetch(request)
            for genericItem in items {
                if let item = genericItem as? Item {
                    if let date = item.date {
                        if Calendar.current.isDate(date, inSameDayAs: day) ||
                           date > day {
                            return true
                        }
                    }
                }
            }
        }
        catch {
            print("Error check for items after date \(day)\n")
        }
        return false
    }
    
    func onUpdate(_ callback: @escaping (_ day: Date) -> ()) {
        updateListeners.append(callback)
    }
}
