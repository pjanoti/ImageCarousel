//
//  ContentView.swift
//  ImageCarousel
//
//  Created by prema janoti on 27/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var currentIndex = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var isScrollingUp = false
    @State private var isPinned: Bool = false
    @State private var searchBarPosition: CGFloat = 0 // Track search bar Y position

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - Image Carousel
                    if viewModel.showCarousel {
                        VStack {
                            TabView(selection: $currentIndex) {
                                ForEach(viewModel.images.indices, id: \.self) { index in
                                    AsyncImage(url: URL(string: viewModel.images[index].url)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .scaledToFit()
                                                .cornerRadius(12)
                                                .shadow(radius: 4)
                                                .padding(.horizontal)
                                        case .failure:
                                            Image(systemName: "xmark.octagon")
                                                .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .tag(index)
                                    .gesture(DragGesture().onEnded { value in
                                        if value.translation.width < 0 {
                                            currentIndex = min(currentIndex + 1, viewModel.images.count - 1)
                                        } else if value.translation.width > 0 {
                                            currentIndex = max(currentIndex - 1, 0)
                                        }
                                    })
                                    .onAppear { viewModel.loadListItems(for: index) }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 220)

                            PageIndicator(currentIndex: currentIndex, total: viewModel.images.count)
                                .padding(.top, 4)
                        }
                        .frame(height: 280)
                        .animation(.easeInOut, value: viewModel.showCarousel)
                    }

                    // MARK: - Search Bar with Sticky Effect
                    SearchBar(text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText, { oldValue, newValue in
                            viewModel.applyFilter(for: currentIndex)
                        })
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .shadow(radius: 3)
                        )
                        .offset(y: isPinned ? -searchBarPosition : 0)
                        .animation(.easeInOut(duration: 0.3), value: isPinned)
                        .zIndex(1)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .global).minY)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            searchBarPosition = value
                        }

                    // MARK: - List with Pagination
                    LazyVStack(spacing: 12) {
                        if viewModel.displayedItems.isEmpty {
                            Text("No items found")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.displayedItems) { item in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: item.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .shadow(radius: 2)
                                        case .failure:
                                            Image(systemName: "xmark.octagon")
                                                .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    Text(item.title)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .frame(height: 60)
                            }

                            // Load More Pagination
                            if viewModel.displayedItems.count < viewModel.filteredItems.count {
                                ProgressView()
                                    .padding()
                                    .onAppear {
                                        viewModel.loadMoreItems()
                                    }
                            }
                        }
                    }
                    .padding(.top, 8)
                    .background(GeometryReader { proxy in
                        Color.clear.preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .global).minY)
                    })
                    .onPreferenceChange(ScrollOffsetKey.self) { value in
                        let diff = value - previousScrollOffset
                        isScrollingUp = diff < 0

                        if isScrollingUp && searchBarPosition < 100 {
                            isPinned = true  // Stick when scrolling up
                        } else if !isScrollingUp {
                            isPinned = false // Move back when scrolling down
                        }

                        previousScrollOffset = value
                    }
                }
            }
        }
    }
}

// MARK: - Preference Keys

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PageIndicator: View {
    var currentIndex: Int
    var total: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<total, id: \..self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 16, height: 10)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search", text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
