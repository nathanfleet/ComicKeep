//
//  WishlistViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit
import CoreData

class WishlistCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var wishlistComics: [Comic] = []

    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let minimumInteritemSpacing: CGFloat = 8
    let minimumLineSpacing: CGFloat = 8
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWishlistComics()
        collectionView.reloadData()
    }

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
    }

    // Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedComic = wishlistComics[indexPath.item]
        
        // Allow user to move selected comic to their collection
        let alert = UIAlertController (
            title: "Move to Collection",
            message: "Would you like to Move \(selectedComic.title ?? "this comic") to your collection?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Move", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }

            selectedComic.acquired = true
            selectedComic.wishlist = false

            CoreDataManager.shared.saveContext()

            self.wishlistComics.remove(at: indexPath.item)

            self.collectionView.deleteItems(at: [indexPath])
        }))

        present(alert, animated: true, completion: nil)
    }
    
    // Data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistComics.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as! ComicCollectionViewCell

        let comic = wishlistComics[indexPath.item]
        cell.comicTitleLabel.text = comic.title

        if let imageData = comic.coverImage {
            cell.comicImageView.image = UIImage(data: imageData)
        } else {
            cell.comicImageView.image = UIImage(named: "placeholder")
        }

        return cell
    }

    // Flow layout
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
    
    // MARK: Data methods
    func fetchWishlistComics() {
        if let fetchedComics = CoreDataManager.shared.fetchComics(acquired: false, wishlist: true) {
            wishlistComics = fetchedComics
            collectionView.reloadData()
        } else {
            print("No wishlist comics found.")
        }
    }
}
