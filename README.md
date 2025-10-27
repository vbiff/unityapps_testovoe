# AI Image Generator

A Flutter application that simulates AI image generation with a clean, modern interface. Built with flutter_bloc for state management and go_router for navigation.

## Features

- **Prompt Input Screen**: Enter descriptive prompts for image generation
- **Result Screen**: View generated images with loading states and error handling
- **Mock API**: Simulates realistic API behavior with delays and ~50% failure rate
- **State Management**: Uses flutter_bloc for clean architecture
- **Modern UI**: Material 3 design with smooth animations
- **Error Handling**: Comprehensive error states with retry functionality
- **Navigation**: Clean navigation flow with state preservation

## Architecture

The app follows Clean Architecture principles with a layered approach:

### **Domain Layer** (Business Logic)
- **Entities/Models**: Core business objects (`GeneratedImage`)
- **Repository Interfaces**: Abstract contracts for data access
- **Use Cases**: Encapsulated business rules and operations
- **Exceptions**: Domain-specific error handling

### **Data Layer** (Data Access)
- **Repository Implementation**: Concrete implementation of domain contracts
- **Remote Data Source**: API Ninjas integration for image generation
- **Models**: Data transfer objects and mappers

### **Presentation Layer** (UI)
- **BLoC Pattern**: State management and presentation logic
- **Screens**: UI components and widgets
- **Router**: Declarative navigation with go_router

### **Core Layer** (Infrastructure)
- **Dependency Injection**: GetIt service locator for dependency management
- **Services**: External service integrations
- **Router**: Navigation configuration

## Project Structure

```
lib/
├── core/                           # Infrastructure layer
│   ├── di/                         # Dependency injection
│   │   └── injection_container.dart
│   ├── router/                     # Navigation configuration
│   │   └── app_router.dart
│   └── services/                   # External services (legacy)
│       └── image_generation_service.dart
├── data/                           # Data layer
│   ├── datasources/                # Data source implementations
│   │   └── image_generation_remote_datasource.dart
│   └── repository/                 # Repository implementations
│       └── image_generation_repository_impl.dart
├── domain/                         # Domain layer (business logic)
│   ├── exceptions/                 # Domain exceptions
│   │   └── image_generation_exception.dart
│   ├── models/                     # Domain entities
│   │   └── generated_image.dart
│   ├── repository/                 # Repository interfaces
│   │   └── image_generation_repository.dart
│   └── usecases/                   # Business use cases
│       └── generate_image_usecase.dart
├── presentation/                   # Presentation layer
│   ├── bloc/                       # BLoC state management
│   │   ├── image_generation_bloc.dart
│   │   ├── image_generation_event.dart
│   │   └── image_generation_state.dart
│   └── screens/                    # UI screens
│       ├── prompt_screen.dart
│       └── result_screen.dart
└── main.dart                      # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- iOS Simulator or Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd unityapps_testovoe
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Running on iOS

To run on iOS simulator:
```bash
flutter run -d ios
```

To run on a specific iOS device:
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

## Usage Flow

1. **Enter Prompt**: Type a descriptive prompt in the input field
2. **Generate**: Tap the "Generate" button (enabled when prompt is not empty)
3. **View Result**: Watch the loading animation, then see the generated image
4. **Actions**:
   - **Try Another**: Generate a new image with the same prompt
   - **New Prompt**: Return to prompt screen (text is preserved)
   - **Retry**: Retry generation after an error

## Technical Details

### State Management

The app uses flutter_bloc with the following states:
- `PromptInputState`: Initial state for entering prompts
- `GeneratingImageState`: Loading state during generation
- `ImageGeneratedState`: Success state with image URL
- `ImageGenerationErrorState`: Error state with retry option

### API Integration

The `ImageGenerationService` integrates with API Ninjas Random Image API:
- **API Ninjas Integration**: Uses real API calls to fetch random images
- **Base64 Support**: Handles base64 data URLs from API responses
- **Error Simulation**: ~50% failure rate for testing error handling
- **Network Delay**: 2-3 second delay to simulate real API behavior

#### Setting up API Ninjas

1. Sign up at [API Ninjas](https://api.api-ninjas.com/)
2. Get your API key from the dashboard
3. Replace `YOUR_API_KEY_HERE` in `lib/services/image_generation_service.dart` with your actual API key
4. The app will automatically use the API Ninjas service when a valid key is provided

### UI Features

- **Responsive Design**: Adapts to different screen sizes
- **Loading Animations**: Smooth progress indicators and transitions
- **Error States**: Clear error messages with retry options
- **Input Validation**: Generate button disabled for empty prompts
- **State Preservation**: Prompt text saved when navigating back

## Dependencies

- `flutter_bloc: ^8.1.3` - State management
- `go_router: ^13.2.0` - Navigation
- `http: ^1.1.0` - HTTP requests for API integration
- `get_it: ^8.2.0` - Dependency injection service locator
- `equatable: ^2.0.5` - Value equality for BLoC states

## Testing

Run tests with:
```bash
flutter test
```

## Building for Release

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

## Contributing

1. Follow the existing code style and architecture
2. Add tests for new features
3. Update documentation as needed
4. Ensure all linting rules pass

## License

This project is created as a test assignment and is for demonstration purposes.
# unityapps_testovoe
