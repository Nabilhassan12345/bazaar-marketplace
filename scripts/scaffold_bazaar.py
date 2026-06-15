#!/usr/bin/env python3
"""Generate Bazaar lib/ and admin/lib/ scaffold from ARCHITECTURE.md."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
ADMIN_LIB = ROOT / "admin" / "lib"


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.strip() + "\n")


def page(name: str, title: str) -> str:
    return f"""import 'package:flutter/material.dart';

class {name} extends StatelessWidget {{
  const {name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(title: const Text('{title}')),
      body: const Center(child: Text('{title}')),
    );
  }}
}}
"""


def widget_stub(name: str) -> str:
    return f"""import 'package:flutter/material.dart';

class {name} extends StatelessWidget {{
  const {name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return const SizedBox.shrink();
  }}
}}
"""


def entity(name: str) -> str:
    return f"""class {name} {{
  const {name}();
}}
"""


def model(name: str) -> str:
    return f"""class {name} {{
  const {name}();

  factory {name}.fromJson(Map<String, dynamic> json) => const {name}();

  Map<String, dynamic> toJson() => <String, dynamic>{{}};
}}
"""


def repo_abstract(name: str) -> str:
    return f"""abstract class {name} {{
  const {name}();
}}
"""


def repo_impl(name: str, abstract: str) -> str:
    return f"""import '{abstract.replace("abstract class ", "").split()[0].lower()}_repository.dart';

class {name} implements {abstract.replace("RepositoryImpl", "Repository").split()[-1] if False else abstract.split("implements ")[0].replace("class ", "").replace("Impl", "Repository")} {{
  const {name}();
}}
"""


def usecase(name: str, repo_import: str, repo_type: str) -> str:
    return f"""import '{repo_import}';

class {name} {{
  const {name}(this._repository);

  final {repo_type} _repository;
}}
"""


def datasource(name: str) -> str:
    return f"""class {name} {{
  const {name}();
}}
"""


def notifier_file(class_name: str, state_class: str) -> str:
    return f"""import 'package:flutter_riverpod/flutter_riverpod.dart';

class {state_class} {{
  const {state_class}();
}}

class {class_name} extends Notifier<{state_class}> {{
  @override
  {state_class} build() => const {state_class}();
}}

final {class_name[0].lower()}{class_name[1:]}Provider =
    NotifierProvider<{class_name}, {state_class}>({class_name}.new);
"""


# --- Mobile lib root ---
write(LIB / "main.dart", """
import 'package:bazaar/app.dart';
import 'package:bazaar/config/env/dev_env.dart';
import 'package:bazaar/core/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(
    const ProviderScope(
      child: BazaarApp(env: DevEnv()),
    ),
  );
}
""")

write(LIB / "main_dev.dart", """
import 'package:bazaar/main.dart' as mobile;

Future<void> main() => mobile.main();
""")

write(LIB / "main_prod.dart", """
import 'package:bazaar/app.dart';
import 'package:bazaar/config/env/prod_env.dart';
import 'package:bazaar/core/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(
    const ProviderScope(
      child: BazaarApp(env: ProdEnv()),
    ),
  );
}
""")

write(LIB / "app.dart", """
import 'package:bazaar/config/env/env.dart';
import 'package:bazaar/config/routes/app_router.dart';
import 'package:bazaar/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BazaarApp extends ConsumerWidget {
  const BazaarApp({required this.env, super.key});

  final Env env;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: env.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
""")

write(LIB / "injection_container.dart", """
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global Riverpod providers are declared per feature.
final injectionContainerProvider = Provider<void>((ref) {});
""")

# config
write(LIB / "config/env/env.dart", """
abstract class Env {
  String get appName;
  bool get isProduction;
}
""")

write(LIB / "config/env/dev_env.dart", """
import 'package:bazaar/config/env/env.dart';

class DevEnv implements Env {
  const DevEnv();

  @override
  String get appName => 'Bazaar';

  @override
  bool get isProduction => false;
}
""")

write(LIB / "config/env/prod_env.dart", """
import 'package:bazaar/config/env/env.dart';

class ProdEnv implements Env {
  const ProdEnv();

  @override
  String get appName => 'Bazaar';

