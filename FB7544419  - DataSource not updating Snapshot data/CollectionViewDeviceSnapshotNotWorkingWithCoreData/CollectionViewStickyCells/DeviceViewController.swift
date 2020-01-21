//
//  DeviceViewController.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/12/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import UIKit
import CoreData

class DeviceViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<NSString, NSManagedObjectID>! = nil
  private var fetchResultsController: NSFetchedResultsController<Device>! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewHierarchy()
    configureDataSource()
    setUpFetchRequestController()
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
      cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: DeviceCollectionViewCell.reuseIdentifier,
          for: indexPath) as? DeviceCollectionViewCell
          else { fatalError("Could not dequeue DeviceCollectionViewCell") }
        
        cell.device = self.fetchResultsController.object(at: indexPath)
        return cell
    })
  }
  
  
  private func setUpFetchRequestController() {
    let request: NSFetchRequest<Device> = Device.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Device.name, ascending: true)]
    fetchResultsController = NSFetchedResultsController<Device>(
      fetchRequest: request,
      managedObjectContext: CoreDataStack.persistentContainer.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    fetchResultsController.delegate = self
    try? fetchResultsController.performFetch()
  }
}

// MARK: - UICollectionViewDelegate
extension DeviceViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
    fetchResultsController.object(at: indexPath).isFavorite.toggle()
    try? CoreDataStack.persistentContainer.viewContext.save()
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DeviceViewController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
    dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<NSString, NSManagedObjectID>, animatingDifferences: true)
  }
}
