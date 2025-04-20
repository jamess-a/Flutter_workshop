import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final List<Map<String, String>> _quotes = [
    {
      "quote": "The best way to predict the future is to invent it.",
      "author": "Alan Kay",
    },
    {
      "quote": "Success is not final; failure is not fatal.",
      "author": "Winston Churchill",
    },
    {
      "quote": "Life is what happens when you're busy making other plans.",
      "author": "John Lennon",
    },
  ];

  QuoteBloc() : super(QuoteInitial()) {
    on<GetRandomQuoteEvent>((event, emit) async {
      emit(QuoteLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final quote = (_quotes..shuffle()).first;
        emit(QuoteLoaded(quote["quote"]!, quote["author"]!));
      } catch (e) {
        emit(QuteError("Failed to load quote"));
      }
    });

    on<PostRandomQuoteEvent>((event, emit) {
      _quotes.add({"quote": event.quote, "author": event.author});
      add(GetListQuoteEvent());
    });

    on<GetListQuoteEvent>((event, emit) {
      emit(ListQuoteLoaded(List.from(_quotes)));
    });
  }
}
