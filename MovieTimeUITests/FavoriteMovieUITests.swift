
//
//  FavoriteMovieUITests.swift
//  MovieTimeUITests
//
//  Created on 29.12.25.
//

import XCTest

final class FavoriteMovieUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    /// Simple test: Tap a movie, favorite it, and verify it appears in the Favorites tab
    func testFavoriteMovie() throws {
        // 1. We're waiting for the home screen to appear
        let homeGrid = app.scrollViews["HomeMoviesGrid"]
        XCTAssertTrue(homeGrid.waitForExistence(timeout: 5), "Home grid should appear")

        // 2. Wait for at least one movie card to appear
        let firstMovieCard = app.buttons["MovieCard"].firstMatch
        XCTAssertTrue(firstMovieCard.waitForExistence(timeout: 5), "At least one movie card should appear")

        // 3. Tapping the first movie to open details
        firstMovieCard.tap()

        // 4. Tapping on the favorite button (heart icon)
        let favoriteButton = app.buttons["FavoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 3), "Favorite button should appear in detail view")
        favoriteButton.tap()

        // 5. We're going back to home screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 6. We're tapping on Favorites tab
        app.tabBars.buttons["Favorites"].tap()

        // 7. Verify the movie appears in favorites
        let favoriteMovieCard = app.buttons["MovieCard"].firstMatch
        XCTAssertTrue(favoriteMovieCard.waitForExistence(timeout: 3), "Movie should appear in Favorites")
    }
}
