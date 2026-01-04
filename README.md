# TextPreview

مكون Flutter قوي لعرض النصوص مع روابط قابلة للنقر والتفاعل.

## المميزات الرئيسية

- 🔗 **استخراج الروابط**: يدعم HTTP و HTTPS مع معاملات الاستعلام
- 📧 **استخراج الإيميلات**: يتعرف على جميع صيغ البريد الإلكتروني الصحيحة
- 📱 **استخراج أرقام الهواتف**: يدعم الأرقام المحلية والدولية مع التحقق من الصحة
- 👤 **استخراج أسماء المستخدمين**: يتعرف على الأسماء التي تبدأ بـ @
- 🏷️ **استخراج الهاشتاغ**: يتعرف على الهاشتاغ التي تبدأ بـ #
- 🏠 **استخراج الروابط الداخلية**: يتعرف على روابط التطبيق الداخلية الصحيحة
- 🌐 **استخراج روابط التواصل الاجتماعي**: Instagram, Twitter, Facebook, YouTube, LinkedIn, TikTok, WhatsApp, Telegram
- 💾 **دعم التسلسل**: تحويل البيانات إلى/من Map للتخزين والاسترجاع
- 🎨 **تنسيق قابل للتخصيص**: إمكانية تخصيص شكل كل نوع من البيانات
- ⚡ **أداء عالي**: معالجة سريعة وفعالة للنصوص الطويلة

## التثبيت

أضف المكتبة إلى `pubspec.yaml`:

```yaml
dependencies:
  super_text:
    path: ../packages/super_text
```

## الاستخدام الأساسي

```dart
import 'package:super_text/super_text.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuperTextPreview(
      text: '''
        زر موقعنا على https://example.com
        أو راسلنا على support@example.com
        اتصل بنا على +966599999999
        تابع @official_account
        #flutter #development
      ''',
    );
  }
}
```

## الاستخدام مع التخصيص

```dart
SuperTextPreview(
  text: 'نص يحتوي على بيانات مختلفة...',
  linkTextStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  ),
  emailTextStyle: TextStyle(
    color: Colors.orange,
    fontStyle: FontStyle.italic,
  ),
  onLinkTap: (linkData) => print('تم النقر على الرابط: ${linkData.text}'),
  onEmailTap: (emailData) => print('تم النقر على الإيميل: ${emailData.text}'),
)
```

## استخدام Builder Pattern

```dart
SuperTextPreview.builder(
  text: 'نص مع تخصيص كامل...',
  linkBuilder: (linkData) => Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text('🔗 ${linkData.text}'),
  ),
)
```

## نظام التوجيه المرن (Flexible Routing System)

تتيح المكتبة تعريف نظام توجيه مخصص للتطبيق، مما يسمح بالتعرف على الروابط الداخلية وتنفيذ إجراءات مخصصة عند النقر عليها (مثل الانتقال إلى شاشة معينة داخل التطبيق).

### 1. التهيئة (Configuration)

يجب تهيئة المفسر (Parser) قبل استخدامه، ويفضل أن يكون ذلك في دالة `main`:

```dart
void main() {
  SuperTextDataParser.configure(
    RouteConfig(
      // الروابط الأساسية التي سيتم اعتبارها روابط داخلية
      baseAddresses: ['https://myapp.com', 'myapp://'],
      routes: [
        // تعريف الروابط هنا
      ],
    ),
  );
  
  runApp(MyApp());
}
```

### 2. تعريف الروابط (Route Definitions)

يتم تعريف كل رابط باستخدام `RouteDefinition`. إليك بعض الأمثلة الشائعة:

#### أ. رابط ثابت (Static Route)
رابط لا يحتوي على متغيرات.
مثال: `https://myapp.com/settings`

```dart
RouteDefinition(
  name: 'settings',
  pattern: r'settings$', // Regex pattern
  parameterNames: {}, // لا يوجد متغيرات
  onNavigate: (context, data) {
    Navigator.pushNamed(context, '/settings');
  },
)
```

