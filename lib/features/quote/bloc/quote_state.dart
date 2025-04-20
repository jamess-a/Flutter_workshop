abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final String quote;
  final String author;

  QuoteLoaded(this.quote, [this.author = ""]);
}

class QuteError extends QuoteState {
  final String message;
  QuteError(this.message);
}

class ListQuoteLoaded extends QuoteState {
  final List<Map<String, String>> quotes;
  ListQuoteLoaded(this.quotes);
}
