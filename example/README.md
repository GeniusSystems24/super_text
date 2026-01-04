# Text Preview - Examples

A comprehensive example app showcasing all features of the `super_text` package.

## 🚀 Getting Started

```bash
cd example
flutter pub get
flutter run
```

---

## 📱 Screens & Code Examples

### 1️⃣ Basic Usage (`BasicUsageScreen`)

The simplest way to use `SuperTextPreview`:

```dart
import 'package:super_text/super_text.dart';

// Simple example with a link
SuperTextPreview(
  text: 'Visit our website at https://flutter.dev',
)

// Email and phone number
SuperTextPreview(
  text: '''Contact us at support@example.com
Or call +966555555555''',
)

// Username and hashtag
SuperTextPreview(
  text: 'Follow @flutter_dev and use #FlutterDev',
)

// Comprehensive example
SuperTextPreview(
  text: '''Hello! 👋
Website: https://flutter.dev
Email: contact@flutter.dev
Phone: +966500000000
Follow us: @FlutterDev #Flutter #Dart''',
)

// Using parsedText for better performance
final parsedData = SuperTextData.parse('Text to parse', save: true);
SuperTextPreview(
  parsedText: parsedData,
)
```

---

### 2️⃣ Custom Styling (`CustomStylingScreen`)

Customize colors and text styles:

```dart
SuperTextPreview(
  text: '''Welcome to our website https://example.com
Contact: contact@company.com
Phone: +966501234567
Follow @official_account
#development #flutter #dart''',
  linkTextStyle: TextStyle(
    color: Color(0xFF6750A4),
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFF6750A4),
    fontWeight: FontWeight.w500,
  ),
  emailTextStyle: TextStyle(
    color: Color(0xFF2196F3),
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFF2196F3),
  ),
  phoneTextStyle: TextStyle(
    color: Color(0xFF4CAF50),
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFF4CAF50),
  ),
  usernameTextStyle: TextStyle(
    color: Color(0xFF9C27B0),
    fontWeight: FontWeight.bold,
  ),
  hashtagTextStyle: TextStyle(
    color: Color(0xFF3F51B5),
    fontWeight: FontWeight.bold,
  ),
)
```

---

### 3️⃣ Builder Pattern (`BuilderPatternScreen`)

Create custom widgets for each data type:

```dart
// Link as Chip
SuperTextPreview.builder(
  text: 'Visit https://flutter.dev for more',
  linkBuilder: (link) => Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.purple.shade100,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.link, size: 14, color: Colors.purple),
        SizedBox(width: 4),
        Text(
          Uri.parse(link.text).host,
          style: TextStyle(color: Colors.purple, fontSize: 12),
        ),
      ],
    ),
  ),
)

// Email with icon
SuperTextPreview.builder(
  text: 'Contact us at support@company.com',
  emailBuilder: (email) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade600],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.email, size: 14, color: Colors.white),
        SizedBox(width: 6),
        Text(email.text, style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
)

// Username with avatar
SuperTextPreview.builder(
  text: 'Follow @flutter_dev on Twitter',
  usernameBuilder: (username) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.purple.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.purple.shade200,
          child: Text(
            username.userId[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
        SizedBox(width: 4),
        Text(username.text, style: TextStyle(color: Colors.purple.shade700)),
      ],
    ),
  ),
)

// Complete example with all builders
SuperTextPreview.builder(
  text: '''📱 Our new app!
🔗 https://flutter.dev
📧 support@flutter.dev
📞 +966501234567
👤 @flutter_team
#Flutter #Dart''',
  linkBuilder: (link) => _buildChip(Icons.link, Uri.parse(link.text).host, Colors.purple),
  emailBuilder: (email) => _buildChip(Icons.email, email.text, Colors.orange),
  phoneBuilder: (phone) => _buildChip(Icons.phone, phone.text, Colors.green),
  usernameBuilder: (username) => _buildChip(Icons.person, username.text, Colors.blue),
  hashtagBuilder: (hashtag) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(hashtag.text, style: TextStyle(color: Colors.blue.shade800)),
  ),
)
```

---

### 4️⃣ Theming (`ThemingScreen`)

Full control using `SuperTextPreviewTheme`:

