//
//  ComicDetailsViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/19/24.
//

import UIKit

class ComicDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var variantLabel: UILabel!
    @IBOutlet weak var keyIssueLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var editNotesButton: UIButton!
    
    var comic: Comic?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        guard let comic = comic else { return }
        titleLabel.text = "Title: \(comic.title ?? "")"
        issueNumberLabel.text = "Issue Number: \(comic.issueNumber)"
        if let price = comic.price { priceLabel.text = "Price: $\(Double(truncating: price as NSNumber))" }
        variantLabel.text = comic.variant ? "Variant: Yes" : "Variant: No"
        keyIssueLabel.text = comic.keyIssue ? "Key Issue: Yes" : "Key Issue: No"
        notesTextView.text = comic.notes ?? "No notes available."
        
        if let coverImageData = comic.coverImage, let coverImage = UIImage(data: coverImageData) {
            coverImageView.image = coverImage
        } else {
            coverImageView.image = UIImage(named: "placeholder")
        }
    }
    
    @IBAction func editNotesButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Notes",
                                              message: "Update your notes for this comic.",
                                              preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.notesTextView.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let newNotes = alert.textFields?.first?.text else { return }
            self?.notesTextView.text = newNotes
            if let comic = self?.comic {
                comic.notes = newNotes
                CoreDataManager.shared.saveContext()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
