import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  List<String> selectedInterests = [];
  List<Article> savedArticles = [];
  VoidCallback? onSavedArticlesChanged;

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedInterests = prefs.getStringList('selected_interests') ?? [];

    final savedArticlesJson = prefs.getStringList('saved_articles') ?? [];
    savedArticles = savedArticlesJson.map((jsonString) {
      return Article.fromJson(json.decode(jsonString));
    }).toList();
  }

  Future<void> saveInterests(List<String> interests) async {
    selectedInterests = interests;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_interests', selectedInterests);
  }

  Future<void> toggleSavedArticle(Article article) async {
    final isSaved = savedArticles.any((a) => a.url == article.url);
    if (isSaved) {
      savedArticles.removeWhere((a) => a.url == article.url);
    } else {
      savedArticles.add(article);
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> savedArticlesJson = savedArticles.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList('saved_articles', savedArticlesJson);
    onSavedArticlesChanged?.call();
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final AppState _appState = AppState();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAppState();
  }

  Future<void> _initializeAppState() async {
    await _appState.loadInitialData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
    _appState.onSavedArticlesChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(appState: _appState);
      case 1:
        return TrendingScreen(appState: _appState);
      case 2:
        return SavedNewsScreen(appState: _appState);
      case 3:
        return InterestsScreen(appState: _appState);
      default:
        return HomeScreen(appState: _appState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildScreen(_currentIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up_outlined), activeIcon: Icon(Icons.trending_up), label: 'Trending'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Interests'),
          ],
        ),
      ),
    );
  }
}


class NewsService {
  static const String apiKey = 'c3b1aad9c7c9442f82965fd2d0274bc6';
  static const String baseUrl = 'https://newsapi.org/v2';

