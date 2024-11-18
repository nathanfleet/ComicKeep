//
//  CollectionViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var comics: [Comic] = []
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let minimumInteritemSpacing: CGFloat = 8
    let minimumLineSpacing: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = sectionInsets
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.estimatedItemSize = .zero
        }
        
        checkAndAddDummyData()
        fetchComics()
    }
    
    // Testing
    func checkAndAddDummyData() {
        if let fetchedComics = CoreDataManager.shared.fetchComics(), fetchedComics.isEmpty {
            CoreDataManager.shared.addDummyComics()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as! ComicCollectionViewCell

        let comic = comics[indexPath.item]
        cell.comicTitleLabel.text = comic.title

        if let imageData = comic.coverImage {
            cell.comicImageView.image = UIImage(data: imageData)
        } else {
            cell.comicImageView.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalPadding = sectionInsets.left + sectionInsets.right +
            (minimumInteritemSpacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth + 40

        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // MARK: Comic Details
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedComic = comics[indexPath.item]
//         Navigate to Comic Detail Screen
//         performSegue(withIdentifier: "ShowComicDetail", sender: selectedComic)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowComicDetail" {
//            if let destinationVC = segue.destination as? ComicDetailViewController,
//               let selectedComic = sender as? Comic {
//                destinationVC.comic = selectedComic
//            }
//        }
//    }
    
    // MARK: Data methods
    func fetchComics() {
        if let fetchedComics = CoreDataManager.shared.fetchComics() {
            comics = fetchedComics
            collectionView.reloadData()
        } else {
            print("No comics found.")
        }
    }
}