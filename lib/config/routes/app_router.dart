import 'package:bazaar/config/routes/go_router_refresh.dart';
import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/firebase/analytics_service.dart';
import 'package:bazaar/features/auth/presentation/pages/login_page.dart';
import 'package:bazaar/features/auth/presentation/pages/register_page.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/blocks/presentation/pages/blocked_users_page.dart';
import 'package:bazaar/features/categories/presentation/pages/category_list_page.dart';
import 'package:bazaar/features/favorites/presentation/pages/favorites_page.dart';
import 'package:bazaar/features/home/presentation/pages/home_page.dart';
import 'package:bazaar/features/listings/presentation/pages/create_listing_page.dart';
import 'package:bazaar/features/listings/presentation/pages/listing_detail_page.dart';
import 'package:bazaar/features/listings/presentation/pages/listing_feed_page.dart';
import 'package:bazaar/features/listings/presentation/pages/my_listings_page.dart';
import 'package:bazaar/features/post/presentation/pages/post_page.dart';
import 'package:bazaar/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:bazaar/features/profile/presentation/pages/profile_page.dart';
import 'package:bazaar/features/profile/presentation/pages/contact_us_page.dart';
import 'package:bazaar/features/profile/presentation/pages/delete_account_page.dart';
import 'package:bazaar/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:bazaar/features/profile/presentation/pages/seller_profile_page.dart';
import 'package:bazaar/features/profile/presentation/pages/settings_page.dart';
import 'package:bazaar/features/profile/presentation/pages/terms_of_service_page.dart';
import 'package:bazaar/features/search/presentation/pages/search_page.dart';
import 'package:bazaar/features/shell/presentation/pages/main_shell_page.dart';
import 'package:bazaar/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerRefreshProvider = Provider<GoRouterAuthRefresh>((ref) {
  final notifier = GoRouterAuthRefresh();

  // Re-run redirects when Riverpod auth state resolves (fixes infinite splash).
  ref.listen(
    authStateChangesProvider,
    (_, __) => notifier.refresh(),
    fireImmediately: true,
  );

  final authSub = ref.read(authRepositoryProvider).authStateChanges().listen((_) {
    notifier.refresh();
  });

  ref.onDispose(() {
    authSub.cancel();
    notifier.dispose();
  });

  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshProvider);
  final analytics = ref.watch(analyticsServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final isLoading = authState.isLoading;
      final user = authState.valueOrNull;
      final location = state.matchedLocation;

      final isSplash = location == RouteNames.splash;
      final isAuthRoute =
          location == RouteNames.login || location == RouteNames.register;
      final isPublicRoute = isAuthRoute ||
          location == RouteNames.privacyPolicy ||
          location == RouteNames.termsOfService ||
          location == RouteNames.contactUs;

      if (authState.hasError) {
        return isAuthRoute ? null : RouteNames.login;
      }

      if (isLoading) {
        return isSplash ? null : RouteNames.splash;
      }

      if (user == null) {
        if (isSplash) return RouteNames.login;
        return isPublicRoute ? null : RouteNames.login;
      }

      if (isSplash || isAuthRoute) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteKeys.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteKeys.login,
        builder: (_, __) {
          analytics.logScreen('login');
          return const LoginPage();
        },
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteKeys.register,
        builder: (_, __) {
          analytics.logScreen('register');
          return const RegisterPage();
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => MainShellPage(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: RouteKeys.home,
            builder: (_, __) {
              analytics.logScreen('home');
              return const HomePage();
            },
          ),
          GoRoute(
            path: RouteNames.search,
            name: RouteKeys.search,
            builder: (_, __) {
              analytics.logScreen('search');
              return const SearchPage();
            },
          ),
          GoRoute(
            path: RouteNames.post,
            name: RouteKeys.post,
            builder: (_, __) {
              analytics.logScreen('post');
              return const PostPage();
            },
          ),
          GoRoute(
            path: RouteNames.favorites,
            name: RouteKeys.favorites,
            builder: (_, __) {
              analytics.logScreen('favorites');
              return const FavoritesPage();
            },
          ),
          GoRoute(
            path: RouteNames.profile,
            name: RouteKeys.profile,
            builder: (_, __) {
              analytics.logScreen('profile');
              return const ProfilePage();
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.categories,
        name: RouteKeys.categories,
        builder: (_, __) => const CategoryListPage(),
      ),
      GoRoute(
        path: RouteNames.listingFeed,
        name: RouteKeys.listingFeed,
        builder: (_, __) => const ListingFeedPage(),
      ),
      GoRoute(
        path: RouteNames.createListing,
        name: RouteKeys.createListing,
        builder: (_, __) => const CreateListingPage(),
      ),
      GoRoute(
        path: RouteNames.myListings,
        name: RouteKeys.myListings,
        builder: (_, __) => const MyListingsPage(),
      ),
      GoRoute(
        path: RouteNames.editListing,
        name: RouteKeys.editListing,
        builder: (_, state) => CreateListingPage(
          listingId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: RouteNames.blockedUsers,
        name: RouteKeys.blockedUsers,
        builder: (_, __) => const BlockedUsersPage(),
      ),
      GoRoute(
        path: RouteNames.sellerProfile,
        name: RouteKeys.sellerProfile,
        builder: (_, state) => SellerProfilePage(
          userId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteKeys.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteKeys.settings,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.deleteAccount,
        name: RouteKeys.deleteAccount,
        builder: (_, __) => const DeleteAccountPage(),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        name: RouteKeys.privacyPolicy,
        builder: (_, __) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: RouteNames.termsOfService,
        name: RouteKeys.termsOfService,
        builder: (_, __) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: RouteNames.contactUs,
        name: RouteKeys.contactUs,
        builder: (_, __) => const ContactUsPage(),
      ),
      GoRoute(
        path: RouteNames.listingDetail,
        name: RouteKeys.listingDetail,
        builder: (_, state) => ListingDetailPage(
          listingId: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );
});
