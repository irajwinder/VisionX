//
//  ShowImagesVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ShowImagesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Images"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        print("relativePaths ---> \(photos)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCollectionViewCell
        
        let photo = photos[indexPath.row]
      
        let image = fileManagerClassInstance.loadImageFromFileManager(relativePath: photo)
        cell.Images.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size of each cell
        return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
    }
}
