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
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyAppearanceSettings), name: NSNotification.Name("AppearanceDidChange"), object: nil)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
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
    
    // MARK: Gesture Recognizer (For Project Requirement)
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                let selectedComic = wishlistComics[indexPath.item]

                let alert = UIAlertController(title: "Remove Comic",
                                              message: "Do you want to remove \(selectedComic.title ?? "this comic") from your wishlist?",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
                    self?.removeComic(selectedComic, at: indexPath)
                }))
                present(alert, animated: true)
            }
        }
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
    
    func removeComic(_ comic: Comic, at indexPath: IndexPath) {
        let success = CoreDataManager.shared.deleteComic(comic: comic)
        if success {
            wishlistComics.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Failed to remove comic.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
}
