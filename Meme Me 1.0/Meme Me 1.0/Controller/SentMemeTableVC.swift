//
//  SentMemeTableVC.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 17/08/21.
//

import UIKit

class SentMemeTableVC: UIViewController {
    
    // Shared Meme List
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate and datasource to viewcontroller
        sentMemeTableView.delegate = self
        sentMemeTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemeTableView.reloadData()
    }
    
    // Create Meme Method to access meme editor
    
    @IBAction func createMemeTapped(_ sender: Any) {
        
        self.present(MemeEditorVC(), animated: true, completion: nil)
        
    }
    
}

extension SentMemeTableVC: UITableViewDelegate, UITableViewDataSource {
    
    // To calculate total row depends on shared memes
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }

    // To populate the datasource based on shared memes
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! SentMemeTableViewCell
        
        cell.imageViewCell.image = memes[indexPath.row].memedImage
        cell.labelViewCell.text = memes[indexPath.row].topText + "-" + memes[indexPath.row].bottomText
        
        return cell
        
    }
    
    // Method to enable the swipe for delete and delete the current object from shared memes
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Shared Meme List
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            
            // Append to memes
            appDelegate.memes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    // To preparing data before the details called
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell {
            
            let detailMemeVC = segue.destination as! DetailMemeVC
            
            detailMemeVC._image = memes[sentMemeTableView.indexPath(for: cell)!.row].memedImage
            
        }
        
    }
    
    
}
