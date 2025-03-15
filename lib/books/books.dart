import 'dart:math';

import 'package:flutter/material.dart';

class BookShelfPage extends StatefulWidget {
  const BookShelfPage({super.key, required this.title});

  final String title;

  @override
  State<BookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  //Dimension based on my book asset's aspect ratio. This makes sure the assets are not stretched.
  static const double fixedHeight = 300;
  static const double spineWidth = fixedHeight * 0.0957536;
  static const double coverWidth = fixedHeight * 0.65;

  @override
  Widget build(BuildContext context) {
    final books = <Book>[
      Book(
        coverAsset: 'assets/images/1_stoic.png',
        spineAsset: 'assets/images/1_stoic_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/2_moon.png',
        spineAsset: 'assets/images/2_moon_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/3_dog.png',
        spineAsset: 'assets/images/3_dog_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/4_bird.png',
        spineAsset: 'assets/images/4_bird_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/1_stoic.png',
        spineAsset: 'assets/images/1_stoic_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/2_moon.png',
        spineAsset: 'assets/images/2_moon_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/3_dog.png',
        spineAsset: 'assets/images/3_dog_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/4_bird.png',
        spineAsset: 'assets/images/4_bird_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/1_stoic.png',
        spineAsset: 'assets/images/1_stoic_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/2_moon.png',
        spineAsset: 'assets/images/2_moon_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/3_dog.png',
        spineAsset: 'assets/images/3_dog_spine.png',
      ),
      Book(
        coverAsset: 'assets/images/4_bird.png',
        spineAsset: 'assets/images/4_bird_spine.png',
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300, // Adjust as needed
            child: BookshelfWidget(books: books),
          ),
        ),
      ),
    );
  }
}

class BookWidget extends StatefulWidget {
  const BookWidget({
    super.key,
    required this.book,
    required this.isOpen,
  });

  final Book book;
  final bool isOpen;

  @override
  BookWidgetState createState() => BookWidgetState();
}

class BookWidgetState extends State<BookWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -pi / 2, end: 0).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(BookWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationState();
  }

  void _updateAnimationState() {
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(_BookShelfPageState.spineWidth, 0),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(_animation.value)
              ..translate(0.0),
            alignment: Alignment.centerLeft,
            child: _buildBookContent(),
          );
        },
      ),
    );
  }

  Widget _buildBookContent() {
    return Stack(
      children: [
        // Cover image
        SizedBox(
          width: _BookShelfPageState.coverWidth,
          height: _BookShelfPageState.fixedHeight,
          child: Image.asset(
            widget.book.coverAsset,
            fit: BoxFit.fill,
          ),
        ),
        // Spine image
        Transform(
          transform: Matrix4.identity()
            ..rotateY(pi / 2)
            ..translate(-_BookShelfPageState.spineWidth),
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: _BookShelfPageState.spineWidth,
            height: _BookShelfPageState.fixedHeight,
            child: Image.asset(
              widget.book.spineAsset,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

class Book {
  Book({
    required this.coverAsset,
    required this.spineAsset,
    this.isOpen = false,
  });

  final String coverAsset;
  final String spineAsset;
  bool isOpen;
}

class BookshelfWidget extends StatefulWidget {
  const BookshelfWidget({super.key, required this.books});

  final List<Book> books;

  @override
  State<BookshelfWidget> createState() => _BookshelfWidgetState();
}

class _BookshelfWidgetState extends State<BookshelfWidget> {
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _books = widget.books;
  }

  void _toggleBook(int index) {
    debugPrint('on tap gesture');
    setState(() {
      for (var i = 0; i < _books.length; i++) {
        if (i == index) {
          _books[i].isOpen = !_books[i].isOpen;
        } else {
          _books[i].isOpen = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20),
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      itemCount: widget.books.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _toggleBook(index),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.zero,
            child: AnimatedBookWrapper(
              isOpen: _books[index].isOpen,
              child: BookWidget(
                book: _books[index],
                isOpen: _books[index].isOpen,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedBookWrapper extends StatelessWidget {
  const AnimatedBookWrapper({
    super.key,
    required this.child,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final bool isOpen;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: isOpen
          ? 240 //_MyHomePageState.coverWidth + 10
          : _BookShelfPageState.spineWidth + 5, // Adjust these values as needed
      child: child,
    );
  }
}
