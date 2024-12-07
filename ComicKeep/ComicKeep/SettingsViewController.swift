//
//  SettingsViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBAction func darkModeSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "DarkModeEnabled")
        UserDefaults.standard.synchronize()

        applyAppearanceSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        darkModeSwitch.isOn = isDarkModeEnabled
    }
    
    func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")

        if isDarkModeEnabled {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("AppearanceDidChange"), object: nil)
    }
}
