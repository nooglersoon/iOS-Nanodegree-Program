//
//  PhotoAlbumVC+CollectionView.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 09/09/21.
//

import Foundation
import UIKit
import CoreData

// MARK: - UICollectionView Extension

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        let photoData = self.fetchedResultsController.object(at: indexPath)
        
        if photoData.photoImage == nil {
            
            cell.photoActivityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageData = try? Data(contentsOf: photoData.photoURL!) {
                    
                    DispatchQueue.main.async {
                        
                        photoData.photoImage = imageData
                        
                        cell.photoActivityIndicator.stopAnimating()
                        
                        do {
                            try self.dataController.viewContext.save()
                        } catch {
                            print("Error saving image")
                        }
                        
                        cell.photoCellView.image = UIImage(data: imageData)
                        print("The URL is: \(imageData)")
                        
                    }
                    
                }
                
            }
            
        } else {
            
            cell.photoCellView.image = UIImage(data: photoData.photoImage!)
            
        }
        
        return cell
        
    }
    
    // Tap to delete function
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoData = self.fetchedResultsController.object(at: indexPath)
        self.dataController.viewContext.delete(photoData)
        
        do {
            try self.dataController.viewContext.save()
            
            
        } catch {
            print("Unable to delete images")
        }
        
        collectionView.performBatchUpdates(){
            collectionView.reloadData()
        }
        
    }
    
}
