//
//  SentMemeCollectionVC.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 17/08/21.
//

import UIKit

class SentMemeCollectionVC: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var sentMemeCollectionView: UICollectionView!
    
    // Shared Meme List
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentMemeCollectionView.delegate = self
        sentMemeCollectionView.dataSource = self
        
        
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemeCollectionView.reloadData()
    }
    
    
    
}

extension SentMemeCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        memes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! SentMemeCollectionCell
        
        cell.memeImageView .image = memes[indexPath.row].memedImage
        
        return cell
        
    }
    
    
    
    
}
