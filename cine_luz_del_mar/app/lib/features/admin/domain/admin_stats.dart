/// Estadísticas agregadas del panel de administración.
class AdminStats {
  const AdminStats({
    this.users = 0,
    this.activeMembers = 0,
    this.upcomingEvents = 0,
    this.publishedNews = 0,
    this.posts = 0,
    this.films = 0,
  });

  final int users;
  final int activeMembers;
  final int upcomingEvents;
  final int publishedNews;
  final int posts;
  final int films;
}
