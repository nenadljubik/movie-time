//
//  SearchViewModelTests.swift
//  MovieTimeTests
//
//  Created by Claude on 28.12.25.
//

import XCTest
import TMDBKit
@testable import MovieTime

@MainActor
final class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!

    override func setUp() {
        viewModel = SearchViewModel()
    }

    override func tearDown() {
        viewModel = nil
    }

    // MARK: - Initial State Tests

    func testInitialState() throws {
        XCTAssertEqual(viewModel.searchQuery, "", "Search query should be empty initially")
        XCTAssertEqual(viewModel.searchType, .movies, "Search type should be movies initially")
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Search results should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
    }

    // MARK: - Search Query Tests

    func testSearchQueryUpdate() throws {
        viewModel.searchQuery = "Inception"
        XCTAssertEqual(viewModel.searchQuery, "Inception", "Search query should update")
    }

    func testSearchQueryCanBeCleared() throws {
        viewModel.searchQuery = "Inception"
        viewModel.searchQuery = ""
        XCTAssertEqual(viewModel.searchQuery, "", "Search query should be clearable")
    }

    // MARK: - Search Type Tests

    func testSearchTypeToggle() throws {
        XCTAssertEqual(viewModel.searchType, .movies, "Initial type should be movies")

        viewModel.searchType = .tvShows
        XCTAssertEqual(viewModel.searchType, .tvShows, "Search type should toggle to TV shows")

        viewModel.searchType = .movies
        XCTAssertEqual(viewModel.searchType, .movies, "Search type should toggle back to movies")
    }

    // MARK: - Search Results Tests

    func testSearchResultsCanBeSet() throws {
        // Initially empty
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Should start with no results")

        // Can be populated
        viewModel.searchResults = []
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Empty array should work")
    }

    // MARK: - Loading State Tests

    func testIsLoadingState() throws {
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")

        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoading, "Loading state should be settable to true")

        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading, "Loading state should be settable to false")
    }

    // MARK: - Clear Results Tests

    func testClearingResults() throws {
        // Start with empty results
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Should start empty")

        // Clear results (setting to empty array)
        viewModel.searchResults = []
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Results should remain empty")
    }

    // MARK: - Combined State Tests

    func testSearchQueryAndTypeInteraction() throws {
        viewModel.searchQuery = "Game of Thrones"
        viewModel.searchType = .tvShows

        XCTAssertEqual(viewModel.searchQuery, "Game of Thrones")
        XCTAssertEqual(viewModel.searchType, .tvShows)
    }
}
