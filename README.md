# Flixter
A movie browsing app that lets a user view and scroll through a list of movies

**Flixter** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **10** hours spent in total

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

<img src='https://imgur.com/a/d3ce66E.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


## Notes
### Challenges During Building
- Configuring Table and Collection Views
- Refactoring code while adding features
- Filtering search results with the search bar
- Creating the API request for the movie trailer


## Credits
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
