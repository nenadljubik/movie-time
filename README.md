# MovieTime

A modern iOS movie discovery app built with SwiftUI, featuring trending movies, search functionality, and personalized favorites.

## Features

### Core Functionality
- **Trending Movies**: Browse trending movies with infinite scrolling pagination
- **Advanced Search**: Search for both movies and TV shows with real-time results
- **Favorites**: Save and manage your favorite movies with local persistence
- **Movie Details**: View comprehensive information including ratings, release dates, and overview

### Technical Highlights
- **SwiftData Integration**: Local caching and favorites management
- **Optimized Image Loading**:
  - Progressive loading with low-res placeholders
- **Protocol-Oriented Architecture**: Testable and maintainable codebase
- **Comprehensive Unit Tests**: Test coverage for ViewModels and Managers

## Screenshots
<p align="left">

  <img src="https://github.com/user-attachments/assets/e1b6f471-bb62-4582-a0be-80753d922cae" width="250" alt="Home Screen - Trending Movies">
  <img src="https://github.com/user-attachments/assets/24e22acc-e267-496e-b2fc-69792e775946" width="250" alt="Movie Details">
  <img src="https://github.com/user-attachments/assets/21f16625-2273-4f97-a896-e7bfde03c91c" width="250" alt="Search">
</p>

<p align="left">
  <em>Left: Home Screen with Trending Movies | Middle: Movie Details | Right: Search</em>
</p>

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/nenadljubik/movie-time.git
cd MovieTime
```

### 2. Add TMDBKit Framework

This project uses TMDBKit as an XCFramework. You need to add it to your project:

#### Option A: Import Pre-built XCFramework

1. [Download](https://github.com/nenadljubik/tmdbd-kit) or locate your `TMDBKit.xcframework` file
2. Open the project in Xcode
3. Select the **MovieTime** project in the Project Navigator
4. Select the **MovieTime** target
5. Go to the **General** tab
6. Scroll down to **Frameworks, Libraries, and Embedded Content**
7. Click the **+** button
8. Click **Add Other...** → **Add Files...**
9. Navigate to and select `TMDBKit.xcframework`
10. Ensure **Embed & Sign** is selected in the Embed column

#### Option B: Add via Drag and Drop

1. Drag `TMDBKit.xcframework` into your project navigator
2. In the dialog that appears:
   - ✅ Check "Copy items if needed"
   - ✅ Ensure "MovieTime" target is selected
   - Click "Finish"
3. Select your project → Target → General
4. Under "Frameworks, Libraries, and Embedded Content"
5. Set TMDBKit.xcframework to **Embed & Sign**

### 3. Configure TMDB API Key

1. Get your API key from [The Movie Database (TMDB)](https://www.themoviedb.org/settings/api)
2. Create a configuration file:
   - **Development**: `MovieTime/Config/Development.xcconfig`
   - **Production**: `MovieTime/Config/Production.xcconfig`

3. Add your API key to the configuration files:

```bash
// Development.xcconfig
TMDB_API_KEY = your_development_api_key_here

// Production.xcconfig
TMDB_API_KEY = your_production_api_key_here
```

4. The app reads the API key from `Info.plist`:

```xml
<key>TMDB_API_KEY</key>
<string>$(TMDB_API_KEY)</string>
```

### 4. Build and Run

1. Open `MovieTime.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `Cmd + R` to build and run


### MVVM Pattern

The app follows the Model-View-ViewModel pattern:

- **Models**: `Movie`, `TVShow`, `FavoriteMovie`, `CachedMovie`
- **Views**: SwiftUI views for each screen
- **ViewModels**: `HomeViewModel`, `SearchViewModel`, `FavoritesViewModel`, `MovieDetailViewModel`

### Protocol-Oriented Design

Key protocols for testability:
- `FavoritesManagerProtocol`: Favorites management interface
- `TMDBMoviesServiceProtocol`: Movie API service interface
- `PersistenceManaging`: SwiftData operations interface


## Features in Detail

### Image Optimization

The app implements intelligent image loading:

```swift
// Automatically selects optimal image size based on view width
movie.posterURL(width: viewWidth) // Returns w342, w500, or w780

// Accounts for Retina displays (@2x, @3x)
TMDBImageSize.posterSize(for: width) // Multiplies by 3 for device scale
```

**Benefits:**
- 30-50% bandwidth reduction on smaller screens
- Faster loading times
- Reduced memory footprint
- Maintained quality on Retina displays

### Local Caching

- **Trending Movies**: Cached using SwiftData with `CachedMovie` model
- **Favorites**: Persisted locally with `FavoriteMovie` model
- **Offline Support**: View cached content without internet

### Search

- **Throttled Input**: 0.5s debounce to reduce API calls
- **Multi-type Search**: Toggle between Movies and TV Shows
- **Real-time Results**: Instant feedback as you type

## Configuration

### Build Configurations

The project supports two build configurations:
- **Development**: Uses development API keys and settings
- **Production**: Production-ready configuration

Switch configurations: **Product → Scheme → Edit Scheme → Build Configuration**


### TMDBKit Framework Not Found

**Error**: `No such module 'TMDBKit'`

**Solution**:
1. Verify TMDBKit.xcframework is in your project
2. Check it's set to "Embed & Sign" in target settings
3. Clean build folder: `Cmd + Shift + K`
4. Clean derived data: `Cmd + Option + Shift + K`
5. Rebuild project: `Cmd + B`

### API Key Issues

**Error**: API requests failing

**Solution**:
1. Verify your TMDB API key is valid
2. Check `.xcconfig` files contain the correct key
3. Ensure Info.plist references `$(TMDB_API_KEY)`
4. Restart Xcode after configuration changes
