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
  String get viewsLabel => _t(en: 'Views', fr: 'Vues', ar: 'المشاهدات');
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
        en: 'Tap the heart on any listing to save it here.',
        fr: 'Appuyez sur le cœur pour enregistrer une annonce ici',
        ar: 'اضغط على القلب في أي إعلان لحفظه هنا',
      );
  String get savedItems => _t(
        en: 'Saved Items',
        fr: 'Enregistrés',
        ar: 'المحفوظات',
      );
  String get noSavedListings => _t(
        en: 'No saved listings yet',
        fr: 'Aucune annonce enregistrée',
        ar: 'لا توجد إعلانات محفوظة',
      );
  String get browse => _t(en: 'Browse', fr: 'Parcourir', ar: 'تصفح');
  String get postAnAd => _t(
        en: 'Post an ad',
        fr: 'Publier une annonce',
        ar: 'نشر إعلان',
      );
  String get homeEmptyHint => _t(
        en: 'Check back soon or post your own ad.',
        fr: 'Revenez bientôt ou publiez votre annonce.',
        ar: 'عد لاحقاً أو انشر إعلانك الخاص.',
      );
  String get myListingsEmptyHint => _t(
        en: 'Post your first ad to start selling.',
        fr: 'Publiez votre première annonce pour commencer à vendre.',
        ar: 'انشر إعلانك الأول لبدء البيع.',
      );
  String get postSubtitle => _t(
        en: 'Sell cars, houses, or second-hand items',
        fr: 'Vendez des voitures, maisons ou articles d\'occasion',
        ar: 'بِع سيارات أو منازل أو سلع مستعملة',
      );
  String get categories => _t(en: 'Categories', fr: 'Catégories', ar: 'الفئات');
  String get notSignedIn => _t(
        en: 'Not signed in',
        fr: 'Non connecté',
        ar: 'غير مسجل الدخول',
      );
  String memberSince(String date) => _t(
        en: 'Member since $date',
        fr: 'Membre depuis $date',
        ar: 'عضو منذ $date',
      );

  // ─── Search extras ─────────────────────────────────────────────
  String get searchEmptyHint => _t(
        en: 'Search for cars, houses, and more',
        fr: 'Recherchez des voitures, maisons et plus',
        ar: 'ابحث عن سيارات ومنازل والمزيد',
      );
  String noListingsFoundFor(String query) => _t(
        en: "No listings found for '$query'",
        fr: "Aucune annonce pour « $query »",
        ar: "لا توجد إعلانات لـ \"$query\"",
      );
  String resultCountLabel(int count, {bool hasMore = false}) {
    if (count == 0) {
      return _t(en: '0 results', fr: '0 résultat', ar: '0 نتيجة');
    }
    if (hasMore) {
      return _t(
        en: '$count+ results',
        fr: '$count+ résultats',
        ar: '$count+ نتيجة',
      );
    }
    if (count == 1) {
      return _t(en: '1 result', fr: '1 résultat', ar: 'نتيجة واحدة');
    }
    return _t(en: '$count results', fr: '$count résultats', ar: '$count نتيجة');
  }

  String get sortNewest => _t(en: 'Newest first', fr: 'Plus récent', ar: 'الأحدث أولاً');
  String get sortPriceLowToHigh => _t(
        en: 'Price: low to high',
        fr: 'Prix : croissant',
        ar: 'السعر: من الأقل للأعلى',
      );
  String get sortPriceHighToLow => _t(
        en: 'Price: high to low',
        fr: 'Prix : décroissant',
        ar: 'السعر: من الأعلى للأقل',
      );
  String minPriceChip(double value) => _t(
        en: 'Min ${value.toStringAsFixed(0)}',
        fr: 'Min ${value.toStringAsFixed(0)}',
        ar: 'الحد الأدنى ${value.toStringAsFixed(0)}',
      );
  String maxPriceChip(double value) => _t(
        en: 'Max ${value.toStringAsFixed(0)}',
        fr: 'Max ${value.toStringAsFixed(0)}',
        ar: 'الحد الأقصى ${value.toStringAsFixed(0)}',
      );

  // ─── Listing detail ────────────────────────────────────────────
  String get listing => _t(en: 'Listing', fr: 'Annonce', ar: 'إعلان');
  String get listingNotFound => _t(
        en: 'Listing not found',
        fr: 'Annonce introuvable',
        ar: 'الإعلان غير موجود',
      );
  String get couldNotOpenLink => _t(
        en: 'Could not open link.',
        fr: 'Impossible d\'ouvrir le lien.',
        ar: 'تعذر فتح الرابط.',
      );
  String get sellerPhoneUnavailable => _t(
        en: 'Seller phone number not available.',
        fr: 'Numéro du vendeur indisponible.',
        ar: 'رقم هاتف البائع غير متوفر.',
      );
  String get viewSellerProfile => _t(
        en: 'View seller profile',
        fr: 'Voir le profil du vendeur',
        ar: 'عرض ملف البائع',
      );
  String get callSeller => _t(
        en: 'Call Seller',
        fr: 'Appeler le vendeur',
        ar: 'اتصال بالبائع',
      );
  String get whatsApp => _t(en: 'WhatsApp', fr: 'WhatsApp', ar: 'واتساب');
  String get reportListingLower => _t(
        en: 'Report listing',
        fr: "Signaler l'annonce",
        ar: 'الإبلاغ عن الإعلان',
      );

  // ─── Create listing flow ───────────────────────────────────────
  String get stepDetails => _t(en: 'Details', fr: 'Détails', ar: 'التفاصيل');
  String get stepImages => _t(en: 'Images', fr: 'Images', ar: 'الصور');
  String get stepPreview => _t(en: 'Preview', fr: 'Aperçu', ar: 'معاينة');
  String get stepSubmit => _t(en: 'Submit', fr: 'Envoi', ar: 'إرسال');
  String get preview => _t(en: 'Preview', fr: 'Aperçu', ar: 'معاينة');
  String get imagesCompressionNote => _t(
        en: 'Images are compressed (max 800px, 70% quality) and uploaded to Firebase Storage.',
        fr: 'Les images sont compressées (max 800 px, 70 %) et envoyées sur Firebase Storage.',
        ar: 'يتم ضغط الصور (بحد أقصى 800 بكسل، جودة 70%) ورفعها إلى Firebase Storage.',
      );
  String get completePreviousSteps => _t(
        en: 'Complete previous steps to preview.',
        fr: 'Complétez les étapes précédentes pour prévisualiser.',
        ar: 'أكمل الخطوات السابقة للمعاينة.',
      );
  String get listingUpdated => _t(
        en: 'Listing updated!',
        fr: 'Annonce mise à jour !',
        ar: 'تم تحديث الإعلان!',
      );
  String get listingSubmitted => _t(
        en: 'Listing submitted!',
        fr: 'Annonce soumise !',
        ar: 'تم إرسال الإعلان!',
      );
  String get listingChangesSaved => _t(
        en: 'Your changes have been saved.',
        fr: 'Vos modifications ont été enregistrées.',
        ar: 'تم حفظ تغييراتك.',
      );
  String get listingPendingReview => _t(
        en: 'Your listing is pending review.',
        fr: 'Votre annonce est en attente de validation.',
        ar: 'إعلانك قيد المراجعة.',
      );
  String get submittingListing => _t(
        en: 'Submitting your listing...',
        fr: 'Envoi de votre annonce...',
        ar: 'جاري إرسال إعلانك...',
      );
  String get readyToSubmit => _t(
        en: 'Ready to submit.',
        fr: 'Prêt à envoyer.',
        ar: 'جاهز للإرسال.',
      );
  String get goToMyListings => _t(
        en: 'Go to My Listings',
        fr: 'Voir mes annonces',
        ar: 'الذهاب إلى إعلاناتي',
      );
  String get back => _t(en: 'Back', fr: 'Retour', ar: 'رجوع');
  String get next => _t(en: 'Next', fr: 'Suivant', ar: 'التالي');
  String get saveChanges => _t(
        en: 'Save Changes',
        fr: 'Enregistrer',
        ar: 'حفظ التغييرات',
      );
  String get deleteAction => _t(en: 'Delete', fr: 'Supprimer', ar: 'حذف');
  String get phoneNumber => _t(
        en: 'Phone number',
        fr: 'Numéro de téléphone',
        ar: 'رقم الهاتف',
      );
  String get phone => _t(en: 'Phone', fr: 'Téléphone', ar: 'الهاتف');
  String get bio => _t(en: 'Bio', fr: 'Bio', ar: 'نبذة');
  String get nameLabel => _t(en: 'Name', fr: 'Nom', ar: 'الاسم');
  String get failedToSaveProfile => _t(
        en: 'Failed to save profile.',
        fr: 'Échec de l\'enregistrement du profil.',
        ar: 'فشل حفظ الملف الشخصي.',
      );

  // ─── Validation errors ─────────────────────────────────────────
  String get errCompleteRequiredFields => _t(
        en: 'Please complete all required fields.',
        fr: 'Veuillez remplir tous les champs obligatoires.',
        ar: 'يرجى إكمال جميع الحقول المطلوبة.',
      );
  String get errWaitForUpload => _t(
        en: 'Please wait for images to finish uploading.',
        fr: 'Veuillez attendre la fin du téléversement des images.',
        ar: 'يرجى انتظار اكتمال رفع الصور.',
      );
  String get errAddOneImage => _t(
        en: 'Add at least one image.',
        fr: 'Ajoutez au moins une image.',
        ar: 'أضف صورة واحدة على الأقل.',
      );
  String maxImagesError(int max) => _t(
        en: 'Maximum $max images.',
        fr: 'Maximum $max images.',
        ar: 'الحد الأقصى $max صور.',
      );
  String get errImageUploadFailed => _t(
        en: 'Image upload failed.',
        fr: 'Échec du téléversement de l\'image.',
        ar: 'فشل رفع الصورة.',
      );
  String get errCompleteStepsBeforeSubmit => _t(
        en: 'Complete all steps before submitting.',
        fr: 'Complétez toutes les étapes avant d\'envoyer.',
        ar: 'أكمل جميع الخطوات قبل الإرسال.',
      );
  String get errSubmitFailed => _t(
        en: 'Failed to submit listing. Please try again.',
        fr: 'Échec de l\'envoi. Veuillez réessayer.',
        ar: 'فشل إرسال الإعلان. حاول مرة أخرى.',
      );

  // ─── My listings ───────────────────────────────────────────────
  String get deleteListingTitle => _t(
        en: 'Delete listing?',
        fr: 'Supprimer l\'annonce ?',
        ar: 'حذف الإعلان؟',
      );
  String get deleteListingMessage => _t(
        en: 'This action cannot be undone. Your listing will be removed.',
        fr: 'Cette action est irréversible. Votre annonce sera supprimée.',
        ar: 'لا يمكن التراجع. سيتم حذف إعلانك.',
      );
  String get listingDeleted => _t(
        en: 'Listing deleted.',
        fr: 'Annonce supprimée.',
        ar: 'تم حذف الإعلان.',
      );
  String get listingDeleteFailed => _t(
        en: 'Failed to delete listing.',
        fr: 'Échec de la suppression.',
        ar: 'فشل حذف الإعلان.',
      );

  // ─── Seller profile ────────────────────────────────────────────
  String get sellerProfile => _t(
        en: 'Seller Profile',
        fr: 'Profil du vendeur',
        ar: 'ملف البائع',
      );
  String get sellerNotFound => _t(
        en: 'Seller not found.',
        fr: 'Vendeur introuvable.',
        ar: 'البائع غير موجود.',
      );
  String get noActiveListings => _t(
        en: 'No active listings',
        fr: 'Aucune annonce active',
        ar: 'لا توجد إعلانات نشطة',
      );
  String blockUserTitle(String name) => _t(
        en: 'Block $name?',
        fr: 'Bloquer $name ?',
        ar: 'حظر $name؟',
      );
  String userBlocked(String name) => _t(
        en: '$name blocked',
        fr: '$name bloqué',
        ar: 'تم حظر $name',
      );
  String get blockUserMessage => _t(
        en: "Their listings won't appear in your feed.",
        fr: 'Leurs annonces n\'apparaîtront plus dans votre fil.',
        ar: 'لن تظهر إعلاناتهم في خلاصتك.',
      );
  String sellerListingCount(int count) => _t(
        en: '$count listings',
        fr: '$count annonces',
        ar: '$count إعلانات',
      );
  String get blockThisUser => _t(
        en: 'Block this user',
        fr: 'Bloquer cet utilisateur',
        ar: 'حظر هذا المستخدم',
      );
  String get reportThisSeller => _t(
        en: 'Report this seller',
        fr: 'Signaler ce vendeur',
        ar: 'الإبلاغ عن هذا البائع',
      );
  String get reportThisListing => _t(
        en: 'Report this listing',
        fr: 'Signaler cette annonce',
        ar: 'الإبلاغ عن هذا الإعلان',
      );
  String get alreadyReported => _t(
        en: 'Already reported',
        fr: 'Déjà signalé',
        ar: 'تم الإبلاغ مسبقاً',
      );
  String get signInToReport => _t(
        en: 'Please sign in to report.',
        fr: 'Connectez-vous pour signaler.',
        ar: 'يرجى تسجيل الدخول للإبلاغ.',
      );
  String get addDetailsOptional => _t(
        en: 'Add details (optional)',
        fr: 'Détails (facultatif)',
        ar: 'تفاصيل إضافية (اختياري)',
      );
  String get submit => _t(en: 'Submit', fr: 'Envoyer', ar: 'إرسال');
  String get reportSubmittedListing => _t(
        en: "Thanks — we'll review this listing",
        fr: 'Merci — nous examinerons cette annonce',
        ar: 'شكراً — سنراجع هذا الإعلان',
      );
  String get reportSubmittedUser => _t(
        en: "Thanks — we'll review this report",
        fr: 'Merci — nous examinerons ce signalement',
        ar: 'شكراً — سنراجع هذا البلاغ',
      );

  // ─── Contact & legal footer ────────────────────────────────────
  String get contactUsHeading => _t(
        en: 'We\'re here to help',
        fr: 'Nous sommes là pour vous aider',
        ar: 'نحن هنا لمساعدتك',
      );
  String get contactUsBody => _t(
        en: 'Have a question, issue, or feedback? Reach out to our support team.',
        fr: 'Une question, un problème ou un avis ? Contactez notre équipe.',
        ar: 'لديك سؤال أو مشكلة أو ملاحظة؟ تواصل مع فريق الدعم.',
      );
  String get emailUs => _t(en: 'Email us', fr: 'Nous écrire', ar: 'راسلنا');
  String get couldNotOpenEmail => _t(
        en: 'Could not open email app.',
        fr: 'Impossible d\'ouvrir l\'application e-mail.',
        ar: 'تعذر فتح تطبيق البريد.',
      );
  String get appVersion => _t(en: 'App version', fr: 'Version', ar: 'إصدار التطبيق');
  String get unknown => _t(en: 'Unknown', fr: 'Inconnu', ar: 'غير معروف');
  String get unknownUser => _t(
        en: 'Unknown user',
        fr: 'Utilisateur inconnu',
        ar: 'مستخدم غير معروف',
      );
  String get legalAgreePrefix => _t(
        en: 'By continuing, you agree to our ',
        fr: 'En continuant, vous acceptez nos ',
        ar: 'بالمتابعة، فإنك توافق على ',
      );
  String get legalAnd => _t(en: ' and ', fr: ' et ', ar: ' و');

  // ─── Delete account ────────────────────────────────────────────
  String get deleteAccountPermanent => _t(
        en: 'This action is permanent',
        fr: 'Cette action est définitive',
        ar: 'هذا الإجراء نهائي',
      );
  String get deleteAccountWill => _t(
        en: 'Deleting your account will:',
        fr: 'La suppression de votre compte va :',
        ar: 'حذف حسابك سيؤدي إلى:',
      );
  String get deleteBulletListings => _t(
        en: 'Remove all your listings from Bazaar',
        fr: 'Supprimer toutes vos annonces sur Bazaar',
        ar: 'إزالة جميع إعلاناتك من بازار',
      );
  String get deleteBulletFavorites => _t(
        en: 'Delete your saved favorites',
        fr: 'Supprimer vos favoris enregistrés',
        ar: 'حذف المفضلات المحفوظة',
      );
  String get deleteBulletProfile => _t(
        en: 'Erase your profile and account data',
        fr: 'Effacer votre profil et vos données',
        ar: 'مسح ملفك وبيانات حسابك',
      );
  String get deleteBulletCredentials => _t(
        en: 'Sign you out and delete your login credentials',
        fr: 'Vous déconnecter et supprimer vos identifiants',
        ar: 'تسجيل خروجك وحذف بيانات الدخول',
      );
  String get deleteAccountFinalWarning => _t(
        en: 'This cannot be undone. You will need to create a new account to use Bazaar again.',
        fr: 'Cette action est irréversible. Vous devrez créer un nouveau compte.',
        ar: 'لا يمكن التراجع. ستحتاج إلى إنشاء حساب جديد لاستخدام بازار مجدداً.',
      );
  String get continueAction => _t(en: 'Continue', fr: 'Continuer', ar: 'متابعة');
  String get confirmIdentity => _t(
        en: 'Confirm your identity',
        fr: 'Confirmez votre identité',
        ar: 'أكد هويتك',
      );
  String get reauthGoogleDelete => _t(
        en: 'Re-authenticate with Google to confirm account deletion.',
        fr: 'Réauthentifiez-vous avec Google pour confirmer la suppression.',
        ar: 'أعد المصادقة عبر Google لتأكيد حذف الحساب.',
      );
  String get reauthPasswordDelete => _t(
        en: 'Enter your password to confirm account deletion.',
        fr: 'Entrez votre mot de passe pour confirmer la suppression.',
        ar: 'أدخل كلمة المرور لتأكيد حذف الحساب.',
      );
  String get reauthAndDelete => _t(
        en: 'Re-authenticate & delete account',
        fr: 'Réauthentifier et supprimer',
        ar: 'إعادة المصادقة وحذف الحساب',
      );
  String get deleteMyAccountAction => _t(
        en: 'Delete my account',
        fr: 'Supprimer mon compte',
        ar: 'حذف حسابي',
      );
  String get deleteAccountFailed => _t(
        en: 'Failed to delete account. Please try again.',
        fr: 'Échec de la suppression. Veuillez réessayer.',
        ar: 'فشل حذف الحساب. حاول مرة أخرى.',
      );

  // ─── Blocks & misc ─────────────────────────────────────────────
  String get noBlockedUsers => _t(
        en: 'No blocked users',
        fr: 'Aucun utilisateur bloqué',
        ar: 'لا يوجد مستخدمون محظورون',
      );
  String get noBlockedUsersHint => _t(
        en: 'Users you block will appear here',
        fr: 'Les utilisateurs bloqués apparaîtront ici',
        ar: 'سيظهر المستخدمون المحظورون هنا',
      );
  String get listingFeedComingSoon => _t(
        en: 'Listing feed — coming soon',
        fr: 'Fil d\'annonces — bientôt disponible',
        ar: 'خلاصة الإعلانات — قريباً',
      );
  String photosCount(int current, int max) => _t(
        en: 'Photos ($current/$max)',
        fr: 'Photos ($current/$max)',
        ar: 'صور ($current/$max)',
      );
  String get gallery => _t(en: 'Gallery', fr: 'Galerie', ar: 'المعرض');
  String get camera => _t(en: 'Camera', fr: 'Appareil photo', ar: 'الكاميرا');
  String get joined => _t(en: 'Joined', fr: 'Inscrit le', ar: 'تاريخ الانضمام');
  String get owner => _t(en: 'Owner', fr: 'Propriétaire', ar: 'المالك');
  String get date => _t(en: 'Date', fr: 'Date', ar: 'التاريخ');
  String get view => _t(en: 'View', fr: 'Voir', ar: 'عرض');
  String get banUser => _t(en: 'Ban', fr: 'Bannir', ar: 'حظر');
  String get unbanUser => _t(en: 'Unban', fr: 'Débannir', ar: 'إلغاء الحظر');
  String get banUserTitle => _t(en: 'Ban user?', fr: 'Bannir l\'utilisateur ?', ar: 'حظر المستخدم؟');
  String get banUserMessage => _t(
        en: 'This user will no longer be able to post or interact.',
        fr: 'Cet utilisateur ne pourra plus publier ni interagir.',
        ar: 'لن يتمكن هذا المستخدم من النشر أو التفاعل.',
      );
  String get resolve => _t(en: 'Resolve', fr: 'Résoudre', ar: 'حل');
  String get dismiss => _t(en: 'Dismiss', fr: 'Ignorer', ar: 'رفض');
  String get type => _t(en: 'Type', fr: 'Type', ar: 'النوع');
  String get subject => _t(en: 'Subject', fr: 'Sujet', ar: 'الموضوع');
  String get details => _t(en: 'Details', fr: 'Détails', ar: 'التفاصيل');
  String get failedToLoadReports => _t(
        en: 'Failed to load reports',
        fr: 'Échec du chargement des signalements',
        ar: 'فشل تحميل البلاغات',
      );
  String get noOpenReports => _t(
        en: 'No open reports',
        fr: 'Aucun signalement ouvert',
        ar: 'لا توجد بلاغات مفتوحة',
      );
  String reportSubjectListing(String id) => _t(
        en: 'Listing $id',
        fr: 'Annonce $id',
        ar: 'إعلان $id',
      );
  String reportSubjectUser(String id) => _t(
        en: 'User $id',
        fr: 'Utilisateur $id',
        ar: 'مستخدم $id',
      );
  String reportSubjectTypeLabel(String value) => switch (value) {
        'listing' => _t(en: 'Listing', fr: 'Annonce', ar: 'إعلان'),
        'user' => _t(en: 'User', fr: 'Utilisateur', ar: 'مستخدم'),
        _ => value,
      };
  String get approveSelected => _t(
        en: 'Approve selected',
        fr: 'Approuver la sélection',
        ar: 'الموافقة على المحدد',
      );
  String get rejectSelected => _t(
        en: 'Reject selected',
        fr: 'Rejeter la sélection',
        ar: 'رفض المحدد',
      );
  String selectedCount(int count) => _t(
        en: '$count selected',
        fr: '$count sélectionné(s)',
        ar: '$count محدد',
      );
  String get pendingReview => _t(
        en: 'Pending Review',
        fr: 'En attente de validation',
        ar: 'قيد المراجعة',
      );
  String get listingsManagementSoon => _t(
        en: 'Listings management — coming soon',
        fr: 'Gestion des annonces — bientôt disponible',
        ar: 'إدارة الإعلانات — قريباً',
      );
  String get reviewListing => _t(
        en: 'Review Listing',
        fr: 'Examiner l\'annonce',
        ar: 'مراجعة الإعلان',
      );
  String listingReviewId(String id) => _t(
        en: 'Listing: $id',
        fr: 'Annonce : $id',
        ar: 'إعلان: $id',
      );

  String formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return _t(en: '${years}y ago', fr: 'il y a ${years} an${years > 1 ? 's' : ''}', ar: 'منذ $years سنة');
    }
    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return _t(en: '${months}mo ago', fr: 'il y a $months mois', ar: 'منذ $months شهر');
    }
    if (diff.inDays >= 1) {
      return _t(en: '${diff.inDays}d ago', fr: 'il y a ${diff.inDays} j', ar: 'منذ ${diff.inDays} يوم');
    }
    if (diff.inHours >= 1) {
      return _t(en: '${diff.inHours}h ago', fr: 'il y a ${diff.inHours} h', ar: 'منذ ${diff.inHours} ساعة');
    }
    if (diff.inMinutes >= 1) {
      return _t(en: '${diff.inMinutes}m ago', fr: 'il y a ${diff.inMinutes} min', ar: 'منذ ${diff.inMinutes} دقيقة');
    }
    return _t(en: 'Just now', fr: 'À l\'instant', ar: 'الآن');
  }

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
  String dashboardListingsBreakdown(int pending, int approved, int rejected) =>
      _t(
        en: 'Pending $pending · Approved $approved · Rejected $rejected',
        fr: 'En attente $pending · Approuvées $approved · Rejetées $rejected',
        ar: 'قيد الانتظار $pending · معتمدة $approved · مرفوضة $rejected',
      );
  String get approve => _t(en: 'Approve', fr: 'Approuver', ar: 'موافقة');
  String get reject => _t(en: 'Reject', fr: 'Rejeter', ar: 'رفض');
  String get status => _t(en: 'Status', fr: 'Statut', ar: 'الحالة');
  String get actions => _t(en: 'Actions', fr: 'Actions', ar: 'إجراءات');
  String get searchUsers => _t(
        en: 'Search users...',
        fr: 'Rechercher des utilisateurs...',
        ar: 'ابحث عن مستخدمين...',
      );
  String get searchByNameOrEmail => _t(
        en: 'Search by name or email',
        fr: 'Rechercher par nom ou e-mail',
        ar: 'البحث بالاسم أو البريد',
      );
  String get searchListings => _t(
        en: 'Search listings...',
        fr: 'Rechercher des annonces...',
        ar: 'ابحث في الإعلانات...',
      );
  String get blocked => _t(en: 'Blocked', fr: 'Bloqué', ar: 'محظور');
  String get banned => _t(en: 'Banned', fr: 'Banni', ar: 'محظور');
  String get active => _t(en: 'Active', fr: 'Actif', ar: 'نشط');
  String get role => _t(en: 'Role', fr: 'Rôle', ar: 'الدور');
  String get userDetails => _t(
        en: 'User Details',
        fr: 'Détails utilisateur',
        ar: 'تفاصيل المستخدم',
      );
  String banUserAdminConfirm(String name, String email) => _t(
        en: 'Ban $name ($email)? They will not be able to use the app.',
        fr: 'Bannir $name ($email) ? Il ne pourra plus utiliser l\'application.',
        ar: 'حظر $name ($email)؟ لن يتمكن من استخدام التطبيق.',
      );
  String deleteListingAdminConfirm(String title) => _t(
        en: 'Permanently delete "$title"? This cannot be undone.',
        fr: 'Supprimer définitivement « $title » ? Cette action est irréversible.',
        ar: 'حذف "$title" نهائياً؟ لا يمكن التراجع.',
      );
  String get cities => _t(en: 'Cities', fr: 'Villes', ar: 'المدن');
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
  String errorWithDetails(String details) => _t(
        en: 'Error: $details',
        fr: 'Erreur : $details',
        ar: 'خطأ: $details',
      );
  String get success => _t(en: 'Success', fr: 'Succès', ar: 'نجاح');
  String get yes => _t(en: 'Yes', fr: 'Oui', ar: 'نعم');
  String get no => _t(en: 'No', fr: 'Non', ar: 'لا');

  // ─── Legal (full text) ───────────────────────────────────────
  String get privacyPolicyContent => LegalStrings.privacyPolicy(language);
  String get termsOfServiceContent => LegalStrings.termsOfService(language);
  String get contactUsContent => LegalStrings.contactUs(language);
}
