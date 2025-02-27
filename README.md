# ImageCarousel

📌 Overview

This SwiftUI project implements an Image Carousel with a sticky search bar and infinite scrolling list with pagination. The search bar remains fixed at the top when scrolling up and moves below the carousel when scrolling down.

✨ Features

Image Carousel with smooth transitions and gestures

Sticky Search Bar that stays on top while scrolling

LazyVStack List with infinite scrolling pagination

Async Image Loading with placeholders

Dynamic Filtering based on search input

Smooth Animations and UI Enhancements

🛠️ Tech Stack

SwiftUI

MVVM Architecture

AsyncImage for optimized image loading

Gesture handling for interactive carousel

PreferenceKey for scroll detection

🚀 Installation & Setup

Clone the repository:

git clone https://github.com/your-repo/ImageCarousel.git
cd ImageCarousel

Open ImageCarousel.xcodeproj in Xcode.

Run the project on an iOS Simulator or physical device.

📜 Code Structure

1️⃣ ViewModel.swift

Handles image fetching, filtering, and pagination logic.

2️⃣ ContentView.swift

Image Carousel: Displays images in a TabView

Sticky Search Bar: Fixed search bar with dynamic filtering

LazyVStack List: Infinite scrolling items with pagination

3️⃣ ScrollOffsetTracker.swift

Tracks scrolling behavior to pin/unpin search bar

Uses PreferenceKey to detect vertical scroll changes
