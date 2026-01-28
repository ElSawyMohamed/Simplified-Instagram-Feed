# Simplified Instagram Feed App

A modern iOS application built with Swift, featuring a video feed similar to Instagram. The app follows Clean Architecture principles with MVVM pattern and uses dependency injection for better code organization and testability.

## 📱 Features

- **Video Feed**: Browse and watch videos in a TikTok/Instagram-style vertical feed
- **Video Search**: Search videos by username with case-insensitive filtering
- **Pull to Refresh**: Refresh the feed to get latest videos
- **Infinite Scroll**: Automatic pagination for seamless video browsing
- **Video Caching**: Efficient video caching for offline playback

## 🏗️ Architecture

The app follows **Clean Architecture** with **MVVM (Model-View-ViewModel)** pattern:

```
┌─────────────────────────────────────────┐
│         Presentation Layer               │
│  (ViewControllers, ViewModels, Views)   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Repositories, DTOs, Network Service) │
└─────────────────────────────────────────┘
```

### Key Components

- **Dependency Injection**: Custom DI containers (`AppDIContainer`, `MainSceneDIContainer`)
- **Flow Coordinators**: Navigation management (`AppFlowCoordinator`, `MainFlowCoordinator`)
- **Repository Pattern**: Abstraction layer for data sources
- **Use Cases**: Business logic encapsulation
- **Observable Pattern**: Custom `BindableObservable` for reactive updates

## 📂 Project Structure

```
SimplifiedInstagramFeedTests/
├── Application/                    # App-level configuration
│   ├── AppDelegate.swift          # Main app delegate
│   ├── AppFlowCoordinator.swift   # App-level navigation coordinator
│   ├── AppAppearance.swift        # Global UI appearance setup
│   └── DIContainer/
│       └── AppDIContainer.swift   # Root dependency injection container
│
├── MainScene/                      # Main feature module
│   ├── Feed/                      # Video feed feature
│   │   ├── Data/                  # Data layer
│   │   │   ├── Network/           # API endpoints & DTOs
│   │   │   └── Repositories/      # Data repository implementations
│   │   ├── Domain/                # Domain layer
│   │   │   ├── Entities/          # Domain models
│   │   │   ├── Repositories/      # Repository protocols
│   │   │   └── UseCases/          # Business logic
│   │   └── Presentation/          # Presentation layer
│   │       ├── View/               # ViewControllers & Views
│   │       └── ViewModel/         # ViewModels
│   ├── MainSceneDIContainer/      # Scene-level DI container
│   └── Flows/                     # Navigation coordinators
│
├── Infrastructure/                # Infrastructure layer
│   ├── Network/                   # Network service & configuration
│   ├── Cache/                     # Caching service
│   └── Basics/                    # Base classes & utilities
│
├── Helpers/                       # Shared utilities
│   ├── Constants/                 # App constants
│   ├── Extension/                # Swift extensions
│   ├── SupportingFiles/           # Helper classes
│   └── Utils/                     # Utility functions
│
├── Resources/                     # App resources
│   ├── Assets.xcassets/           # Images & assets
│   ├── *.lproj/                   # Localization files
│   └── Splash/                    # Splash screen
│
└── Common/                        # Shared code
    └── ConnectionError.swift      # Error handling
```

## 🛠️ Technology Stack

### Core Technologies
- **Swift 5.0+**
- **iOS 14.1+**
- **Xcode 15.2+**

### Dependencies (CocoaPods)
- **RxSwift** (6.7.1) - Reactive programming
- **RxCocoa** (6.7.1) - RxSwift extensions for Cocoa
- **Kingfisher** (~> 7.0) - Image downloading and caching
- **SDWebImage** (5.19.6) - Image loading and caching
- **Hero** (1.6.3) - View controller transitions
- **SwiftEntryKit** (2.0.0) - Customizable popups and alerts
- **ViewAnimator** (3.1.0) - View animations

