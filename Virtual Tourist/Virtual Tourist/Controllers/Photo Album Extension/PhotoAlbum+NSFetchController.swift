//
//  PhotoAlbum+NSFetchController.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 09/09/21.
//

import Foundation
import CoreData

// MARK: - NSFetchResult Delegate

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath:  IndexPath?)
    {
        switch type {
        case .insert:
            self.photoCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            self.photoCollectionView.deleteItems(at: [indexPath!])
        case .update:
            self.photoCollectionView.reloadItems(at: [indexPath!])
        default:
            break
        }
    }
    
    
}
