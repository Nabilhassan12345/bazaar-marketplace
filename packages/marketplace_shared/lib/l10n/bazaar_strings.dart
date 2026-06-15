import 'package:marketplace_shared/l10n/app_language.dart';
import 'package:marketplace_shared/l10n/legal_strings.dart';

/// Localized UI strings for Bazaar (mobile + admin).
class BazaarStrings {
  BazaarStrings(this.language);

  final AppLanguage language;

  String _t({required String en, required String fr, required String ar}) =>
      switch (language) {
        AppLanguage.fr => fr,
        AppLanguage.ar => ar,
        AppLanguage.en => en,
      };

  String get languageCode => language.code;

  bool get isRtl => language == AppLanguage.ar;

  // ─── App ─────────────────────────────────────────────────────
  String get appName => _t(en: 'Bazaar', fr: 'Bazaar', ar: 'بازار');
  String get appTagline => _t(
        en: 'Buy and sell locally',
        fr: 'Achetez et vendez localement',
        ar: 'اشترِ وبِع محلياً',
      );
  String get adminTitle => _t(
        en: 'Bazaar Admin',
        fr: 'Admin Bazaar',
        ar: 'إدارة بازار',
      );

  // ─── Navigation ──────────────────────────────────────────────
  String get navHome => _t(en: 'Home', fr: 'Accueil', ar: 'الرئيسية');
  String get navSearch => _t(en: 'Search', fr: 'Recherche', ar: 'بحث');
  String get navPost => _t(en: 'Post', fr: 'Publier', ar: 'نشر');
  String get navFavorites => _t(en: 'Favorites', fr: 'Favoris', ar: 'المفضلة');
  String get navProfile => _t(en: 'Profile', fr: 'Profil', ar: 'الملف الشخصي');
  String get navDashboard => _t(en: 'Dashboard', fr: 'Tableau de bord', ar: 'لوحة التحكم');
  String get navListings => _t(en: 'Listings', fr: 'Annonces', ar: 'الإعلانات');
  String get navUsers => _t(en: 'Users', fr: 'Utilisateurs', ar: 'المستخدمون');
  String get navReports => _t(en: 'Reports', fr: 'Signalements', ar: 'البلاغات');

  // ─── Auth ────────────────────────────────────────────────────
  String get welcomeTitle => _t(
        en: 'Welcome to Bazaar',
        fr: 'Bienvenue sur Bazaar',
        ar: 'مرحباً بك في بازار',
      );
  String get signInSubtitle => _t(
        en: 'Sign in to buy and sell locally',
        fr: 'Connectez-vous pour acheter et vendre',
        ar: 'سجّل الدخول للشراء والبيع',
      );
  String get email => _t(en: 'Email', fr: 'E-mail', ar: 'البريد الإلكتروني');
  String get password => _t(en: 'Password', fr: 'Mot de passe', ar: 'كلمة المرور');
  String get displayName => _t(en: 'Display name', fr: 'Nom affiché', ar: 'الاسم المعروض');
  String get signIn => _t(en: 'Sign In', fr: 'Se connecter', ar: 'تسجيل الدخول');
  String get signUp => _t(en: 'Sign Up', fr: "S'inscrire", ar: 'إنشاء حساب');
  String get continueWithGoogle => _t(
        en: 'Continue with Google',
        fr: 'Continuer avec Google',
        ar: 'المتابعة مع Google',
      );
  String get noAccountSignUp => _t(
        en: "Don't have an account? Sign up",
        fr: "Pas de compte ? Inscrivez-vous",
        ar: 'ليس لديك حساب؟ سجّل الآن',
      );
  String get hasAccountSignIn => _t(
        en: 'Already have an account? Sign in',
        fr: 'Déjà un compte ? Connectez-vous',
        ar: 'لديك حساب؟ سجّل الدخول',
      );
  String get createAccount => _t(
        en: 'Create account',
        fr: 'Créer un compte',
        ar: 'إنشاء حساب',
      );
  String get emailRequired => _t(
        en: 'Email is required',
        fr: 'E-mail requis',
        ar: 'البريد الإلكتروني مطلوب',
      );
  String get nameRequired => _t(
        en: 'Name is required',
        fr: 'Nom requis',
        ar: 'الاسم مطلوب',
      );
  String get passwordMinLength => _t(
        en: 'Password must be at least 6 characters',
        fr: 'Le mot de passe doit contenir au moins 6 caractères',
        ar: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      );
  String get signOut => _t(en: 'Sign Out', fr: 'Déconnexion', ar: 'تسجيل الخروج');
  String get logoutConfirmTitle => _t(en: 'Log out?', fr: 'Se déconnecter ?', ar: 'تسجيل الخروج؟');
  String get logoutConfirmMessage => _t(
        en: 'Are you sure you want to log out?',
        fr: 'Voulez-vous vraiment vous déconnecter ?',
        ar: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      );
  String get logout => _t(en: 'Log out', fr: 'Déconnexion', ar: 'خروج');
  String get accessDenied => _t(en: 'Access Denied', fr: 'Accès refusé', ar: 'تم رفض الوصول');
  String get accessDeniedMessage => _t(
        en: 'Your account does not have admin privileges.',
        fr: "Votre compte n'a pas les droits administrateur.",
        ar: 'حسابك لا يملك صلاحيات المسؤول.',
      );