### API
- **Pexels API** - Video feed data source
  - Base URL: `https://api.pexels.com/`
  - Endpoint: `videos/popular`

## 🚀 Getting Started

### Prerequisites
- macOS with Xcode 15.2 or later
- CocoaPods installed (`sudo gem install cocoapods`)
- iOS 14.1+ deployment target

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd SimplifiedInstagramFeed
   ```

2. **Install dependencies**
   ```bash
   pod install
   ```

3. **Open the workspace**
   ```bash
   open SimplifiedInstagramFeed.xcworkspace
   ```
   ⚠️ **Important**: Always open `.xcworkspace`, not `.xcodeproj`

4. **Configure API Key** (if needed)
   - Update API key in network configuration if required
   - Currently uses Pexels API which may require authentication

5. **Build and Run**
   - Select a simulator or device
   - Press `⌘R` or click Run

## 🧪 Testing

The project includes comprehensive unit tests for the Feed feature:

### Running Tests
```bash
# Run all tests
⌘U (in Xcode)

# Or via command line
xcodebuild test -workspace SimplifiedInstagramFeed.xcworkspace -scheme SimplifiedInstagramFeed -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage

#### FeedViewModelTests
- ✅ View initialization and data fetching
- ✅ Refresh functionality
- ✅ Pagination (load more)
- ✅ Search functionality (case-insensitive)
- ✅ Error handling
- ✅ Loading states
- ✅ Empty query handling

#### FeedViewControllerTests
- ✅ View setup and initialization
- ✅ Collection view configuration
- ✅ Refresh control integration
- ✅ ViewModel binding
- ✅ Error display
- ✅ Scroll delegate methods
- ✅ Video playback management

### Test Structure
```
SimplifiedInstagramFeedTests/
├── FeedViewModelTests.swift      # ViewModel unit tests
└── FeedViewControllerTests.swift  # ViewController unit tests
```

## 📱 App Flow

1. **Launch** → Splash screen (`SplashVC`)
2. **Main Flow** → Feed screen (`FeedViewController`)
3. **Navigation** → Managed by `MainFlowCoordinator`

## 🔧 Configuration

### Build Configurations
- **Debug**: Development build with debug symbols
- **Release**: Production build optimized for App Store

### Localization
The app supports multiple languages:
- Arabic (`ar.lproj`)
- English (`en.lproj`)
- French (`fr.lproj`)

### Network Configuration
- Base URL configured in `BaseURL+EndPoints.swift`
- Network service uses `DataTransferService` protocol
- Error handling via `ConnectionError`

## 🏛️ Architecture Patterns

### Dependency Injection
```swift
// App-level DI Container
AppDIContainer
  └── MainSceneDIContainer
      └── FeedViewController
          └── FeedViewModel
              └── FetchVideosUseCase
                  └── VideoRepository
```

### MVVM Pattern
- **Model**: `VideoPost` entity
- **View**: `FeedViewController`, `VideoFeedCell`
- **ViewModel**: `FeedViewModel` (protocol-oriented)

### Repository Pattern
- **Protocol**: `VideoRepository`
- **Implementation**: `DefaultVideoRepository`
- **Abstraction**: Data source agnostic

## 📝 Code Style

- Follows Swift API Design Guidelines
- Protocol-oriented programming
- Dependency injection for testability
- Clear separation of concerns
- Meaningful naming conventions

## 👥 Contributors

- Mohamed Sawy - Initial development

## 📞 Support

For issues and questions, please open an issue in the repository.

---

## 🔄 Recent Updates

- ✅ Added comprehensive unit tests for FeedViewModel and FeedViewController
- ✅ Fixed Podfile configuration for proper test target support
- ✅ Updated deployment target to iOS 14.1
- ✅ Improved code signing configuration for test targets
- ✅ Added README documentation

---

**Built with ❤️ using Swift and Clean Architecture**