  @override
  bool get isProduction => true;
}
""")

write(LIB / "config/routes/route_names.dart", """
abstract final class RouteNames {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const categories = '/categories';
  static const listingFeed = '/listings';
  static const listingDetail = '/listings/:id';
  static const createListing = '/listings/create';
  static const myListings = '/my-listings';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const blockedUsers = '/blocked-users';
}
""")

write(LIB / "config/routes/app_router.dart", """
import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/features/auth/presentation/pages/login_page.dart';
import 'package:bazaar/features/auth/presentation/pages/register_page.dart';
import 'package:bazaar/features/categories/presentation/pages/category_list_page.dart';
import 'package:bazaar/features/favorites/presentation/pages/favorites_page.dart';
import 'package:bazaar/features/home/presentation/pages/home_page.dart';
import 'package:bazaar/features/listings/presentation/pages/create_listing_page.dart';
import 'package:bazaar/features/listings/presentation/pages/listing_detail_page.dart';
import 'package:bazaar/features/listings/presentation/pages/listing_feed_page.dart';
import 'package:bazaar/features/listings/presentation/pages/my_listings_page.dart';
import 'package:bazaar/features/profile/presentation/pages/profile_page.dart';
import 'package:bazaar/features/shell/presentation/pages/main_shell_page.dart';
import 'package:bazaar/features/splash/presentation/pages/splash_page.dart';
import 'package:bazaar/features/blocks/presentation/pages/blocked_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShellPage(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: RouteNames.categories,
            builder: (_, __) => const CategoryListPage(),
          ),
          GoRoute(
            path: RouteNames.listingFeed,
            builder: (_, __) => const ListingFeedPage(),
          ),
          GoRoute(
            path: RouteNames.favorites,
            builder: (_, __) => const FavoritesPage(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.createListing,
        builder: (_, __) => const CreateListingPage(),
      ),
      GoRoute(
        path: RouteNames.myListings,
        builder: (_, __) => const MyListingsPage(),
      ),
      GoRoute(
        path: RouteNames.blockedUsers,
        builder: (_, __) => const BlockedUsersPage(),
      ),
      GoRoute(
        path: '/listings/:id',
        builder: (_, state) => ListingDetailPage(
          listingId: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );
});
""")

write(LIB / "config/theme/app_colors.dart", """
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF0D9488);
  static const secondary = Color(0xFF134E4A);
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const error = Color(0xFFDC2626);
}
""")

write(LIB / "config/theme/app_typography.dart", """
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
""")

write(LIB / "config/theme/app_theme.dart", """
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      );
}
""")

# core
core_files = {
    "core/constants/app_constants.dart": "abstract final class AppConstants { static const appName = 'Bazaar'; }",
    "core/constants/firestore_paths.dart": """abstract final class FirestorePaths {
  static const users = 'users';
  static const listings = 'listings';
  static const categories = 'categories';
  static const cities = 'cities';
  static const favorites = 'favorites';
  static const reports = 'reports';
  static const blocks = 'blocks';
}""",
    "core/constants/storage_paths.dart": """abstract final class StoragePaths {
  static String listingImage(String listingId, String fileName) => 'listings/$listingId/$fileName';
  static String userAvatar(String userId) => 'users/$userId/avatar.jpg';
}""",
    "core/enums/listing_status.dart": """enum ListingStatus {
  draft,
  pendingReview,
  approved,
  rejected;

  String get value => switch (this) {
        ListingStatus.draft => 'draft',
        ListingStatus.pendingReview => 'pending_review',
        ListingStatus.approved => 'approved',
        ListingStatus.rejected => 'rejected',
      };
}""",
    "core/enums/user_role.dart": """enum UserRole {
  user,
  moderator,
  admin;

  String get value => name;
}""",
    "core/enums/report_status.dart": """enum ReportStatus {
  pending,
  reviewed,
  resolved,
  dismissed;

  String get value => name;
}""",
    "core/errors/exceptions.dart": """class AppException implements Exception {
  const AppException(this.message);
  final String message;
}""",
    "core/errors/failures.dart": """class Failure {
  const Failure(this.message);
  final String message;
}""",
    "core/extensions/context_extensions.dart": """import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
}""",
    "core/extensions/datetime_extensions.dart": """extension DateTimeExtensions on DateTime {
  String get isoDate => toIso8601String();
}""",
    "core/network/connectivity_service.dart": datasource("ConnectivityService"),
    "core/firebase/firebase_initializer.dart": """
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
""",
    "core/firebase/analytics_service.dart": """
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logEvent(String name) => _analytics.logEvent(name: name);
}
""",
    "core/utils/validators.dart": """class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    return null;
  }
}""",
    "core/utils/formatters.dart": """import 'package:intl/intl.dart';

