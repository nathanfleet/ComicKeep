//
//  AddComicViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/18/24.
//

import UIKit

class AddComicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var issueNumberTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var variantSwitch: UISwitch!
    @IBOutlet weak var keyIssueSwitch: UISwitch!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addToWishlistButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var selectedImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applyAppearanceSettings), name: NSNotification.Name("AppearanceDidChange"), object: nil)
    }
    
    @objc func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            coverImageView.image = image
            selectedImageData = image.jpegData(compressionQuality: 0.8)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Camera Unavailable",
                                          message: "This device does not have a camera or the camera is not accessible.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let issueNumberText = issueNumberTextField.text, !issueNumberText.isEmpty,
              let issueNumber = Int16(issueNumberText) else {
            showAlert(message: "Please enter a title and issue number.")
            return
        }

        let notes = notesTextView.text
        let variant = variantSwitch.isOn
        let keyIssue = keyIssueSwitch.isOn
        let price = Double(priceTextField.text ?? "") ?? 0.0
        let coverImage = selectedImageData

        CoreDataManager.shared.createComic(
            title: title,
            issueNumber: issueNumber,
            notes: notes,
            variant: variant,
            keyIssue: keyIssue,
            coverImage: coverImage,
            price: price
        )

        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let issueNumberText = issueNumberTextField.text, !issueNumberText.isEmpty,
              let issueNumber = Int16(issueNumberText) else {
            showAlert(message: "Please enter a title and issue number.")
            return
        }

        let notes = notesTextView.text
        let variant = variantSwitch.isOn
        let keyIssue = keyIssueSwitch.isOn
        let price = Double(priceTextField.text ?? "") ?? 0.0
        let coverImage = selectedImageData
        
        CoreDataManager.shared.createComic(
            title: title,
            issueNumber: issueNumber,
            notes: notes,
            variant: variant,
            keyIssue: keyIssue,
            coverImage: coverImage,
            acquired: false,
            price: price,
            wishlist: true
        )
        
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
