//
//  HomeViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applyAppearanceSettings), name: NSNotification.Name("AppearanceDidChange"), object: nil)
    }
    
    @IBAction func randomComicBtnPressed(_ sender: UIButton) {
        let collection = fetchUserCollection()
        guard let randomComic = selectRandomComic(from: collection) else {
            let alert = UIAlertController(title: "No Comics", message: "You have no comics in your collection yet!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        if let comicDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ComicDetailsViewController") as? ComicDetailsViewController {
            comicDetailsVC.comic = randomComic
            navigationController?.pushViewController(comicDetailsVC, animated: true)
        }
    }
    
    @objc func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    func selectRandomComic(from comics: [Comic]) -> Comic? {
        guard !comics.isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<comics.count)
        return comics[randomIndex]
    }
    
    // MARK: Data Methods
    func fetchUserCollection() -> [Comic] {
        if let comics = CoreDataManager.shared.fetchComics(acquired: true, wishlist: false) {
            return comics
        } else {
            return []
        }
    }
}
