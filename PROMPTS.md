# FocusFlow Development Prompts

Effective prompts for developing FocusFlow productivity app with GitHub Copilot.

## Data Models

### Task Model
Create a Task model for a Flutter productivity app with offline-first architecture using Hive. The model needs to support priority levels (none, low, medium, high), optional due dates with timezone awareness, rich text notes, completion status tracking, and type-safe Hive persistence with proper annotations.

### Habit Model  
Build a Habit model for habit tracking in a productivity app. Requirements include tracking daily/weekly habits with completion history, calculating streaks, and supporting different frequencies. Use Hive for persistence.

### Note Model
Create a Note model for note-taking functionality in a productivity app. Must support rich text content, automatic timestamps, search capability, immutable creation time, and integrate seamlessly with existing Task and Habit models using Hive persistence.

## Service Layer

### Task Service
Create a TaskService class for managing tasks in a Flutter productivity app. Implement CRUD operations with Hive database, include proper error handling for offline scenarios, and maintain consistency with existing service patterns in the codebase.

### Habit Service with Business Logic
Implement streak calculation logic for habit tracking. The algorithm should count consecutive days from today backwards, handle timezone differences properly, consider different frequencies (daily vs weekly), and return 0 for habits with no completions.

## UI Components

### Task List Item
Create a dismissible task list item widget for the productivity app. Design should use cards with pink/teal theme and rounded corners. Behavior includes checkbox toggle, swipe-to-delete functionality, priority indicators. Must integrate with TaskService and include proper accessibility labels with good contrast.

### Habit List Item
Build a habit list item widget with completion toggle that gets disabled if already completed today, streak display with visual feedback, edit/delete functionality, and consistent styling with the app's pink/teal theme.

## Screens

### Timer Screen
Implement a Pomodoro timer screen with these constraints: must work in background using Timer.periodic, limit session history to 10 entries, default to 25-minute work and 5-minute break periods, auto-switch between work and break modes, persist settings in Hive, and follow Material Design guidelines.

## Theme and Styling

### Consistent Theme Application
Apply consistent theming across the app using primary pink shades (50, 100, 200, 300), secondary teal for success states, cards with 12px rounded corners, elevated buttons with pink[200] background, and text colors of black87 for primary text and black54 for secondary text.

## State Management

### Hive Reactive Patterns
Implement ValueListenableBuilder pattern for Hive box updates. The pattern should listen to box changes and rebuild UI automatically, include error handling for empty box values, and optimize performance to avoid unnecessary rebuilds.

## Error Handling

### Robust Error Patterns
Create robust error handling for async operations that includes try-catch blocks with specific exception types, user-friendly error messages, fallback behaviors for failure cases, and proper logging for debugging purposes.

## Performance Optimization

### Optimized List Views
Optimize ListView implementation for large datasets by using ListView.separated for consistent spacing, implementing efficient item builders, minimizing widget tree depth, and using proper keys for smooth animations.