//
//  DeviceViewController.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/12/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import UIKit

/// ViewController that hosts a CollectionView with reordering capabilities.
class DeviceViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  private var longPressRecognizer: UILongPressGestureRecognizer!
  
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
    longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handle(gesture:)))
    longPressRecognizer.minimumPressDuration = 0.3
    collectionView.addGestureRecognizer(longPressRecognizer)
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
  
  @objc func handle(gesture: UILongPressGestureRecognizer) {
    let location = gesture.location(in: collectionView)
    
    switch gesture.state {
    case .began:
      guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
      collectionView.beginInteractiveMovementForItem(at: indexPath)
    case .changed:
      collectionView.updateInteractiveMovementTargetPosition(location)
    case .ended:
      collectionView.endInteractiveMovement()
    case .cancelled, .failed, .possible:
      collectionView.cancelInteractiveMovement()
    @unknown default:
      collectionView.cancelInteractiveMovement()
    }
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
  
  // Adding support for reordering.
  // This API is producing a "sticky" behavior when a cell is dragged thru its original position.
  // Use the Drag & Drop API to work around this issue.
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {
    devices.insert(devices.remove(at: source.item), at: destination.item)
  }
  
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}
