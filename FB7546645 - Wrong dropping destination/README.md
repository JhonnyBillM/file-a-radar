## UICollectionViewDropDelegate returns wrong destinationIndexPath in collectionView(_:dropSessionDidUpdate:withDestinationIndexPath:) method

http://openradar.appspot.com/7546645

### Demo

See [Actual Results](#Actual-Results) and [Expected Results](#Expected-Results) sections.

### Summary
The UICollectionViewDropDelegate’s collectionView(_:dropSessionDidUpdate:withDestinationIndexPath:) method returns the wrong destinationIndexPath, the value of the destinationIndexPath is always equal to the dragged item sourceIndexPath.

### Steps to Reproduce
1. Implement Drag & Drop in a CollectionView using the UICollectionViewDragDelegate and UICollectionViewDropDelegate protocols.

2. Get the  destinationIndexPath  property in the collectionView(_:dropSessionDidUpdate:withDestinationIndexPath:) method.

3. For validation, compare the destinationIndexPath to the item’s original sourceIndexPath and see they are always equal.

### Expected Results
The destinationIndexPath should return the position at which the drag session is supposed to be dropped. 

<img src="WorkaroundToWrongDestinationIndexPath.mov" width="300" height="600">

### Actual Results
The destinationIndexPath returns the item’s original index path.

<img src="WrongDestinationIndexPath.mov" width="300" height="600">

### Workaround

Get the session's current position in the collectionView's coordinate system, then get the indexPath given that location.
See the [workaround code](https://github.com/JhonnyBillM/file-a-radar/blob/48d1d9635a502f598aa94137710b97ef452b45f3/FB7546645%20-%20Wrong%20dropping%20destination/CollectionViewWrongDroppingLocation/WrongDroppingLocation/DeviceViewController.swift#L133). 

### Version
**Xcode:** 11.3 (11C29)   
**iOS:** iOS 13.3
