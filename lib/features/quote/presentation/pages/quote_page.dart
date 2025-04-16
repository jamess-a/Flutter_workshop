import 'package:flutter/material.dart';
import 'package:shopee/core/widgets/top_overlay_snackbar.dart'; // Ensure the path is correct

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/quote/bloc/quote_bloc.dart';
import 'package:shopee/features/quote/bloc/quote_event.dart';
import 'package:shopee/features/quote/bloc/quote_state.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  void _showTopOverlay(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 40,
          left: 20,
          right: 20,
          child: TopOverlayWidget(
            message: message,
            onDismissed: () => overlayEntry.remove(),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
  }

  void _showAddQuoteSheet() {
    final quoteController = TextEditingController();
    final authorController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<QuoteBloc>(context),
          child: Builder(
            builder: (innerContext) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(innerContext).viewInsets.bottom + 24,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 40,
                      width: 30,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    const Text(
                      "➕ Add New Quote",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: quoteController,
                      decoration: InputDecoration(
                        labelText: 'Quote',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(
                        labelText: 'Author / Credit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Save Quote"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final quote = quoteController.text.trim();
                        final author = authorController.text.trim();

                        if (quote.isNotEmpty && author.isNotEmpty) {
                          innerContext
                              .read<QuoteBloc>()
                              .add(PostRandomQuoteEvent(quote, author));
                          Navigator.pop(innerContext);
                        } else {
                          _showTopOverlay("Quote and Author: cannot be empty");
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✨ Random Quote App")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<QuoteBloc, QuoteState>(
                    builder: (context, state) {
                      if (state is QuoteInitial) {
                        return const Center(
                            child: Text("Press the button to get a quote"));
                      } else if (state is QuoteLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is QuoteLoaded) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '"${state.quote}"',
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "- ${state.author}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      } else if (state is QuteError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -5) {
                    _showAddQuoteSheet();
                  }
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Swipe up to add a new quote",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                context.read<QuoteBloc>().add(GetRandomQuoteEvent());
              },
              child: const Icon(Icons.refresh),
              backgroundColor: const Color.fromARGB(255, 211, 211, 211),
            ),
          ),
        ],
      ),
    );
  }
}
