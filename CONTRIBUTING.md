# Contributing to FocusFlow

Thank you for your interest in contributing to FocusFlow! This project serves as a demonstration of AI-assisted development with GitHub Copilot, and we welcome contributions that further showcase effective prompt engineering and collaborative development practices.

## 🎯 Contribution Philosophy

This project emphasizes:
- **AI-Human Collaboration**: Demonstrating effective GitHub Copilot usage
- **Prompt Engineering Excellence**: Showcasing strategic AI interaction
- **Clean Architecture**: Maintaining separation of concerns
- **Documentation-Driven Development**: Clear communication of intent

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0+
- Dart SDK 3.0+
- GitHub Copilot access (recommended for contributions)
- VS Code or Android Studio with Flutter plugin

### Setup Development Environment

1. **Fork & Clone**
   ```bash
   git clone https://github.com/yourusername/focusflow.git
   cd focusflow
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   flutter packages pub run build_runner build
   ```

3. **Verify Setup**
   ```bash
   flutter doctor
   flutter test
   flutter run
   ```

## 📋 Contribution Types

### 1. Prompt Engineering Documentation
- Add new prompt strategies to `PROMPTS.md`
- Document effective/ineffective prompt patterns
- Share AI collaboration workflows
- Include before/after examples

### 2. Feature Development
- Implement new productivity features
- Enhance existing functionality
- Improve user experience
- Add accessibility features

### 3. Code Quality Improvements
- Refactor for better maintainability
- Add comprehensive tests
- Improve error handling
- Optimize performance

### 4. Documentation Enhancement
- Improve API documentation
- Add code examples
- Create tutorials
- Update README content

## 🛠️ Development Guidelines

### Code Style & Conventions

**Follow Existing Patterns:**
```dart
// Service layer pattern
class [Entity]Service {
  static final Box<[Entity]> _[entity]Box = Hive.box<[Entity]>('[entities]');
  
  static List<[Entity]> get[Entities]() => _[entity]Box.values.toList();
  static Future<void> add[Entity]([Entity] [entity]) async => await _[entity]Box.add([entity]);
  static Future<void> update[Entity]([Entity] [entity]) async => await [entity].save();
  static Future<void> delete[Entity]([Entity] [entity]) async => await [entity].delete();
}
```

**UI Component Consistency:**
```dart
// Card-based list items
Card(
  color: [condition] ? Colors.teal[50] : Colors.pink[50],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: ListTile(/* content */),
)

// Button styling
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink[200],
    foregroundColor: Colors.black87,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('[Action]'),
  onPressed: () async { /* async operation */ },
)
```

### Architectural Principles

1. **Single Responsibility**: Each class/method has one clear purpose
2. **Dependency Inversion**: Services abstract data operations
3. **Reactive UI**: Use `ValueListenableBuilder` for state updates
4. **Offline-First**: All features work without network connectivity

### AI-Assisted Development Workflow

**Document Your Prompts:**
```dart
// AI Collaboration Context:
// Prompt: "Create habit streak calculation handling timezone differences"
// Strategy: Progressive refinement with edge case consideration
// Result: Robust algorithm with comprehensive error handling

int _calculateStreak(Habit habit) {
  // Implementation generated through iterative prompting
}
```

## 📝 Pull Request Process

### Before Submitting

**Checklist:**
- [ ] Code follows project conventions
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Documentation updated for new features
- [ ] Prompt engineering examples included (if applicable)

### PR Template

```markdown
## Description
Brief description of changes and motivation.

## AI Collaboration Details
- **Copilot Usage**: [Describe how AI assisted development]
- **Effective Prompts**: [Share successful prompt strategies]
- **Challenges**: [Any AI limitations encountered]
- **Improvements**: [How prompts were refined]

## Changes Made
- [ ] Feature implementation
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Prompt examples added

## Testing
Describe testing approach and verification steps.

## Screenshots (if UI changes)
Before/after screenshots for visual changes.
```

### Review Process

1. **Automated Checks**: CI/CD validates build and tests
2. **Code Review**: Maintainers review for quality and consistency
3. **AI Strategy Review**: Evaluate prompt engineering effectiveness
4. **Integration**: Merge after approval and final verification

## 🧪 Testing Guidelines

### Unit Tests
```dart
// Test business logic thoroughly
test('streak calculation handles empty completions', () {
  final habit = Habit(name: 'Test', completions: []);
  expect(_calculateStreak(habit), equals(0));
});

test('streak calculation handles consecutive days', () {
  final habit = Habit(
    name: 'Test', 
    completions: [
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
    ]
  );
  expect(_calculateStreak(habit), equals(2));
});
```

### Widget Tests
```dart
// Test UI components
testWidgets('task tile displays correctly', (WidgetTester tester) async {
  final task = Task(title: 'Test Task', completed: false);
  
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: TaskTile(task: task)),
  ));
  
  expect(find.text('Test Task'), findsOneWidget);
  expect(find.byType(Checkbox), findsOneWidget);
});
```