  static Future<List<Article>> getNews({String? endpoint, String? country, String? query, int page = 1}) async {
    String url;
    if (endpoint == 'top-headlines') {
      url = '$baseUrl/top-headlines?country=${country ?? 'us'}&language=en&page=$page&pageSize=20&apiKey=$apiKey';
    } else {
      url = '$baseUrl/everything?q=${query ?? 'latest'}&language=en&sortBy=publishedAt&page=$page&pageSize=20&apiKey=$apiKey';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .where((article) =>
      article.urlToImage != null &&
          article.description.isNotEmpty &&
          !article.title.contains('[Removed]'))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class Article {
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? author;
  final String? sourceName;

  Article({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.author,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      author: json['author'],
      sourceName: json['source']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'author': author,
      'source': {'name': sourceName},
    };
  }
}


class HomeScreen extends StatefulWidget {
  final AppState appState;
  const HomeScreen({super.key, required this.appState});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Article> articles = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int page = 1;

  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'general';
  String? currentQuery;

  final List<String> categories = ['general', 'business', 'entertainment', 'health', 'science', 'sports', 'technology'];

  @override
  void initState() {
    super.initState();
    loadNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoadingMore) {
        loadNews(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadNews({bool isRefresh = false, bool isLoadMore = false}) async {
    if (isLoadingMore || (isLoadMore && !hasMore)) return;

    if (isRefresh) {
      page = 1;
      hasMore = true;
      articles.clear();
    }

    if (mounted) {
      setState(() {
        if (isLoadMore) {
          isLoadingMore = true;
        } else {
          isLoading = true;
        }
      });
    }

    try {
      List<Article> newArticles;
      if (currentQuery != null && currentQuery!.isNotEmpty) {
        newArticles = await NewsService.getNews(endpoint: 'everything', query: currentQuery, page: page);
      } else if (widget.appState.selectedInterests.isNotEmpty) {
        final interestsQuery = widget.appState.selectedInterests.join(' OR ');
        newArticles = await NewsService.getNews(endpoint: 'everything', query: interestsQuery, page: page);
      } else {
        newArticles = await NewsService.getNews(endpoint: 'everything', query: selectedCategory, page: page);
      }

      if (mounted) {
        setState(() {
          if (newArticles.isEmpty) {
            hasMore = false;
          } else {
            articles.addAll(newArticles);
            page++;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load news: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> searchNews(String query) async {
    currentQuery = query;
    await loadNews(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/news_logo.png', height: 28, color: Colors.white),
            const SizedBox(width: 8),
            const Text('News', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                suffixIcon: IconButton(icon: const Icon(Icons.search, color: Colors.blue), onPressed: () => searchNews(searchController.text)),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.blue)),
              ),
              onSubmitted: searchNews,
            ),
          ),
          if (widget.appState.selectedInterests.isEmpty && (currentQuery == null || currentQuery!.isEmpty))
            Center(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedCategory = category);
                          loadNews(isRefresh: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withValues(alpha:0.3)),
                          ),
                          child: Text(category.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () => loadNews(isRefresh: true),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: articles.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == articles.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final article = articles[index];
                  return NewsCard(article: article, appState: widget.appState);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendingScreen extends StatefulWidget {
  final AppState appState;
  const TrendingScreen({super.key, required this.appState});

  @override
  TrendingScreenState createState() => TrendingScreenState();
}

class TrendingScreenState extends State<TrendingScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Article> trendingArticles = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    loadTrendingNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoadingMore) {
        loadTrendingNews(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadTrendingNews({bool isRefresh = false, bool isLoadMore = false}) async {
    if (isLoadingMore || (isLoadMore && !hasMore)) return;

    if (isRefresh) {
      page = 1;
      hasMore = true;
      trendingArticles.clear();
    }

    if (mounted) {
      setState(() {
        if (isLoadMore) {
          isLoadingMore = true;
        } else {
          isLoading = true;
        }
      });
    }

    try {
      final newArticles = await NewsService.getNews(endpoint: 'top-headlines', country: 'us', page: page);
      if (mounted) {
        setState(() {
          if (newArticles.isEmpty) {
            hasMore = false;
          } else {
            trendingArticles.addAll(newArticles);
            page++;
          }
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Row(children: [Icon(Icons.trending_up, color: Colors.red), SizedBox(width: 8), Text('Trending')])),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => loadTrendingNews(isRefresh: true),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: trendingArticles.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == trendingArticles.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return NewsCard(article: trendingArticles[index], appState: widget.appState);
          },
        ),
      ),
    );
  }
}

class SavedNewsScreen extends StatelessWidget {
  final AppState appState;
  const SavedNewsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final savedArticles = appState.savedArticles;

    return Scaffold(
      appBar: AppBar(title: const Row(children: [Icon(Icons.bookmark, color: Colors.blue), SizedBox(width: 8), Text('Saved News')])),
      body: savedArticles.isEmpty
          ? const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No saved articles yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text('Save articles to read them later', style: TextStyle(color: Colors.grey)),
        ]),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: savedArticles.length,
        itemBuilder: (context, index) {
          final article = savedArticles[savedArticles.length - 1 - index];
          return NewsCard(article: article, appState: appState);
        },
      ),
    );
  }
}

class InterestsScreen extends StatefulWidget {
  final AppState appState;
  const InterestsScreen({super.key, required this.appState});

  @override
  InterestsScreenState createState() => InterestsScreenState();
}

class InterestsScreenState extends State<InterestsScreen> {
  late List<String> _selectedInterests;
  final List<Map<String, dynamic>> interests = [
    {'name': 'Health', 'icon': Icons.health_and_safety}, {'name': 'Technology', 'icon': Icons.computer},
    {'name': 'Sports', 'icon': Icons.sports_soccer}, {'name': 'Finance', 'icon': Icons.attach_money},
    {'name': 'Business', 'icon': Icons.business}, {'name': 'Politics', 'icon': Icons.how_to_vote},
    {'name': 'Science', 'icon': Icons.science}, {'name': 'Entertainment', 'icon': Icons.movie},
  ];

  @override
  void initState() {
    super.initState();
    _selectedInterests = List<String>.from(widget.appState.selectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Interests'),
        actions: [
          TextButton(
            onPressed: () {
              widget.appState.saveInterests(_selectedInterests);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Interests saved! Your home feed is updated.')));
            },
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose topics to personalize your news feed', style: TextStyle(fontSize: 16, color: Colors.grey[300])),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 16, mainAxisSpacing: 16),
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  final interest = interests[index];
                  final isSelected = _selectedInterests.contains(interest['name']);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest['name']);
                      } else {
                        _selectedInterests.add(interest['name']);
                      }
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withValues(alpha:0.2) : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withValues(alpha:0.3), width: 2),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(interest['icon'], size: 32, color: isSelected ? Colors.blue : Colors.grey),
                        const SizedBox(height: 8),
                        Text(interest['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.white)),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NewsCard extends StatelessWidget {
  final Article article;
  final AppState appState;

  const NewsCard({super.key, required this.article, required this.appState});

  String timeAgo(String dateString) {
    if (dateString.isEmpty) return 'recently';
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    return '${difference.inMinutes}m ago';
  }

  Future<void> _launchURL(BuildContext context, String urlString) async {
    if (!urlString.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid link format')));
      return;
    }
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open article')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaved = appState.savedArticles.any((a) => a.url == article.url);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(height: 200, color: Colors.grey[800], child: const Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    SizedBox(height: 8),
                    Text('Image not available', style: TextStyle(color: Colors.grey)),
                  ]),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  if (article.sourceName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.withValues(alpha:0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(article.sourceName!, style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(timeAgo(article.publishedAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
                const SizedBox(height: 8),
                Text(article.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                if (article.description.isNotEmpty)
                  Text(article.description, style: TextStyle(color: Colors.grey[300], fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _launchURL(context, article.url),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Read More'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        appState.toggleSavedArticle(article);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isSaved ? 'Article unsaved!' : 'Article saved!'), duration: const Duration(seconds: 1)));
                      },
                      icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
                      color: isSaved ? Colors.blue : null,
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFF2A2A2A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}