import 'package:flutter/material.dart';

class CatalogueSearchBar extends StatelessWidget {
  const CatalogueSearchBar({
    super.key,
    required this.searchController,
    required this.querySearchCallback,
  });
  final ValueChanged<String> querySearchCallback;

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: searchController,
      trailing: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      hintText: 'Szukaj',
      hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      onChanged: (query) {
        querySearchCallback(query);
      },
      onSubmitted: (query) {
        querySearchCallback(query);
      },
    );
  }
}