```dart
// Add theme in MaterialApp
MaterialApp(
  theme: ThemeData(
    extensions: [
      SuperTextPreviewTheme.light(), // or SuperTextPreviewTheme.dark()
    ],
  ),
)

// Custom theme
SuperTextPreview(
  text: 'Your text here...',
  textPreviewTheme: SuperTextPreviewTheme(
    normalTextFontSize: 16,
    borderRadius: 12,
    normalTextStyle: TextStyle(color: Color(0xFF1C1B1F), fontSize: 16),
    linkTextStyle: TextStyle(
      color: Color(0xFF6750A4),
      decoration: TextDecoration.underline,
    ),
    emailTextStyle: TextStyle(
      color: Color(0xFF0091EA),
      decoration: TextDecoration.underline,
    ),
    phoneTextStyle: TextStyle(
      color: Color(0xFF00C853),
      decoration: TextDecoration.underline,
    ),
    usernameTextStyle: TextStyle(
      color: Color(0xFF2962FF),
      fontWeight: FontWeight.bold,
    ),
    hashtagTextStyle: TextStyle(
      color: Color(0xFFAA00FF),
      fontWeight: FontWeight.bold,
    ),
    primaryColor: Color(0xFF6750A4),
    linkColor: Color(0xFF6750A4),
    emailColor: Color(0xFF0091EA),
    phoneColor: Color(0xFF00C853),
    usernameColor: Color(0xFF2962FF),
    hashtagColor: Color(0xFFAA00FF),
  ),
)
```

---

### 5️⃣ Real World Chat (`RealWorldScreen`)

Use in a chat application:

```dart
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? colorScheme.primary : colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SuperTextPreview(
        text: text,
        normalTextStyle: TextStyle(
          color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
        linkTextStyle: TextStyle(
          color: isMe ? Colors.white70 : colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
        onLinkTap: (link) => launchUrl(Uri.parse(link.text)),
        onEmailTap: (email) => launchUrl(Uri.parse('mailto:${email.text}')),
        onPhoneTap: (phone) => launchUrl(Uri.parse('tel:${phone.text}')),
        onUsernameTap: (username) => showUserProfile(username.userId),
        onHashtagTap: (hashtag) => searchHashtag(hashtag.title),
      ),
    );
  }
}
```

---

### 6️⃣ Social Media Posts (`SocialMediaScreen`)

Display social posts with styled interactive elements:

```dart
class SocialPostCard extends StatelessWidget {
  final String platform;
  final Color platformColor;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SuperTextPreview(
          text: content,
          linkTextStyle: TextStyle(
            color: platformColor,
            decoration: TextDecoration.underline,
          ),
          usernameTextStyle: TextStyle(
            color: platformColor,
            fontWeight: FontWeight.bold,
          ),
          hashtagTextStyle: TextStyle(
            color: platformColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
          onLinkTap: (link) => _showSnackBar('Opening: ${link.text}'),
          onUsernameTap: (u) => _showSnackBar('View: ${u.text}'),
          onHashtagTap: (h) => _showSnackBar('Search: ${h.text}'),
        ),
      ),
    );
  }
}
```

---

### 7️⃣ Interactive Demo (`InteractiveDemoScreen`)

Real-time text parsing with statistics:

```dart
class InteractiveDemo extends StatefulWidget {
  @override
  State<InteractiveDemo> createState() => _InteractiveDemoState();
}

class _InteractiveDemoState extends State<InteractiveDemo> {
  final _controller = TextEditingController();
  List<SuperTextData> _parsedData = [];

  void _parseText() {
    setState(() {
      _parsedData = SuperTextData.parse(_controller.text, save: true);
    });
  }

  int _countType(SuperTextType type) {
    return _parsedData.where((d) => d.textType == type).length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          maxLines: 5,
          onChanged: (_) => _parseText(),
        ),
        
        // Display result
        SuperTextPreview(
          parsedText: _parsedData,
          onLinkTap: (l) => print('Link: ${l.text}'),
          onEmailTap: (e) => print('Email: ${e.text}'),
        ),
        
        // Statistics
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Links: ${_countType(SuperTextType.link)}'),
            Text('Emails: ${_countType(SuperTextType.email)}'),
            Text('Phones: ${_countType(SuperTextType.phone)}'),
            Text('Users: ${_countType(SuperTextType.username)}'),
            Text('Hashtags: ${_countType(SuperTextType.hashtag)}'),
          ],
        ),
      ],
    );
  }
}
```

---

## 📦 Project Structure

```
example/
├── lib/
│   ├── main.dart                      # App entry point
│   └── screens/
│       ├── home_screen.dart           # HomeScreen - Navigation
│       ├── basic_usage_screen.dart    # BasicUsageScreen
│       ├── custom_styling_screen.dart # CustomStylingScreen
│       ├── builder_pattern_screen.dart # BuilderPatternScreen
│       ├── theming_screen.dart        # ThemingScreen
│       ├── real_world_screen.dart     # RealWorldScreen
│       ├── social_media_screen.dart   # SocialMediaScreen
│       └── interactive_demo_screen.dart # InteractiveDemoScreen
├── example.dart                       # Simple example for pub.dev
└── pubspec.yaml
```

---

## 🎨 Features Demonstrated

- ✅ Link extraction and styling
- ✅ Email address detection
- ✅ Phone number recognition
- ✅ Username extraction (@username)
- ✅ Hashtag detection (#hashtag)
- ✅ Custom colors and styles
- ✅ Builder Pattern usage
- ✅ Theme customization
- ✅ Tap event handling

---

## 📚 More Information

See the [main README](../README.md) for complete library documentation.
