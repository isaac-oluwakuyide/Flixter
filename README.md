# Flixter
A movie browsing app that lets a user view and scroll through a list of movies

**Flixter** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **25** hours spent in total

The following functionality was implemented:

- User sees an app icon on the home screen and a styled launch screen.
- User can view a list of movies currently playing in theaters from The Movie Database.
- Poster images are loaded using the UIImageView category in the AFNetworking library.
- User sees a loading state while waiting for the movies API.
- User can pull to refresh the movie list.
- User sees an error message when there's a networking error.
- User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

- User can tap a poster in the collection view to see a detail screen of that movie
- User can search for a movie.
- User can view a movie trailer by clicking on the movie backdrop image. 
- All images fade in as they are loading.
- User can view the large movie poster by tapping on the detailed poster.
- For the large poster, the low resolution image loads first and  switches to the high resolution image when complete.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

[Video Walkthrough](https://imgur.com/a/sHpU87G)


## Notes
### Challenges During Building
- Configuring Table and Collection Views
- Refactoring code while adding features
- Filtering search results with the search bar
- Creating the API request for the movie trailer


##Installation Instructions
To clone the Flixter GitHub repository and run the app on the iPhone 14 Pro Simulator, you can follow these steps:

1. Open Terminal on your Mac.
2. Navigate to the directory where you want to clone the repository.
3. Clone the Flixter repository 
4. Once the repository is cloned, navigate to the project directory:
5. Install the dependencies using Cocoapods. If you don't have Cocoapods installed, you can follow the installation instructions [here](https://cocoapods.org/).
   ```
   pod install
   ```
6. After the dependencies are installed, open the `Flixter.xcworkspace` file in Xcode.
7. In Xcode, select the "Flixter" scheme and choose the iPhone 14 Pro Simulator from the device menu.
8. Click on the Run button or use the shortcut `Cmd + R` to build and run the app on the simulator.


## Credits
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