class Formatters {
  static final currency = NumberFormat.currency(symbol: '₺');
}""",
    "core/utils/image_picker_helper.dart": datasource("ImagePickerHelper"),
    "core/widgets/app_loading.dart": widget_stub("AppLoading"),
    "core/widgets/app_error_view.dart": """
import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
""",
    "core/widgets/empty_state.dart": """
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
""",
    "core/widgets/cached_network_image.dart": """
import 'package:cached_network_image/cached_network_image.dart' as cached;
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return cached.CachedNetworkImage(imageUrl: imageUrl);
  }
}
""",
}

for rel, content in core_files.items():
    write(LIB / rel, content)

# Feature pages
pages = [
    ("features/splash/presentation/pages/splash_page.dart", "SplashPage", "Bazaar"),
    ("features/auth/presentation/pages/login_page.dart", "LoginPage", "Login"),
    ("features/auth/presentation/pages/register_page.dart", "RegisterPage", "Register"),
    ("features/home/presentation/pages/home_page.dart", "HomePage", "Home"),
    ("features/categories/presentation/pages/category_list_page.dart", "CategoryListPage", "Categories"),
    ("features/listings/presentation/pages/listing_feed_page.dart", "ListingFeedPage", "Listings"),
    ("features/listings/presentation/pages/listing_detail_page.dart", "ListingDetailPage", "Listing"),
    ("features/listings/presentation/pages/create_listing_page.dart", "CreateListingPage", "Create Listing"),
    ("features/listings/presentation/pages/edit_listing_page.dart", "EditListingPage", "Edit Listing"),
    ("features/listings/presentation/pages/my_listings_page.dart", "MyListingsPage", "My Listings"),
    ("features/favorites/presentation/pages/favorites_page.dart", "FavoritesPage", "Favorites"),
    ("features/profile/presentation/pages/profile_page.dart", "ProfilePage", "Profile"),
    ("features/blocks/presentation/pages/blocked_users_page.dart", "BlockedUsersPage", "Blocked Users"),
]

for rel, cls, title in pages:
    if cls == "ListingDetailPage":
        write(LIB / rel, """
import 'package:flutter/material.dart';