  // ─── Categories ──────────────────────────────────────────────
  String get categoryCars => _t(en: 'Cars', fr: 'Voitures', ar: 'سيارات');
  String get categoryHouses => _t(en: 'Houses', fr: 'Maisons', ar: 'منازل');
  String get categorySecondHand => _t(
        en: 'Second-hand',
        fr: "Occasion",
        ar: 'مستعمل',
      );

  // ─── Listing status ──────────────────────────────────────────
  String listingStatus(String value) => switch (value) {
        'draft' => _t(en: 'Draft', fr: 'Brouillon', ar: 'مسودة'),
        'pending_review' => _t(en: 'Pending', fr: 'En attente', ar: 'قيد المراجعة'),
        'approved' => _t(en: 'Approved', fr: 'Approuvé', ar: 'موافق عليه'),
        'rejected' => _t(en: 'Rejected', fr: 'Rejeté', ar: 'مرفوض'),
        _ => value,
      };

  // ─── Listings ────────────────────────────────────────────────
  String get myListings => _t(en: 'My Listings', fr: 'Mes annonces', ar: 'إعلاناتي');
  String get createListing => _t(
        en: 'Create Listing',
        fr: 'Créer une annonce',
        ar: 'إنشاء إعلان',
      );
  String get editListing => _t(
        en: 'Edit Listing',
        fr: "Modifier l'annonce",
        ar: 'تعديل الإعلان',
      );
  String get title => _t(en: 'Title', fr: 'Titre', ar: 'العنوان');
  String get description => _t(en: 'Description', fr: 'Description', ar: 'الوصف');
  String get price => _t(en: 'Price', fr: 'Prix', ar: 'السعر');
  String get city => _t(en: 'City', fr: 'Ville', ar: 'المدينة');
  String get country => _t(en: 'Country', fr: 'Pays', ar: 'البلد');
  String get region => _t(en: 'Region', fr: 'Région', ar: 'المنطقة');
  String get district => _t(en: 'District', fr: 'Province / Département', ar: 'المقاطعة');
  String get category => _t(en: 'Category', fr: 'Catégorie', ar: 'الفئة');
  String get photos => _t(en: 'Photos', fr: 'Photos', ar: 'الصور');
  String get submitForReview => _t(
        en: 'Submit for Review',
        fr: 'Soumettre pour validation',
        ar: 'إرسال للمراجعة',
      );
  String get saveDraft => _t(en: 'Save Draft', fr: 'Enregistrer brouillon', ar: 'حفظ كمسودة');
  String get allCities => _t(en: 'All cities', fr: 'Toutes les villes', ar: 'كل المدن');
  String get all => _t(en: 'All', fr: 'Tout', ar: 'الكل');
  String get sortBy => _t(en: 'Sort by', fr: 'Trier par', ar: 'ترتيب حسب');
  String get selectCity => _t(en: 'Select city', fr: 'Choisir une ville', ar: 'اختر المدينة');
  String get selectCountry => _t(
        en: 'Select country',
        fr: 'Choisir un pays',
        ar: 'اختر البلد',
      );
  String get selectRegion => _t(
        en: 'Select region',
        fr: 'Choisir une région',
        ar: 'اختر المنطقة',
      );
  String get selectDistrict => _t(
        en: 'Select district',
        fr: 'Choisir une province',
        ar: 'اختر المقاطعة',
      );
  String get noListings => _t(
        en: 'No listings yet',
        fr: 'Aucune annonce',
        ar: 'لا توجد إعلانات',
      );
  String get noListingsHint => _t(
        en: 'Approved listings will appear here',
        fr: 'Les annonces approuvées apparaîtront ici',
        ar: 'ستظهر الإعلانات المعتمدة هنا',
      );
  String get views => _t(en: 'views', fr: 'vues', ar: 'مشاهدة');
  String get seller => _t(en: 'Seller', fr: 'Vendeur', ar: 'البائع');
  String get contactSeller => _t(
        en: 'Contact Seller',
        fr: 'Contacter le vendeur',
        ar: 'تواصل مع البائع',
      );
  String get reportListing => _t(
        en: 'Report Listing',
        fr: "Signaler l'annonce",
        ar: 'الإبلاغ عن الإعلان',
      );
  String get previewNote => _t(
        en: 'This is how your listing will appear once approved.',
        fr: 'Aperçu après validation de votre annonce.',
        ar: 'هكذا سيظهر إعلانك بعد الموافقة.',
      );

