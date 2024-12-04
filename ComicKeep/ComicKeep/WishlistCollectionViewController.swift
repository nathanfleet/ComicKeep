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
            flowLayout.minimumLineSpacing = .zero
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistComicCell", for: indexPath) as! WishlistCollectionViewCell

        let comic = wishlistComics[indexPath.item]
        cell.comicTitleLabel.text = comic.title

        if let imageData = comic.coverImage {
            cell.comicImageView.image = UIImage(data: imageData)
        } else {
            cell.comicImageView.image = UIImage(named: "placeholder")
        }

        return cell
    }
    
    // Data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistComics.count
    }

    // Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedComic = wishlistComics[indexPath.item]
        // TODO: Navigate to Comic Details or move selection to collection
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
        let fetchRequest: NSFetchRequest<Comic> = Comic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isInWishlist == %@", NSNumber(value: true))

        do {
            wishlistComics = try CoreDataManager.shared.context.fetch(fetchRequest)
        } catch {
            print("Error fetching wishlist comics: \(error)")
        }
    }
}
