//
//  DeviceViewController.swift
//  WrongDroppingLocation
//
//  Created by Jhonny Mena on 1/12/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import UIKit

/// ViewController that hosts a CollectionView with reordering capabilities.
class DeviceViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  
  private var devices: [Device] = [
    Device(name: "Speaker", systemImageName: "hifispeaker.fill")!,
    Device(name: "Computer", systemImageName: "desktopcomputer")!,
    Device(name: "Game Controller", systemImageName: "gamecontroller.fill")!,
    Device(name: "Headphones", systemImageName: "headphones")!,
    Device(name: "Printer", systemImageName: "printer.fill")!,
    Device(name: "TV", systemImageName: "tv.fill")!,
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewHierarchy()
  }
  
  private func configureViewHierarchy() {
    collectionView = UICollectionView(
      frame: view.frame,
      collectionViewLayout: createListLayout()
    )
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.contentInsetAdjustmentBehavior = .always
    collectionView.dragInteractionEnabled = true
    collectionView.reorderingCadence = .immediate
    collectionView.dataSource = self
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      DeviceCollectionViewCell.self,
      forCellWithReuseIdentifier: DeviceCollectionViewCell.reuseIdentifier
    )
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    ])
  }
  
  private func createListLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(80)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 10
    section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - UICollectionViewDataSource
extension DeviceViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return devices.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(
        withReuseIdentifier: DeviceCollectionViewCell.reuseIdentifier,
        for: indexPath
      ) as? DeviceCollectionViewCell
      else { fatalError("Could not dequeue DeviceCollectionViewCell") }
    
    cell.device = devices[indexPath.row]
    return cell
  }
}


// MARK: - UICollectionViewDragDelegate
extension DeviceViewController: UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let device = devices[indexPath.item]
    let fuelProvider = NSItemProvider(object: NSString(string: device.name))
    let dragItem = UIDragItem(itemProvider: fuelProvider)
    dragItem.localObject = device
    return [dragItem]
  }
}


// MARK: - UICollectionViewDropDelegate
extension DeviceViewController: UICollectionViewDropDelegate {
  
  /// Delimits the inactive zone where the CollectionView should not accept drops.
  private var inactiveZoneIndex: Int { return 4 }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    guard collectionView.hasActiveDrag else {
      return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    // MARK: - Bug: destinationIndexPath just returns the item's sourceIndexPath.
    // Ensure drops occurs within the active zone.
    if let destinationIndex = destinationIndexPath?.item,
      destinationIndex >= inactiveZoneIndex {
      return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    // MARK: - Workaround
    //         uncomment the code from line 139 to line 151 and comment the code from line 125 to line 132.
    
    // To workaround this bug we get the session's current position
    // in the collectionView's coordinate system, and then get the indexPath given that location.
    
    /*
    var __destinationIndexPath: IndexPath? = nil
    let location = session.location(in: collectionView)
    collectionView.performUsingPresentationValues {
      __destinationIndexPath = collectionView.indexPathForItem(at: location)
    }
    
    // Ensure drops occurs within the active zone.
    if let __destinationIndexPath = __destinationIndexPath,
      __destinationIndexPath.item >= inactiveZoneIndex {
      return UICollectionViewDropProposal(operation: .forbidden)
    }
    */
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
    
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard coordinator.proposal.operation == .move else { return }
    guard coordinator.items.count == 1 else { return }
    guard let dragItem = coordinator.items.first?.dragItem else { return }
    guard let dragDevice = dragItem.localObject as? Device else { return }
    guard let sourceIndexPath = coordinator.items.first?.sourceIndexPath else { return }
    guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
    guard destinationIndexPath.item < inactiveZoneIndex else { return }
    
    collectionView.performBatchUpdates({
      self.devices.remove(at: sourceIndexPath.item)
      self.devices.insert(dragDevice, at: destinationIndexPath.item)
      
      collectionView.deleteItems(at: [sourceIndexPath])
      collectionView.insertItems(at: [destinationIndexPath])
    }, completion: nil)
    
    coordinator.drop(dragItem, toItemAt: destinationIndexPath)
  }
}
