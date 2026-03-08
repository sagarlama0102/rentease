import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';
import 'package:rentease/app/theme/theme_extensions.dart'; // Import your extension

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {}); 
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(propertyViewModelProvider.notifier).searchProperties(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        
        color: context.inputFillColor, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(
          color: context.borderColor.withOpacity(0.5), 
          width: 1.5,
        ),
        boxShadow: context.softShadow, 
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded, 
            color: context.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              // FIX: Ensures typing text is visible in both modes
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Search address, city...",
                hintStyle: TextStyle(
                  color: context.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.cancel_rounded, color: context.textSecondary, size: 20),
              onPressed: () {
                _controller.clear();
                ref.read(propertyViewModelProvider.notifier).searchProperties("");
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}