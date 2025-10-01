# Swift Concurrency Demo - Album List

A complete Swift/SwiftUI project that demonstrates modern Swift concurrency features including `async/await`, `@MainActor`, `Task.detached`, and proper separation of concerns in a clean album listing application.

## 🚀 **How to Run the Project**

### **Method 1: Create New Xcode Project (Recommended)**

1. **Open Xcode**
2. **File → New → Project**
3. **Choose "iOS" → "App"**
4. **Fill in details:**
   - Product Name: `ConcurrencyDemo`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Use Core Data: `No`
5. **Choose location:** 
6. **Click "Create"**
7. **Replace the generated files** with the ones in the `ConcurrencyDemo` folder

### **Method 2: Use Xcode's "Open Folder" Feature**

1. **Open Xcode**
2. **File → Open** and select the `ConcurrencyDemo` folder
3. Xcode should recognize the Swift files and let you run them

## 📁 **Project Structure**

```
Concurrency/
├── ConcurrencyDemo/
│   ├── Models/
│   │   └── Album.swift
│   ├── Services/
│   │   └── AlbumService.swift
│   ├── ViewModels/
│   │   └── AlbumViewModel.swift
│   ├── Views/
│   │   └── AlbumView.swift
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   ├── ConcurrencyDemoApp.swift
│   ├── ContentView.swift
│   └── Info.plist
└── README.md
```

## 🎯 **What You'll See**

When you run the app, you'll see:
1. **Loading screen** while albums are fetched from the API
2. **Clean album list** displaying album titles and IDs
3. **Pull-to-refresh** functionality to reload albums
4. **Error handling** with retry option if network issues occur
5. **Empty state** when no albums are available

## 🔧 **Swift Concurrency Features Demonstrated**

1. **async/await**: Used in `AlbumService` for network requests
2. **@MainActor**: Ensures UI updates happen on the main thread
3. **Task.detached**: Performs network operations on background threads
4. **defer**: Ensures cleanup happens regardless of success/failure
5. **ObservableObject**: Reactive data binding with SwiftUI
6. **Proper Separation of Concerns**: Service layer handles threading, ViewModel handles UI state

## 🌐 **API Used**

This project uses the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/albums), which provides:
- ✅ Free, no API key required
- ✅ Realistic album data
- ✅ Reliable uptime
- ✅ Perfect for demonstrating concurrency patterns

## 🏗️ **Architecture & Concurrency Flow**

### **Threading Strategy**
- **Main Actor**: UI updates (`@MainActor` on `AlbumViewModel`)
- **Background Thread**: Network operations (`Task.detached` in `AlbumService`)
- **Proper Suspension**: `await` suspends main thread while waiting for background work

### **Concurrency Flow**
```
UI Thread (Main Actor)
    ↓
AlbumView → AlbumViewModel.loadAlbums()
    ↓
isLoading = true (Main Actor)
    ↓
await albumService.fetchAlbums() (Main Actor waits)
    ↓
┌─────────────────────────────────────┐
│ Service Layer (Background Thread)   │
│                                     │
│ Task.detached {                     │
│   URLSession.data(from: url)        │ ← Network request
│   JSONDecoder.decode()               │ ← Data parsing
│ }                                   │
└─────────────────────────────────────┘
    ↓
Return to Main Actor
    ↓
albums = fetchedAlbums (Main Actor)
    ↓
isLoading = false (Main Actor)
    ↓
UI Updates (Main Actor)
```

### **Key Design Principles**
- **Separation of Concerns**: Service handles threading, ViewModel handles UI state
- **Thread Safety**: `@MainActor` ensures UI updates are thread-safe
- **Non-blocking**: Network operations don't freeze the UI
- **Error Handling**: `defer` ensures cleanup in all scenarios

## 📋 **Requirements**

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

The project is ready to run and demonstrates modern Swift concurrency patterns with proper separation of concerns!