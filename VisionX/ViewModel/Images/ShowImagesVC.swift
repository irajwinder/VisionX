//
//  ShowImagesVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ShowImagesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Images"
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImageCollectionViewCell
        let photo = photos[indexPath.row]
        
        // Download the image
        if let imageUrl = URL(string: photo.src.tiny) {
            networkManagerInstance.downloadImage(from: imageUrl) { image in
                // Update the cell's image on the main thread
                DispatchQueue.main.async {
                    cell.Images.image = image
                }
            }
        }
        return cell
    }
}