class ListingDetailPage extends StatelessWidget {
  const ListingDetailPage({required this.listingId, super.key});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing')),
      body: Center(child: Text('Listing: $listingId')),
    );
  }
}
""")
    else:
        write(LIB / rel, page(cls, title))

write(LIB / "features/shell/presentation/pages/main_shell_page.dart", """
import 'package:bazaar/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
""")

write(LIB / "features/shell/presentation/widgets/bottom_nav_bar.dart", widget_stub("BottomNavBar"))
write(LIB / "features/home/presentation/widgets/category_chips.dart", widget_stub("CategoryChips"))
write(LIB / "features/home/presentation/widgets/featured_listings_carousel.dart", widget_stub("FeaturedListingsCarousel"))
write(LIB / "features/auth/presentation/widgets/auth_text_field.dart", widget_stub("AuthTextField"))
write(LIB / "features/cities/presentation/widgets/city_picker.dart", widget_stub("CityPicker"))
write(LIB / "features/listings/presentation/widgets/listing_card.dart", widget_stub("ListingCard"))
write(LIB / "features/listings/presentation/widgets/listing_image_gallery.dart", widget_stub("ListingImageGallery"))
write(LIB / "features/listings/presentation/widgets/price_tag.dart", widget_stub("PriceTag"))
write(LIB / "features/listings/presentation/widgets/attribute_form/car_attribute_form.dart", widget_stub("CarAttributeForm"))
write(LIB / "features/listings/presentation/widgets/attribute_form/house_attribute_form.dart", widget_stub("HouseAttributeForm"))
write(LIB / "features/listings/presentation/widgets/attribute_form/second_hand_attribute_form.dart", widget_stub("SecondHandAttributeForm"))
write(LIB / "features/reports/presentation/widgets/report_dialog.dart", widget_stub("ReportDialog"))

# Notifiers (architecture cubit files)
cubit_paths = [
    ("features/auth/presentation/cubit/auth_cubit.dart", "AuthCubit", "AuthState"),
    ("features/categories/presentation/cubit/category_cubit.dart", "CategoryCubit", "CategoryState"),
    ("features/cities/presentation/cubit/city_cubit.dart", "CityCubit", "CityState"),
    ("features/listings/presentation/cubit/listing_list_cubit.dart", "ListingListCubit", "ListingListState"),
    ("features/listings/presentation/cubit/listing_detail_cubit.dart", "ListingDetailCubit", "ListingDetailState"),
    ("features/listings/presentation/cubit/create_listing_cubit.dart", "CreateListingCubit", "CreateListingState"),
    ("features/favorites/presentation/cubit/favorite_cubit.dart", "FavoriteCubit", "FavoriteState"),
    ("features/profile/presentation/cubit/profile_cubit.dart", "ProfileCubit", "ProfileState"),
    ("features/reports/presentation/cubit/report_cubit.dart", "ReportCubit", "ReportState"),
    ("features/blocks/presentation/cubit/block_cubit.dart", "BlockCubit", "BlockState"),
]
for rel, cls, state in cubit_paths:
    write(LIB / rel, notifier_file(cls, state))

# Entities
entities = [
    ("features/auth/domain/entities/user_entity.dart", "UserEntity"),
    ("features/categories/domain/entities/category_entity.dart", "CategoryEntity"),
    ("features/cities/domain/entities/city_entity.dart", "CityEntity"),
    ("features/listings/domain/entities/listing_entity.dart", "ListingEntity"),
    ("features/favorites/domain/entities/favorite_entity.dart", "FavoriteEntity"),
    ("features/reports/domain/entities/report_entity.dart", "ReportEntity"),
    ("features/blocks/domain/entities/block_entity.dart", "BlockEntity"),
]
for rel, name in entities:
    write(LIB / rel, entity(name))

# Models
models = [
    ("features/auth/data/models/user_model.dart", "UserModel"),
    ("features/categories/data/models/category_model.dart", "CategoryModel"),
    ("features/cities/data/models/city_model.dart", "CityModel"),
    ("features/listings/data/models/listing_model.dart", "ListingModel"),
    ("features/listings/data/models/listing_attribute_model.dart", "ListingAttributeModel"),
    ("features/favorites/data/models/favorite_model.dart", "FavoriteModel"),
    ("features/reports/data/models/report_model.dart", "ReportModel"),
    ("features/blocks/data/models/block_model.dart", "BlockModel"),
]
for rel, name in models:
    write(LIB / rel, model(name))

# Repositories abstract
repos = [
    ("features/auth/domain/repositories/auth_repository.dart", "AuthRepository"),
    ("features/categories/domain/repositories/category_repository.dart", "CategoryRepository"),
    ("features/cities/domain/repositories/city_repository.dart", "CityRepository"),
    ("features/listings/domain/repositories/listing_repository.dart", "ListingRepository"),
    ("features/favorites/domain/repositories/favorite_repository.dart", "FavoriteRepository"),
    ("features/profile/domain/repositories/profile_repository.dart", "ProfileRepository"),
    ("features/reports/domain/repositories/report_repository.dart", "ReportRepository"),
    ("features/blocks/domain/repositories/block_repository.dart", "BlockRepository"),
]
for rel, name in repos:
    write(LIB / rel, repo_abstract(name))

# Repository impls
impls = [
    ("features/auth/data/repositories/auth_repository_impl.dart", "AuthRepositoryImpl", "AuthRepository", "../domain/repositories/auth_repository.dart"),
    ("features/categories/data/repositories/category_repository_impl.dart", "CategoryRepositoryImpl", "CategoryRepository", "../../domain/repositories/category_repository.dart"),
    ("features/cities/data/repositories/city_repository_impl.dart", "CityRepositoryImpl", "CityRepository", "../../domain/repositories/city_repository.dart"),
    ("features/listings/data/repositories/listing_repository_impl.dart", "ListingRepositoryImpl", "ListingRepository", "../../domain/repositories/listing_repository.dart"),
    ("features/favorites/data/repositories/favorite_repository_impl.dart", "FavoriteRepositoryImpl", "FavoriteRepository", "../../domain/repositories/favorite_repository.dart"),
    ("features/profile/data/repositories/profile_repository_impl.dart", "ProfileRepositoryImpl", "ProfileRepository", "../../domain/repositories/profile_repository.dart"),
    ("features/reports/data/repositories/report_repository_impl.dart", "ReportRepositoryImpl", "ReportRepository", "../../domain/repositories/report_repository.dart"),
    ("features/blocks/data/repositories/block_repository_impl.dart", "BlockRepositoryImpl", "BlockRepository", "../../domain/repositories/block_repository.dart"),
]
for rel, impl, abstract, _ in impls:
    domain_rel = rel.replace("/data/repositories/", "/domain/repositories/").replace("_impl.dart", ".dart")
    write(LIB / rel, f"""import 'package:bazaar/{domain_rel}';

