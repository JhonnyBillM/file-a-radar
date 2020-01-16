//
//  Device.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/15/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import Foundation
import UIKit

struct Device {
  var name: String
  var icon: UIImage
}

extension Device {
  /// Creates a Device object with the given name and a system symbol image.
  /// - Parameters:
  ///   - name: Device name.
  ///   - systemImageName: SF Symbol name.
  init?(name: String, systemImageName: String) {
    guard let image = UIImage(systemName: systemImageName) else { return nil }
    self.name = name
    self.icon = image
  }
}
