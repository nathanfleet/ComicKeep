# ComicKeep
ComicKeep is an application designed to help users keep track of and manage their comic collection. This application is customizable and provides the user with statistical information about their collection.

## Key Features
### Comic Collection Management  
**Acquired Comics:** The main collection view (CollectionViewController) displays all acquired comics in a grid layout. Each comic includes a title, cover image, and details.  
**Wishlist:** A separate WishlistCollectionViewController presents a grid of comics the user intends to acquire, stored as "wishlist" items.  
Adding and Editing Comics  
  
### Add Comic Screen (AddComicViewController):
Users can input a comic’s title, issue number, notes, variant and key issue status, price, and attach a cover image.
Photo Source Options: A "Select Image" button allows choosing an image from the photo library, and a “Take Photo” button uses the camera to capture the cover image.
Acquired or Wishlist: Comics can be saved directly into the main collection (acquired = true) or added to the wishlist (wishlist = true).  
  
### Random Comic Selection  
**Home Screen (HomeViewController):** A "Random Comic" button selects a random comic from the user’s acquired collection and navigates to the details screen to show the chosen comic.
Comic Details and Removal
  
### Comic Details Screen (ComicDetailsViewController):  
Shows comic details including title, issue number, price, notes, and cover image. Users can edit their notes and also remove the comic from their collection or wishlist.
  
### Wishlist and Collection Removal via Gesture  
In the collection screens, a long-press gesture on a comic cell can trigger a confirmation alert to remove that comic from the collection or wishlist.
  
### Statistics Visualization  
**Statistics Screen (StatisticsViewController):** Displays the total value of the user’s collection and a line chart showing daily spending over time.
  
**Settings Screen (SettingsViewController):**  
Allows toggling Dark Mode. The setting is stored in UserDefaults so that user preferences persist.  
  
**Dark Mode Support:** The app respects user preferences and supports toggling Dark Mode within the app.  