class {impl} implements {abstract} {{
  const {impl}();
}}
""")

# Datasources
datasources = [
    "features/auth/data/datasources/auth_remote_datasource.dart",
    "features/categories/data/datasources/category_remote_datasource.dart",
    "features/cities/data/datasources/city_remote_datasource.dart",
    "features/listings/data/datasources/listing_remote_datasource.dart",
    "features/listings/data/datasources/listing_storage_datasource.dart",
    "features/favorites/data/datasources/favorite_remote_datasource.dart",
    "features/profile/data/datasources/profile_remote_datasource.dart",
    "features/reports/data/datasources/report_remote_datasource.dart",
    "features/blocks/data/datasources/block_remote_datasource.dart",
]
for rel in datasources:
    name = Path(rel).stem
    class_name = "".join(p.capitalize() for p in name.split("_"))
    write(LIB / rel, datasource(class_name))

# Use cases
usecases = [
    ("features/auth/domain/usecases/sign_in_with_email.dart", "SignInWithEmail", "auth_repository.dart", "AuthRepository"),
    ("features/auth/domain/usecases/sign_up_with_email.dart", "SignUpWithEmail", "auth_repository.dart", "AuthRepository"),
    ("features/auth/domain/usecases/sign_in_with_google.dart", "SignInWithGoogle", "auth_repository.dart", "AuthRepository"),
    ("features/auth/domain/usecases/sign_out.dart", "SignOut", "auth_repository.dart", "AuthRepository"),
    ("features/auth/domain/usecases/get_current_user.dart", "GetCurrentUser", "auth_repository.dart", "AuthRepository"),
    ("features/categories/domain/usecases/get_categories.dart", "GetCategories", "category_repository.dart", "CategoryRepository"),
    ("features/cities/domain/usecases/get_cities.dart", "GetCities", "city_repository.dart", "CityRepository"),
    ("features/listings/domain/usecases/create_listing.dart", "CreateListing", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/update_listing.dart", "UpdateListing", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/delete_listing.dart", "DeleteListing", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/submit_listing_for_review.dart", "SubmitListingForReview", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/get_listing_by_id.dart", "GetListingById", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/get_approved_listings.dart", "GetApprovedListings", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/get_my_listings.dart", "GetMyListings", "listing_repository.dart", "ListingRepository"),
    ("features/listings/domain/usecases/search_listings.dart", "SearchListings", "listing_repository.dart", "ListingRepository"),
    ("features/favorites/domain/usecases/toggle_favorite.dart", "ToggleFavorite", "favorite_repository.dart", "FavoriteRepository"),
    ("features/favorites/domain/usecases/get_favorites.dart", "GetFavorites", "favorite_repository.dart", "FavoriteRepository"),
    ("features/profile/domain/usecases/update_profile.dart", "UpdateProfile", "profile_repository.dart", "ProfileRepository"),
    ("features/reports/domain/usecases/submit_report.dart", "SubmitReport", "report_repository.dart", "ReportRepository"),
    ("features/blocks/domain/usecases/block_user.dart", "BlockUser", "block_repository.dart", "BlockRepository"),
    ("features/blocks/domain/usecases/unblock_user.dart", "UnblockUser", "block_repository.dart", "BlockRepository"),
    ("features/blocks/domain/usecases/get_blocked_users.dart", "GetBlockedUsers", "block_repository.dart", "BlockRepository"),
]
for rel, name, repo_file, repo_type in usecases:
    import_pkg = f"package:bazaar/features/{rel.split('/')[1]}/domain/repositories/{repo_file}"
    write(LIB / rel, f"""import '{import_pkg}';

class {name} {{
  const {name}(this._repository);

