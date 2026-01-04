# خطة: جعل الـ Routes مرنة وقابلة للتخصيص

## المشكلة الحالية

حالياً `RouteType` هو enum ثابت يحتوي على routes خاصة بتطبيق معين (ClubApp)، مما يجعل المكتبة غير قابلة للاستخدام في تطبيقات أخرى.

---

## الحل المقترح

### 1. إنشاء كلاس `RouteDefinition`

كلاس يحتوي على تعريف الراوتر:

```dart
class RouteDefinition {
  /// اسم الراوتر الفريد
  final String name;
  
  /// نمط المسار regex لمطابقة الرابط
  /// أمثلة:
  /// - Static: r'^login$', r'^signup$', r'^search$'
  /// - Single param: r'^Clubs/([^/]+)$', r'^Plans/([^/]+)$'
  /// - Multi params: r'^Clubs/([^/]+)/News/([^/]+)$'
  /// - Nested: r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/([^/]+)$'
  /// - With action: r'^Clubs/([^/]+)/edit$', r'^Clubs/([^/]+)/News/modify$'
  final String pattern;
  
  /// خريطة المتغيرات المتوقعة مع حالة الإلزام
  /// key = اسم المتغير, value = هل هو إلزامي؟
  /// مثال: {'clubId': true, 'tab': false}
  /// إذا كان المتغير الإلزامي ناقصاً، يُعتبر النص رابط خارجي
  final Map<String, bool>? parameterNames;
  
  /// callback للتنقل
  final void Function(BuildContext context, RouteTextData data)? onNavigate;
  
  /// التحقق من صحة المتغيرات المستخرجة
  bool validateParameters(Map<String, String> extractedParams) {
    if (parameterNames == null) return true;
    
    for (final entry in parameterNames!.entries) {
      final isRequired = entry.value;
      final paramExists = extractedParams.containsKey(entry.key) && 
                          extractedParams[entry.key]?.isNotEmpty == true;
      
      // إذا كان المتغير إلزامي وغير موجود، فشل التحقق
      if (isRequired && !paramExists) {
        return false;
      }
    }
    return true;
  }
}
```

---

### 2. إنشاء كلاس `RouteConfig`

كلاس يحتوي على إعدادات الـ routes للتطبيق:

```dart
class RouteConfig {
  /// قائمة عناوين التطبيق الأساسية
  /// مثال: ['https://myapp.page.link', 'https://myapp.com', 'myapp://']
  final List<String> baseAddresses;
  
  /// قائمة تعريفات الـ routes
  final List<RouteDefinition> routes;
  
  const RouteConfig({
    required this.baseAddresses,
    required this.routes,
  });
  
  /// التحقق من أن الرابط ينتمي لأحد عناوين التطبيق
  bool isAppLink(String url) {
    return baseAddresses.any((base) => url.startsWith(base));
  }
  
  /// استخراج المسار من الرابط (بعد إزالة العنوان الأساسي)
  String? extractPath(String url) {
    for (final base in baseAddresses) {
      if (url.startsWith(base)) {
        return url.replaceFirst(base, '');
      }
    }
    return null;
  }
  
  /// البحث عن route بالاسم
  RouteDefinition? findByName(String name) {
    return routes.firstWhereOrNull((r) => r.name == name);
  }
  
  /// مطابقة URL مع route مناسب
  /// يُرجع null إذا لم يتطابق أو إذا كانت المتغيرات الإلزامية ناقصة
  RouteDefinition? matchUrl(String url) {
    final path = extractPath(url);
    if (path == null) return null;
    
    for (final route in routes) {
      final params = _extractParameters(path, route.pattern);
      if (params != null && route.validateParameters(params)) {
        return route;
      }
    }
    return null; // يُعتبر رابط خارجي
  }
}
```

---

### 3. تحديث `RouteTextData`

```dart
class RouteTextData extends SuperTextData {
  /// تعريف الراوتر المطابق
  final RouteDefinition routeDefinition;
  
  /// الـ path parameters المستخرجة
  final Map<String, String> pathParameters;
  
  /// الـ query parameters المستخرجة
  final Map<String, String>? queryParameters;
  
  /// المسار بدون العنوان الأساسي
  final String path;
}
```

---

### 4. مثال على الاستخدام

```dart
// إعداد الـ routes عند بدء التطبيق
final routeConfig = RouteConfig(
  baseAddresses: [
    'https://myapp.page.link',
    'https://myapp.com',
    'myapp://',
  ],
  routes: [
    RouteDefinition(
      name: 'home',
      pattern: '/',
    ),
    RouteDefinition(
      name: 'clubDetails',
      pattern: '/clubs/:clubId',
      parameterNames: {
        'clubId': true,  // إلزامي - إذا لم يوجد يُعتبر رابط خارجي
      },
      onNavigate: (data) {
        GoRouter.of(context).go('/clubs/${data.pathParameters['clubId']}');
      },
    ),
    RouteDefinition(
      name: 'clubMembers',
      pattern: '/clubs/:clubId/members',
      parametersMap: {
        'clubId': true,   // إلزامي
        'page': false,    // اختياري
      },
    ),
  ],
);

// تمرير الإعدادات للـ parser
SuperTextDataParser.configure(routeConfig);
```

---

### 5. سيناريو التحقق من المتغيرات

```dart
// Route: /clubs/:clubId/members
// parametersMap: {'clubId': true, 'page': false}

// ✅ صالح: https://myapp.com/clubs/123/members
// -> clubId موجود (إلزامي) ✓

// ✅ صالح: https://myapp.com/clubs/123/members?page=2
// -> clubId موجود (إلزامي) ✓, page موجود (اختياري) ✓

// ❌ غير صالح - يُعتبر رابط خارجي: https://myapp.com/clubs//members
// -> clubId فارغ (إلزامي) ✗
```

---

## الملفات المطلوب تعديلها

| الملف | التغيير |
|-------|---------|
| `lib/src/model/route_definition.dart` | **[جديد]** كلاس `RouteDefinition` |
| `lib/src/model/route_config.dart` | **[جديد]** كلاس `RouteConfig` |
| `lib/src/model/super_text_data.dart` | تحديث `RouteTextData` + حذف `RouteType` enum |
| `lib/src/model/super_text_data_parser.dart` | تحديث الـ parser ليستخدم `RouteConfig` |
| `lib/src/super_text_preview_library.dart` | إضافة الملفات الجديدة |

---

## أسئلة متبقية للنقاش

1. **هل تريد دعم الـ query parameters في الـ pattern؟**
   - مثلاً: `/clubs/:clubId?tab=:tab`

2. **هل تريد إضافة regex validators للمتغيرات؟**
   - مثلاً: `clubId` يجب أن يكون رقم فقط

3. **هل تريد دعم wildcard patterns؟**
   - مثلاً: `/clubs/*` يطابق أي مسار يبدأ بـ `/clubs/`

---

## الخطوة التالية

بعد الموافقة على الخطة، سأبدأ بـ:
1. إنشاء `RouteDefinition` class
2. إنشاء `RouteConfig` class
3. تحديث `RouteTextData`
4. تحديث الـ parser
