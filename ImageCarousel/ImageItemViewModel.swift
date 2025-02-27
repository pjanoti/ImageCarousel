//
//  ImageItem.swift
//  ImageCarousel
//
//  Created by prema janoti on 27/02/25.
//


import Foundation

class ViewModel: ObservableObject {
    
    @Published var images: [ImageData] = []
    @Published var filteredItems: [ItemData] = []
    @Published var searchText: String = ""
    @Published var showCarousel: Bool = true
    
    private var allItems: [ItemData] = []

    // Pagination properties
    
    @Published var displayedItems: [ItemData] = []
    private var currentPage = 0
    private let pageSize = 20 // Load 10 items per page

    init(jsonData: Data? = nil) {
        if let jsonData = jsonData {
            parseJSON(jsonData)
        } else {
            loadJSONData()
        }
    }

    func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            parseJSON(data)
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }

    func parseJSON(_ data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData.self, from: data)
            DispatchQueue.main.async {
                self.images = decodedData.images
                if !self.images.isEmpty {
                    self.loadListItems(for: 0) // Load first image's items initially
                }
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }

    func loadListItems(for index: Int) {
        guard !images.isEmpty, index >= 0, index < images.count else {
            print("Index out of range or images not loaded")
            return
        }

        DispatchQueue.main.async {
            self.allItems = self.images[index].items
            self.filteredItems = self.allItems
            self.currentPage = 0
            self.displayedItems = Array(self.allItems.prefix(self.pageSize))
        }
    }

    func loadMoreItems() {
        let nextIndex = (currentPage + 1) * pageSize
        guard nextIndex < filteredItems.count else { return }

        DispatchQueue.main.async {
            let nextChunk = self.filteredItems[nextIndex..<min(nextIndex + self.pageSize, self.filteredItems.count)]
            self.displayedItems.append(contentsOf: nextChunk)
            self.currentPage += 1
        }
    }

    func applyFilter(for index: Int) {
        if searchText.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }

        // Reset pagination after filtering
        currentPage = 0
        displayedItems = Array(filteredItems.prefix(pageSize))
    }
}

// MARK: - Model Structures

struct ResponseData: Codable {
    let images: [ImageData]
}

struct ImageData: Codable, Identifiable {
    let id = UUID()
    let url: String
    let items: [ItemData]
}

struct ItemData: Codable, Identifiable {
    let id = UUID()
    let title: String
    let imageUrl: String
}
