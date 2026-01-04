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
