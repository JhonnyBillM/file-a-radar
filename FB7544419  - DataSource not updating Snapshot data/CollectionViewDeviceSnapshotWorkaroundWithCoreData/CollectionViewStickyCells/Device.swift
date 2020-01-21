//
//  Device.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/15/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Device: NSManagedObject {
  var icon: UIImage? {
    guard let systemIconName = systemIconName else { return nil }
    return UIImage(systemName: systemIconName)
  }
}
