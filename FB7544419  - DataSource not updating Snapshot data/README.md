## DiffableDataSource does not updates cells when FetchedResultsController updates their objects

http://openradar.appspot.com/7544419

### Demo

See [Actual Results](#Actual-Results) and [Expected Results](#Expected-Results) sections.

### Summary
When implementing a CollectionView using UICollectionViewDiffableDataSource and CoreData’s NSFetchedResultsController the cells does not get updated if the change is an update, that means that the cells only gets updated if the change is an insert/delete/move operation.

### Steps to Reproduce
1. Implement a CollectionView using UICollectionViewDiffableDataSource.

2. Implement a fetchResultsController, and set the delegate to the current ViewController.

3. Implement the NSFetchedResultsControllerDelegate protocol.

4. Implement the `controller(_:didChangeContentWith:)` method, and apply the snapshot to the dataSource using the `apply(_:animatingDifferences:completion:)` method.

5. Update a fetchResultsController object’s property that does not constitute an insert/delete/move operation, but that property reflects on the cell. This could be a isFavorite property if the objects are not sorted by that property.

### Expected Results
The cells should update when the snapshot is applied after saving the change.

<img src="CellsBeingUpdated.mov" width="300" height="600">

### Actual Results
The cell did not get updated after the snapshot was applied.

<img src="CellsNotBeingUpdated.mov" width="300" height="600">

### Workaround
Manually update the cells in the completion handler of the DataSource's `apply(_:animatingDifferences:completion:)` method. See the [workaround code](https://github.com/JhonnyBillM/file-a-radar/tree/master/FB7544419%20%20-%20DataSource%20not%20updating%20Snapshot%20data/CollectionViewDeviceSnapshotWorkaroundWithCoreData), specifically at [this line](https://github.com/JhonnyBillM/file-a-radar/blob/cb9726f43613d18ae4eca3be6f8536f5f2213f6f/FB7544419%20%20-%20DataSource%20not%20updating%20Snapshot%20data/CollectionViewDeviceSnapshotWorkaroundWithCoreData/CollectionViewStickyCells/DeviceViewController.swift#L120). 

### Version
**Xcode:** 11.3 (11C29)   
**iOS:** iOS 13.3
