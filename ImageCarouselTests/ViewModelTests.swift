//
//  Untitled.swift
//  ImageCarousel
//
//  Created by prema janoti on 27/02/25.
//

import XCTest
@testable import ImageCarousel

final class ViewModelTests: XCTestCase {
    
    var viewModel: ViewModel!
    
    override func setUp() {
            super.setUp()
            viewModel = ViewModel()
            viewModel.loadJSONData()
        }
        
        override func tearDown() {
            viewModel = nil
            super.tearDown()
        }


    func testLoadJSONData() {
            XCTAssertNotNil(viewModel.images, "Images should not be nil.")
            XCTAssertFalse(viewModel.images.isEmpty, "Images should not be empty after loading JSON data.")
        }

        func testLoadListItemsForSelectedIndex() {
            // Ensure JSON data is loaded
            XCTAssertFalse(viewModel.images.isEmpty, "Images should not be empty.")
            
            let initialIndex = 0
            XCTAssertLessThan(initialIndex, viewModel.images.count, "Index should be within range.")
            
            viewModel.loadListItems(for: initialIndex)

            XCTAssertEqual(viewModel.filteredItems.count, viewModel.filteredItems.count > 0 ? viewModel.images[initialIndex].items.count : 0,
                           "Filtered items should match the selected image's items.")
        }
    }
