import 'package:marketplace_shared/l10n/app_language.dart';

abstract final class LegalStrings {
  static String privacyPolicy(AppLanguage language) => switch (language) {
        AppLanguage.fr => _privacyFr,
        AppLanguage.ar => _privacyAr,
        AppLanguage.en => _privacyEn,
      };

  static String termsOfService(AppLanguage language) => switch (language) {
        AppLanguage.fr => _termsFr,
        AppLanguage.ar => _termsAr,
        AppLanguage.en => _termsEn,
      };

  static String contactUs(AppLanguage language) => switch (language) {
        AppLanguage.fr => _contactFr,
        AppLanguage.ar => _contactAr,
        AppLanguage.en => _contactEn,
      };

  static const _privacyEn = '''
Privacy Policy

Last updated: June 2026

Bazaar ("we", "our", or "us") operates a marketplace mobile application serving Burkina Faso, Côte d'Ivoire, and Sudan. This policy explains how we collect, use, and protect your information.

What We Collect
• Name and display name — when you create or edit your profile.
• Email address — for sign-in, communication, and account recovery.
• Listing data — titles, descriptions, prices, categories, cities, and status.
• Photos — images you upload for listings or your profile.
• Usage data — favorites, search activity, and listing views.

How We Use Your Information
• Operate the marketplace and display listings to buyers and sellers.
• Create and manage your account.
• Process listings, favorites, and profile updates.
• Improve safety, performance, and user experience.
• Respond to support requests and enforce our Terms of Service.

Firebase and Google Services
Bazaar uses Google Firebase for authentication, database storage, file storage, and analytics. Your data is processed according to Google's privacy policies and stored on Google Cloud infrastructure.

How to Delete Your Account
Settings → Delete My Account. This permanently removes your profile, listings, and favorites.

Contact: privacy@bazaarapp.com
''';

  static const _privacyFr = '''
Politique de confidentialité

Dernière mise à jour : juin 2026

Bazaar (« nous ») exploite une application de petites annonces au Burkina Faso, en Côte d'Ivoire et au Soudan. Cette politique explique comment nous collectons, utilisons et protégeons vos informations.

Données collectées
• Nom et nom affiché — lors de la création ou modification du profil.
• Adresse e-mail — pour la connexion, la communication et la récupération de compte.
• Données d'annonces — titres, descriptions, prix, catégories, villes et statut.
• Photos — images téléversées pour les annonces ou le profil.
• Données d'utilisation — favoris, recherches et vues d'annonces.

Utilisation des données
• Exploiter la place de marché et afficher les annonces.
• Créer et gérer votre compte.
• Traiter les annonces, favoris et mises à jour de profil.
• Améliorer la sécurité, les performances et l'expérience utilisateur.
• Répondre aux demandes d'assistance et faire respecter nos Conditions.

Firebase et services Google
Bazaar utilise Google Firebase pour l'authentification, la base de données, le stockage de fichiers et l'analytique.

Suppression du compte
Paramètres → Supprimer mon compte. Cette action supprime définitivement votre profil, vos annonces et vos favoris.

Contact : privacy@bazaarapp.com
''';

  static const _privacyAr = '''
سياسة الخصوصية

آخر تحديث: يونيو 2026

تدير بازار تطبيق سوق إلكتروني يخدم بوركينا فاسو وساحل العاج والسودان. توضح هذه السياسة كيفية جمع معلوماتك واستخدامها وحمايتها.

البيانات التي نجمعها
• الاسم والاسم المعروض — عند إنشاء أو تعديل الملف الشخصي.
• البريد الإلكتروني — لتسجيل الدخول والتواصل واستعادة الحساب.
• بيانات الإعلانات — العناوين والأوصاف والأسعار والفئات والمدن والحالة.
• الصور — التي ترفعها للإعلانات أو الملف الشخصي.
• بيانات الاستخدام — المفضلة والبحث ومشاهدات الإعلانات.

كيف نستخدم معلوماتك
• تشغيل السوق وعرض الإعلانات للمشترين والبائعين.
• إنشاء حسابك وإدارته.
• معالجة الإعلانات والمفضلة وتحديثات الملف الشخصي.
• تحسين الأمان والأداء وتجربة المستخدم.
• الرد على طلبات الدعم وإنفاذ شروط الخدمة.

خدمات Firebase وGoogle
يستخدم بازار Google Firebase للمصادقة وقاعدة البيانات وتخزين الملفات والتحليلات.

حذف الحساب
الإعدادات → حذف حسابي. يحذف هذا ملفك وإعلاناتك ومفضلاتك نهائياً.

للتواصل: privacy@bazaarapp.com
''';