  final {repo_type} _repository;
}}
""")

# --- Admin ---
write(ADMIN_LIB / "main.dart", """
import 'package:admin/app.dart';
import 'package:admin/core/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(const ProviderScope(child: AdminApp()));
}
""")

write(ADMIN_LIB / "app.dart", """
import 'package:admin/config/routes/admin_router.dart';
import 'package:admin/config/theme/admin_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(adminRouterProvider);
    return MaterialApp.router(
      title: 'Bazaar Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light,
      routerConfig: router,
    );
  }
}
""")

write(ADMIN_LIB / "injection_container.dart", """
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminInjectionProvider = Provider<void>((ref) {});
""")

write(ADMIN_LIB / "config/routes/admin_router.dart", """
import 'package:admin/features/auth/presentation/pages/admin_login_page.dart';
import 'package:admin/features/categories/presentation/pages/categories_admin_page.dart';
import 'package:admin/features/cities/presentation/pages/cities_admin_page.dart';
import 'package:admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:admin/features/listings_review/presentation/pages/listing_review_detail_page.dart';
import 'package:admin/features/listings_review/presentation/pages/pending_listings_page.dart';
import 'package:admin/features/reports/presentation/pages/reports_page.dart';
import 'package:admin/features/users/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final adminRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const AdminLoginPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/listings/pending', builder: (_, __) => const PendingListingsPage()),
      GoRoute(
        path: '/listings/review/:id',
        builder: (_, state) => ListingReviewDetailPage(
          listingId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(path: '/users', builder: (_, __) => const UsersPage()),
      GoRoute(path: '/reports', builder: (_, __) => const ReportsPage()),
      GoRoute(path: '/categories', builder: (_, __) => const CategoriesAdminPage()),
      GoRoute(path: '/cities', builder: (_, __) => const CitiesAdminPage()),
    ],
  );
});
""")

write(ADMIN_LIB / "config/theme/admin_theme.dart", """
import 'package:flutter/material.dart';

abstract final class AdminTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
      );
}
""")

write(ADMIN_LIB / "core/firebase/firebase_initializer.dart", """
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
""")

write(ADMIN_LIB / "core/guards/admin_auth_guard.dart", """
class AdminAuthGuard {
  const AdminAuthGuard();
}
""")

for w in ["AdminScaffold", "AdminSidebar", "DataTableWrapper"]:
    write(ADMIN_LIB / f"core/widgets/{w[0].lower() + w[1:].replace('T', '_t').replace('S', '_s').replace('D', '_d')}".replace("Admin_s_caffold", "admin_scaffold").replace("Admin_s_idebar", "admin_sidebar").replace("Data_t_able_w_rapper", "data_table_wrapper"), widget_stub(w))

# fix admin widgets paths explicitly
write(ADMIN_LIB / "core/widgets/admin_scaffold.dart", widget_stub("AdminScaffold"))
write(ADMIN_LIB / "core/widgets/admin_sidebar.dart", widget_stub("AdminSidebar"))
write(ADMIN_LIB / "core/widgets/data_table_wrapper.dart", widget_stub("DataTableWrapper"))

admin_pages = [
    ("features/auth/presentation/pages/admin_login_page.dart", "AdminLoginPage", "Admin Login"),
    ("features/dashboard/presentation/pages/dashboard_page.dart", "DashboardPage", "Dashboard"),
    ("features/listings_review/presentation/pages/pending_listings_page.dart", "PendingListingsPage", "Pending Listings"),
    ("features/listings_review/presentation/pages/listing_review_detail_page.dart", "ListingReviewDetailPage", "Review Listing"),
    ("features/users/presentation/pages/users_page.dart", "UsersPage", "Users"),
    ("features/reports/presentation/pages/reports_page.dart", "ReportsPage", "Reports"),
    ("features/categories/presentation/pages/categories_admin_page.dart", "CategoriesAdminPage", "Categories"),
    ("features/cities/presentation/pages/cities_admin_page.dart", "CitiesAdminPage", "Cities"),
]
for rel, cls, title in admin_pages:
    if cls == "ListingReviewDetailPage":
        write(ADMIN_LIB / rel, """
import 'package:flutter/material.dart';

class ListingReviewDetailPage extends StatelessWidget {
  const ListingReviewDetailPage({required this.listingId, super.key});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Listing')),
      body: Center(child: Text('Listing: $listingId')),
    );
  }
}
""")
    else:
        write(ADMIN_LIB / rel, page(cls, title))

write(ADMIN_LIB / "features/listings_review/data/listing_review_repository.dart", repo_abstract("ListingReviewRepository"))
write(ADMIN_LIB / "features/listings_review/presentation/cubit/listing_review_cubit.dart", notifier_file("ListingReviewCubit", "ListingReviewState"))

print("Scaffold generated.")
