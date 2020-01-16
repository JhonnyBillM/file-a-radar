## CollectionView's reordering API has sticky behavior when the cell is near by its original position

http://openradar.appspot.com/7536789

### Demo
<img src="FB7536789_Sticky_Cells.mov" width="300" height="600">

### Summary
When implementing reordering using the CollectionView’s reordering API a cell snaps to its original position when is being dragged near by it, without the intention to drop it. 

### Steps to Reproduce
1. Implement reordering using the CollectionView’s collectionView(_:moveItemAt:destinationIndexPath:) method, and the rest of the reordering API such as implement the gesture handling.

2. Long press on a cell.

3. Drag the cell.

4. Keep dragging the cell back and forth, and drag it thru its original position.

### Expected Results
The cell should go thru its original position just as it behaves when its being dragged thru the other positions.

This should behave as when we implement reordering using the Drag and Drop APIs.

### Actual Results
The cell snaps to its original position even when you did not intended to drop it.

### Workaround
Implement reordering using the [Drag and Drop API](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/supporting_drag_and_drop_in_collection_views).

### Version
**Xcode:** 11.3 (11C29)   
**iOS:** iOS 13.3
