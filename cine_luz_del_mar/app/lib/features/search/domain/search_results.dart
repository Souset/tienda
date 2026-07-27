import '../../../shared/models/models.dart';

/// Resultados agregados del buscador global, agrupados por tipo.
class SearchResults {
  const SearchResults({
    this.events = const [],
    this.films = const [],
    this.news = const [],
    this.resources = const [],
    this.users = const [],
  });

  final List<EventItem> events;
  final List<Film> films;
  final List<NewsItem> news;
  final List<LibraryResource> resources;
  final List<AppUser> users;

  bool get isEmpty =>
      events.isEmpty &&
      films.isEmpty &&
      news.isEmpty &&
      resources.isEmpty &&
      users.isEmpty;

  int get total =>
      events.length +
      films.length +
      news.length +
      resources.length +
      users.length;
}