#### ب. رابط بمتغير واحد (Single Parameter Route)
رابط يحتوي على معرف (ID) أو متغير.
مثال: `https://myapp.com/users/123`

```dart
RouteDefinition(
  name: 'user-profile',
  pattern: r'users/([^/]+)', // ([^/]+) يلتقط أي نص حتى الفاصل التالي
  parameterNames: {'userId': true}, // تعريف اسم المتغير وأنه مطلوب
  onNavigate: (context, data) {
    // الوصول للمتغير عبر data.pathParameters
    final userId = data.pathParameters['userId'];
    Navigator.pushNamed(context, '/users', arguments: userId);
  },
)
```

#### ج. رابط بمتغيرات متعددة (Multi-Parameter Route)
رابط يحتوي على أكثر من متغير.
مثال: `https://myapp.com/shop/10/item/55`

```dart
RouteDefinition(
  name: 'shop-item',
  pattern: r'shop/([^/]+)/item/([^/]+)', // التقاط متغيرين
  parameterNames: {
    'shopId': true,
    'itemId': true,
  },
  onNavigate: (context, data) {
    final shopId = data.pathParameters['shopId'];
    final itemId = data.pathParameters['itemId'];
    Navigator.pushNamed(
      context, 
      '/shop/item', 
      arguments: {'shop': shopId, 'item': itemId},
    );
  },
)
```

### 3. كيفية كتابة الـ Patterns

نستخدم Regular Expressions (Regex) لتعريف نمط الرابط:
- `^` و `$` يتم إضافتها تلقائياً، فلا حاجة لكتابتها في بداية ونهاية النمط الكامل، ولكن يفضل استخدام `$` لنهاية الرابط إذا أردت تطابقاً تاماً.
- `([^/]+)` هو النمط الأكثر استخداماً لالتقاط قيمة متغير (يعني: أي سلسلة حروف لا تحتوي على `/`).
- `\d+` يمكن استخدامه إذا كنت تريد التقاط أرقام فقط.

أمثلة:
- `r'contact-us$'` يطابق `.../contact-us`
- `r'docs/([^/]+)/([^/]+)'` يطابق `.../docs/section/page`

للمزيد من المعلومات حول كتابة الأنماط، راجع [وثائق Dart RegExp](https://api.dart.dev/stable/dart-core/RegExp-class.html).

## API

### TextData Classes

- **NormalTextData**: النص العادي بدون تنسيق خاص
- **LinkTextData**: الروابط (HTTP/HTTPS)
- **EmailTextData**: عناوين البريد الإلكتروني
- **PhoneNumberTextData**: أرقام الهواتف
- **UsernameTextData**: أسماء المستخدمين (@username)
- **SocialMediaTextData**: روابط التواصل الاجتماعي
- **HashtagTextData**: الهاشتاغ (#hashtag)
- **RouteTextData**: الروابط الداخلية للتطبيق

### SuperTextPreview Properties

| الخاصية | النوع | الوصف |
|---------|-------|-------|
| `text` | `String?` | النص المراد معالجته |
| `parsedText` | `List<TextData>?` | النص المعالج مسبقاً |
| `textPreviewTheme` | `TextPreviewTheme?` | تخصيص المظهر |
| `onLinkTap` | `Function(LinkTextData)?` | النقر على رابط |
| `onEmailTap` | `Function(EmailTextData)?` | النقر على إيميل |
| `onPhoneTap` | `Function(PhoneNumberTextData)?` | النقر على رقم هاتف |
| `onUsernameTap` | `Function(UsernameTextData)?` | النقر على اسم مستخدم |
| `onHashtagTap` | `Function(HashtagTextData)?` | النقر على هاشتاغ |
| `onRouteTap` | `Function(RouteTextData)?` | النقر على رابط داخلي |