  // ─── Search ──────────────────────────────────────────────────
  String get searchHint => _t(
        en: 'Search listings...',
        fr: 'Rechercher des annonces...',
        ar: 'ابحث في الإعلانات...',
      );
  String get filters => _t(en: 'Filters', fr: 'Filtres', ar: 'الفلاتر');
  String get applyFilters => _t(en: 'Apply', fr: 'Appliquer', ar: 'تطبيق');
  String get clearFilters => _t(en: 'Clear', fr: 'Effacer', ar: 'مسح');
  String get recentSearches => _t(
        en: 'Recent searches',
        fr: 'Recherches récentes',
        ar: 'عمليات البحث الأخيرة',
      );
  String get minPrice => _t(en: 'Min price', fr: 'Prix min', ar: 'الحد الأدنى للسعر');
  String get maxPrice => _t(en: 'Max price', fr: 'Prix max', ar: 'الحد الأقصى للسعر');

  // ─── Favorites ───────────────────────────────────────────────
  String get favorites => _t(en: 'Favorites', fr: 'Favoris', ar: 'المفضلة');
  String get noFavorites => _t(
        en: 'No favorites yet',
        fr: 'Aucun favori',
        ar: 'لا توجد مفضلات',
      );
  String get noFavoritesHint => _t(
        en: 'Save listings you like to find them later',
        fr: 'Enregistrez les annonces que vous aimez',
        ar: 'احفظ الإعلانات التي تعجبك',
      );

  // ─── Profile & settings ──────────────────────────────────────
  String get profile => _t(en: 'Profile', fr: 'Profil', ar: 'الملف الشخصي');
  String get settings => _t(en: 'Settings', fr: 'Paramètres', ar: 'الإعدادات');
  String get editProfile => _t(
        en: 'Edit Profile',
        fr: 'Modifier le profil',
        ar: 'تعديل الملف الشخصي',
      );
  String get blockedUsers => _t(
        en: 'Blocked Users',
        fr: 'Utilisateurs bloqués',
        ar: 'المستخدمون المحظورون',
      );
  String get blockedUsersSubtitle => _t(
        en: 'Manage users you have blocked',
        fr: 'Gérez les utilisateurs bloqués',
        ar: 'إدارة المستخدمين المحظورين',
      );
  String get privacyPolicy => _t(
        en: 'Privacy Policy',
        fr: 'Politique de confidentialité',
        ar: 'سياسة الخصوصية',
      );
  String get termsOfService => _t(
        en: 'Terms of Service',
        fr: "Conditions d'utilisation",
        ar: 'شروط الخدمة',
      );
  String get contactUs => _t(en: 'Contact Us', fr: 'Nous contacter', ar: 'اتصل بنا');
  String get languageLabel => _t(en: 'Language', fr: 'Langue', ar: 'اللغة');
  String get notifications => _t(en: 'Notifications', fr: 'Notifications', ar: 'الإشعارات');
  String get comingSoon => _t(en: 'Coming soon', fr: 'Bientôt disponible', ar: 'قريباً');
  String get deleteAccount => _t(
        en: 'Delete My Account',
        fr: 'Supprimer mon compte',
        ar: 'حذف حسابي',
      );
  String get deleteAccountSubtitle => _t(
        en: 'Permanently delete your account and data',
        fr: 'Supprimer définitivement votre compte et vos données',
        ar: 'حذف حسابك وبياناتك نهائياً',
      );
  String get deleteAccountWarning => _t(
        en: 'This action cannot be undone. All your listings and data will be removed.',
        fr: 'Cette action est irréversible. Toutes vos annonces et données seront supprimées.',
        ar: 'لا يمكن التراجع. سيتم حذف جميع إعلاناتك وبياناتك.',
      );
  String get confirmDelete => _t(
        en: 'Delete Account',
        fr: 'Supprimer le compte',
        ar: 'حذف الحساب',
      );
  String get accountDeleted => _t(
        en: 'Account deleted',
        fr: 'Compte supprimé',
        ar: 'تم حذف الحساب',
      );
  String get listingsCount => _t(en: 'Listings', fr: 'Annonces', ar: 'إعلانات');
  String get memberSince => _t(en: 'Member since', fr: 'Membre depuis', ar: 'عضو منذ');

