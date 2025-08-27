# My Recipe Book 🍲


A comprehensive and offline-first recipe management application built with Flutter, designed for storing and organizing your favorite Indian food recipes.

## App Showcase

### Home & Powerful Search
The main screen provides a vibrant, at-a-glance view of all recipes. It features an integrated search bar and a filterable list of collections. The search is powerful, allowing users to find recipes by title, description, or even by ingredients.

<p align="center">
  <img src="https://github.com/user-attachments/assets/bea9cb16-5025-4695-92d0-3684712d4a95" width="250" alt="Home Screen">
  <img src="https://github.com/user-attachments/assets/fc603cdc-164d-4f5b-a8b9-8ec6b7fd54ff" width="250" alt="Search Screen">
</p>

### Full Recipe Management
The app features complete Create, Read, Update, and Delete (CRUD) functionality. Users can add new recipes with a detailed, user-friendly form or edit existing ones.

<p align="center">
  <img src="https://github.com/user-attachments/assets/cdd1b40e-2001-4823-92c8-fda0f9ae8c1a" width="250" alt="Add Recipe Screen">
  <img src="https://github.com/user-attachments/assets/7b27e567-bfec-490e-b83b-f4c7a84074c9" width="250" alt="Edit Recipe Screen">
</p>

### Interactive Details
The detail screen showcases the recipe with a large header image and clear instructions. It includes two key interactive features:
* **Dynamic Ingredient Scaling:** Users can increase or decrease the serving size, and all ingredient quantities are automatically recalculated in real-time.
* **Star Ratings:** Users can tap the rating to open a dialog and save their own rating for the recipe.

<p align="center">
  <img src="https://github.com/user-attachments/assets/948769e3-a94b-439c-a26f-1121588a455f" width="250" alt="Recipe Detail Screen">
  <img src="https://github.com/user-attachments/assets/18e3f5ab-16f5-411e-8bb1-70300eda7f5f" width="250" alt="Serving Counter in Action">
  <img src="https://github.com/user-attachments/assets/ab18482a-97bd-433b-965f-fa846a3b8480" width="250" alt="Rating Dialog">
</p>

### Powerful Organization with Collections & Favorites
Users can mark recipes as favorites for quick access in a dedicated tab. For more advanced organization, users can create their own custom collections, which can be edited and deleted.

<p align="center">
  <img src="https://github.com/user-attachments/assets/bd8fa8de-0c8a-47b4-bfe2-08394569041f" width="250" alt="Collections Screen">
  <img src="https://github.com/user-attachments/assets/cc2731e5-c434-40db-baf5-99bcb5188cb8" width="250" alt="Favorites Screen">
  <img src="https://github.com/user-attachments/assets/66e79e7d-92b8-4914-b491-ef94ef830c38" width="250" alt="Collection Detail Screen">
</p>

## Features

* **Full Recipe Management (CRUD):** Create, read, update, and delete recipes.
* **Detailed Recipe Information:** Title, description, ingredients, instructions, images, prep time, servings, and tags.
* **Interactive Recipe Viewing:** Dynamically scale ingredients with a servings counter and set star ratings.
* **Powerful Organization:** Create, edit, and delete personal collections.
* **Quick Collections:** Automatic, dynamic collections for "All Recipes", "Favorites", "Quick & Easy", and "New Recipes".
* **Advanced Search:** Find recipes by Title, Description, or Ingredient name.
* **Offline First:** All data is stored locally using the Hive database, making the app fully functional without an internet connection.

## Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Database:** Hive (Local, Key-Value NoSQL Database)
* **Key Packages:**
    * `image_picker`
    * `flutter_rating_bar`
    * `hive_generator` & `build_runner`
    * `uuid`
    * `provider`

## Getting Started

To run this project locally, follow these steps:

1.  Clone the repository.
2.  Navigate to the project directory.
3.  Get the dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the Hive code generator:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  Run the app:
    ```bash
    flutter run
    ```
    
