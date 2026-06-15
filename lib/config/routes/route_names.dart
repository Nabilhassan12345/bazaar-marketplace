/// Path constants for [GoRouter] routes.
abstract final class RouteNames {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  // Shell tabs
  static const home = '/home';
  static const search = '/search';
  static const post = '/post';
  static const favorites = '/favorites';
  static const profile = '/profile';

  // Secondary screens
  static const categories = '/categories';
  static const listingFeed = '/listings';
  static const listingDetail = '/listings/:id';
  static const createListing = '/listings/create';
  static const myListings = '/my-listings';
  static const editListing = '/listings/:id/edit';
  static const blockedUsers = '/blocked-users';
  static const sellerProfile = '/users/:id';
  static const editProfile = '/profile/edit';
  static const settings = '/profile/settings';
  static const deleteAccount = '/profile/delete-account';
  static const privacyPolicy = '/privacy-policy';
  static const termsOfService = '/terms-of-service';
  static const contactUs = '/contact-us';
}

/// Named route keys for [GoRouter.goNamed] / [GoRouter.pushNamed].
abstract final class RouteKeys {
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const home = 'home';
  static const search = 'search';
  static const post = 'post';
  static const favorites = 'favorites';
  static const profile = 'profile';
  static const categories = 'categories';
  static const listingFeed = 'listingFeed';
  static const listingDetail = 'listingDetail';
  static const createListing = 'createListing';
  static const myListings = 'myListings';
  static const editListing = 'editListing';
  static const blockedUsers = 'blockedUsers';
  static const sellerProfile = 'sellerProfile';
  static const editProfile = 'editProfile';
  static const settings = 'settings';
  static const deleteAccount = 'deleteAccount';
  static const privacyPolicy = 'privacyPolicy';
  static const termsOfService = 'termsOfService';
  static const contactUs = 'contactUs';
}
