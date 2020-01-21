//
//  DeviceViewController.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/12/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Int, Device>! = nil
  private var snapshot: NSDiffableDataSourceSnapshot<Int, Device>! = nil
  
  private var devices: [Device] = [
    Device(name: "Speaker", systemImageName: "hifispeaker.fill")!,
    Device(name: "Computer", systemImageName: "desktopcomputer", isFavorite: true)!,
    Device(name: "Game Controller", systemImageName: "gamecontroller.fill")!,
    Device(name: "Headphones", systemImageName: "headphones", isFavorite: true)!,
    Device(name: "Printer", systemImageName: "printer.fill")!,
    Device(name: "TV", systemImageName: "tv.fill")!,
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewHierarchy()
    configureDataSource()
    updateSnapshot()
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
    collectionView.delegate = self
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
  
  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, device) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: DeviceCollectionViewCell.reuseIdentifier,
          for: indexPath) as? DeviceCollectionViewCell
          else { fatalError("Could not dequeue DeviceCollectionViewCell") }
        
        cell.device = device
        return cell
    })
  }
  
  private func updateSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Int, Device>()
    snapshot.appendSections([0])
    snapshot.appendItems(devices, toSection: 0)
    dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
  }
}

// MARK: - UICollectionViewDelegate
extension DeviceViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
    devices[indexPath.row].isFavorite.toggle()
    updateSnapshot()
  }
}