  static const _termsEn = '''
Terms of Service

Last updated: June 2026

Welcome to Bazaar. By using our marketplace in Burkina Faso, Côte d'Ivoire, or Sudan, you agree to these Terms.

Using Bazaar
You are responsible for the accuracy of your listings and your interactions with other users.

Prohibited Items
You may not list weapons, illegal drugs, stolen goods, adult content, or any item that violates local or international law.

Account Suspension
We may suspend accounts that post prohibited items, engage in fraud or harassment, receive valid reports, or violate these Terms.

Transactions
Bazaar is a platform only. We do not process payments between users. You are responsible for safe meetings and verifying items before purchase.

Contact: support@bazaarapp.com
''';

  static const _termsFr = '''
Conditions d'utilisation

Dernière mise à jour : juin 2026

Bienvenue sur Bazaar. En utilisant notre place de marché au Burkina Faso, en Côte d'Ivoire ou au Soudan, vous acceptez ces Conditions.

Utilisation
Vous êtes responsable de l'exactitude de vos annonces et de vos échanges avec les autres utilisateurs.

Articles interdits
Armes, drogues illégales, biens volés, contenu pour adultes ou tout article illégal sont interdits.

Suspension de compte
Nous pouvons suspendre les comptes qui publient des articles interdits, commettent une fraude ou un harcèlement, reçoivent des signalements valides ou violent ces Conditions.

Transactions
Bazaar est une plateforme uniquement. Nous ne traitons pas les paiements entre utilisateurs. Vous êtes responsable des rencontres en toute sécurité.

Contact : support@bazaarapp.com
''';

  static const _termsAr = '''
شروط الخدمة

آخر تحديث: يونيو 2026

مرحباً بك في بازار. باستخدام سوقنا في بوركينا فاسو أو ساحل العاج أو السودان، فإنك توافق على هذه الشروط.

استخدام بازار
أنت مسؤول عن دقة إعلاناتك وتفاعلاتك مع المستخدمين الآخرين.

العناصر المحظورة
يُحظر إدراج الأسلحة أو المخدرات غير المشروعة أو المسروقات أو المحتوى الإباحي أو أي عنصر يخالف القانون.

تعليق الحساب
قد نعلق الحسابات التي تنشر عناصر محظورة أو تمارس الاحتيال أو المضايقة أو تتلقى بلاغات صحيحة.

المعاملات
بازار منصة فقط. لا نعالج المدفوعات بين المستخدمين. أنت مسؤول عن اللقاءات الآمنة والتحقق من المنتجات.

للتواصل: support@bazaarapp.com
''';

  static const _contactEn = '''
Contact Us

We serve users in Burkina Faso, Côte d'Ivoire, and Sudan.

Support: support@bazaarapp.com
Privacy: privacy@bazaarapp.com

For listing issues, account problems, or safety concerns, email us and we will respond as soon as possible.
''';

  static const _contactFr = '''
Nous contacter

Nous servons les utilisateurs au Burkina Faso, en Côte d'Ivoire et au Soudan.

Assistance : support@bazaarapp.com
Confidentialité : privacy@bazaarapp.com

Pour tout problème d'annonce, de compte ou de sécurité, écrivez-nous et nous vous répondrons dès que possible.
''';

  static const _contactAr = '''
اتصل بنا

نخدم المستخدمين في بوركينا فاسو وساحل العاج والسودان.

الدعم: support@bazaarapp.com
الخصوصية: privacy@bazaarapp.com

للمشاكل المتعلقة بالإعلانات أو الحساب أو السلامة، راسلنا وسنرد في أقرب وقت.
''';
}
