import 'package:flutter/material.dart';
import 'package:shopee/core/widgets/top_overlay_snackbar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:shopee/features/quote/presentation/bloc/quote_event.dart';
import 'package:shopee/features/quote/presentation/bloc/quote_state.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  bool showList = false;
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
      appBar: AppBar(
        title: const Text("✨ Random Quote App"),
        actions: [
          IconButton(
            icon: Icon(showList ? Icons.format_quote : Icons.list),
            onPressed: () {
              final bloc = context.read<QuoteBloc>();
              if (!showList) {
                bloc.add(GetListQuoteEvent());
              }
              setState(() {
                showList = !showList;
              });
            },
          )
        ],
      ),
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
                        return Center(
                          child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color.fromARGB(255, 184, 174, 174),
                              ),
                              child: const Center(
                                  child: Text(
                                "Random Quote",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ))),
                        );
                      } else if (state is QuoteLoading) {
                        return Center(
                          child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color.fromARGB(255, 184, 174, 174),
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              )))),
                        );
                      } else if (state is QuoteLoaded) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Color.fromARGB(255, 184, 174, 174),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '"${state.quote}"',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "- ${state.author}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          )),
                        );
                      } else if (showList) {
                        if (state is ListQuoteLoaded) {
                          return Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color.fromARGB(255, 184, 174, 174),
                              ),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: ListView.separated(
                                    itemCount: state.quotes.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      final quote = state.quotes[index]
                                          as Map<String, dynamic>;
                                      return ListTile(
                                        leading: const Icon(Icons.format_quote),
                                        title: Text('"${quote["quote"]}"'),
                                        subtitle: Text('- ${quote["author"]}'),
                                        textColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      );
                                    }),
                              )));
                        }
                      } else {
                        return Center(
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Color.fromARGB(255, 184, 174, 174),
                                ),
                                child: const Center(
                                    child: Text(
                                        "Press the button to get a quote"))));
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
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.blue,
                        size: 30,
                      ),
                      
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
          Align(
            alignment: Alignment.topCenter,
            child: FloatingActionButton(
              onPressed: () {
                context.read<QuoteBloc>().add(GetRandomQuoteEvent());
                setState(() {
                  showList = false;
                });
              },
              backgroundColor: const Color.fromARGB(255, 211, 211, 211),
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
