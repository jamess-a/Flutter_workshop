abstract class QuoteEvent {}

class GetRandomQuoteEvent extends QuoteEvent {}

class PostRandomQuoteEvent extends QuoteEvent {
  final String quote;
  final String author;

  PostRandomQuoteEvent(this.quote, this.author);
}

class EditRandomQuoteEvent extends QuoteEvent {}
