//
//  CoreDataStack.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/20/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  static var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DeviceModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      guard let error = error as NSError? else { return }
      fatalError("Unresolved error \(error), \(error.userInfo)")
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
}
