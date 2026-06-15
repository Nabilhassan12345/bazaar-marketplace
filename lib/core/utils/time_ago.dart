String formatTimeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }
  if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return '${months}mo ago';
  }
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
  return 'Just now';
}
