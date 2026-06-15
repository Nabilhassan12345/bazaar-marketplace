abstract final class StoragePaths {
  static String listingImage(String listingId, String fileName) => 'listings/$listingId/$fileName';
  static String userAvatar(String userId) => 'users/$userId/avatar.jpg';
}
