//
//  HomeViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func randomComicBtnPressed(_ sender: UIButton) {
        // TODO: Finish implementation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applyAppearanceSettings), name: NSNotification.Name("AppearanceDidChange"), object: nil)
    }
    
    @objc func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
}