### Integration Tests
```dart
// Test complete workflows
testWidgets('task creation workflow', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // Navigate to tasks
  await tester.tap(find.byIcon(Icons.check_box));
  await tester.pumpAndSettle();
  
  // Add new task
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  
  // Fill form and submit
  await tester.enterText(find.byType(TextField).first, 'New Task');
  await tester.tap(find.text('Add Task'));
  await tester.pumpAndSettle();
  
  // Verify task appears
  expect(find.text('New Task'), findsOneWidget);
});
```

## 📚 Documentation Standards

### Code Comments
```dart
/// Calculates the consecutive day streak for a habit.
/// 
/// Counts backward from today, handling timezone differences
/// and ignoring future dates. Returns 0 for empty completion lists.
/// 
/// Example:
/// ```dart
/// final habit = Habit(completions: [DateTime.now(), yesterday]);
/// final streak = _calculateStreak(habit); // Returns 2
/// ```
int _calculateStreak(Habit habit) {
  // Implementation with inline comments for complex logic
}
```

### README Updates
- Update feature lists for new functionality
- Add setup instructions for new dependencies
- Include screenshots for UI changes
- Update architecture diagrams if needed

### API Documentation
- Document new models in `API_DOCS.md`
- Include usage examples
- Specify validation rules
- Document error conditions

## 🔧 Development Environment Setup

### Recommended VS Code Extensions
```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code", 
    "github.copilot",
    "github.copilot-chat",
    "ms-vscode.vscode-json"
  ]
}
```

### Useful Scripts
```json
{
  "scripts": {
    "build_runner": "flutter packages pub run build_runner build",
    "build_runner_watch": "flutter packages pub run build_runner watch",
    "test": "flutter test",
    "analyze": "flutter analyze",
    "format": "dart format lib/ test/"
  }
}
```

## 🐛 Bug Reports

### Issue Template
```markdown
**Bug Description**
Clear description of the issue.

**Reproduction Steps**
1. Step 1
2. Step 2
3. Expected vs actual behavior

**Environment**
- Flutter version: 
- Dart version:
- Platform: (Android/iOS/Web)
- Device details:

**AI Context (if relevant)**
Was this feature developed with AI assistance? Include relevant context.

**Screenshots**
Visual evidence of the issue.
```

### Debug Information
```dart
// Add debug information for complex issues
debugPrint('Task count: ${tasks.length}');
debugPrint('Habit completions: ${habit.completions.length}');
```

## 🎨 Design Guidelines

### Material Design Compliance
- Follow Material Design 3 principles
- Maintain consistent spacing (8dp grid)
- Use semantic colors appropriately
- Implement proper accessibility features

### Color Palette
```dart
// Primary (Pink)
Colors.pink[50]   // Subtle backgrounds
Colors.pink[100]  // Card borders
Colors.pink[200]  // Primary buttons
Colors.pink[300]  // Text highlights

// Secondary (Teal)
Colors.teal       // Success states
Colors.teal[50]   // Completed backgrounds
Colors.teal[300]  // Secondary highlights
```

### Typography
```dart
// Text styles
TextStyle(fontSize: 18, fontWeight: FontWeight.w500) // Titles
TextStyle(fontSize: 16, color: Colors.black87)       // Body text
TextStyle(fontSize: 14, color: Colors.black54)       // Secondary text
```

## 📱 Platform Guidelines

### Cross-Platform Considerations
- Test on both Android and iOS
- Handle platform-specific UI differences
- Consider responsive design for tablets
- Ensure accessibility compliance

### Performance Standards
- App startup time < 3 seconds
- Smooth animations (60 FPS)
- Efficient memory usage
- Minimal battery impact

## 🚀 Release Process

### Version Management
```yaml
# pubspec.yaml
version: 1.0.0+1
#        │ │ │ │
#        │ │ │ └─ Build number
#        │ │ └─── Patch version
#        │ └───── Minor version
#        └─────── Major version
```

### Changelog Format
```markdown
## [1.1.0] - 2024-MM-DD

### Added
- New feature with AI collaboration details
- Enhanced prompt engineering documentation

### Changed  
- Improved existing feature performance
- Updated UI components for better accessibility

### Fixed
- Bug fix with detailed explanation
- Performance optimization details
```

## 🤝 Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Provide constructive feedback
- Share knowledge generously  
- Help others learn AI-assisted development

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions and discussions
- **README**: General project information
- **PROMPTS.md**: AI collaboration strategies

## 📖 Learning Resources

### AI-Assisted Development
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)
- [AI Pair Programming Best Practices](https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/)

### Flutter Development
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://m3.material.io/)

### Project-Specific
- [Hive Database](https://docs.hivedb.dev/)
- [State Management Patterns](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Testing Best Practices](https://docs.flutter.dev/testing)

---

**Thank you for contributing to FocusFlow!** 🙏

Your contributions help demonstrate the power of AI-assisted development and advance the field of human-AI collaboration in software engineering.

For questions or discussions, please open an issue or start a conversation in pull requests.