  // ─── Reports & blocks ────────────────────────────────────────
  String get report => _t(en: 'Report', fr: 'Signaler', ar: 'إبلاغ');
  String get reportUser => _t(
        en: 'Report User',
        fr: "Signaler l'utilisateur",
        ar: 'الإبلاغ عن المستخدم',
      );
  String get reportReason => _t(en: 'Reason', fr: 'Motif', ar: 'السبب');
  String get reportSubmitted => _t(
        en: 'Report submitted',
        fr: 'Signalement envoyé',
        ar: 'تم إرسال البلاغ',
      );
  String get block => _t(en: 'Block', fr: 'Bloquer', ar: 'حظر');
  String get unblock => _t(en: 'Unblock', fr: 'Débloquer', ar: 'إلغاء الحظر');
  String get blockUser => _t(
        en: 'Block User',
        fr: "Bloquer l'utilisateur",
        ar: 'حظر المستخدم',
      );
  String reportReasonLabel(String value) => switch (value) {
        'spam' => _t(en: 'Spam', fr: 'Spam', ar: 'رسائل مزعجة'),
        'fraud' => _t(en: 'Fraud', fr: 'Fraude', ar: 'احتيال'),
        'inappropriate' => _t(en: 'Inappropriate', fr: 'Inapproprié', ar: 'محتوى غير لائق'),
        'wrong_category' => _t(
          en: 'Wrong category',
          fr: 'Mauvaise catégorie',
          ar: 'فئة خاطئة',
        ),
        'other' => _t(en: 'Other', fr: 'Autre', ar: 'أخرى'),
        _ => value,
      };

  // ─── Admin ───────────────────────────────────────────────────
  String get totalUsers => _t(en: 'Total Users', fr: 'Utilisateurs', ar: 'إجمالي المستخدمين');
  String get totalListings => _t(en: 'Total Listings', fr: 'Annonces', ar: 'إجمالي الإعلانات');
  String get pendingListings => _t(en: 'Pending', fr: 'En attente', ar: 'قيد الانتظار');
  String get approvedListings => _t(en: 'Approved', fr: 'Approuvées', ar: 'معتمدة');
  String get rejectedListings => _t(en: 'Rejected', fr: 'Rejetées', ar: 'مرفوضة');
  String get openReports => _t(en: 'Open Reports', fr: 'Signalements ouverts', ar: 'بلاغات مفتوحة');
  String get approve => _t(en: 'Approve', fr: 'Approuver', ar: 'موافقة');
  String get reject => _t(en: 'Reject', fr: 'Rejeter', ar: 'رفض');
  String get status => _t(en: 'Status', fr: 'Statut', ar: 'الحالة');
  String get actions => _t(en: 'Actions', fr: 'Actions', ar: 'إجراءات');
  String get searchUsers => _t(
        en: 'Search users...',
        fr: 'Rechercher des utilisateurs...',
        ar: 'ابحث عن مستخدمين...',
      );
  String get searchListings => _t(
        en: 'Search listings...',
        fr: 'Rechercher des annonces...',
        ar: 'ابحث في الإعلانات...',
      );
  String get blocked => _t(en: 'Blocked', fr: 'Bloqué', ar: 'محظور');
  String get active => _t(en: 'Active', fr: 'Actif', ar: 'نشط');
  String get role => _t(en: 'Role', fr: 'Rôle', ar: 'الدور');
  String get adminLogin => _t(
        en: 'Admin Login',
        fr: 'Connexion admin',
        ar: 'دخول المسؤول',
      );

  // ─── Common ──────────────────────────────────────────────────
  String get save => _t(en: 'Save', fr: 'Enregistrer', ar: 'حفظ');
  String get cancel => _t(en: 'Cancel', fr: 'Annuler', ar: 'إلغاء');
  String get close => _t(en: 'Close', fr: 'Fermer', ar: 'إغلاق');
  String get retry => _t(en: 'Retry', fr: 'Réessayer', ar: 'إعادة المحاولة');
  String get loading => _t(en: 'Loading...', fr: 'Chargement...', ar: 'جاري التحميل...');
  String get error => _t(en: 'Error', fr: 'Erreur', ar: 'خطأ');
  String get success => _t(en: 'Success', fr: 'Succès', ar: 'نجاح');
  String get yes => _t(en: 'Yes', fr: 'Oui', ar: 'نعم');
  String get no => _t(en: 'No', fr: 'Non', ar: 'لا');

  // ─── Legal (full text) ───────────────────────────────────────
  String get privacyPolicyContent => LegalStrings.privacyPolicy(language);
  String get termsOfServiceContent => LegalStrings.termsOfService(language);
  String get contactUsContent => LegalStrings.contactUs(language);
}
