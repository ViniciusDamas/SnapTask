enum CardStatus { open, done }

extension CardStatusX on CardStatus {
  static CardStatus fromApi(dynamic value) {
    if (value == null) return CardStatus.open;

    final s = value.toString().toLowerCase();
    switch (s) {
      case 'open':
        return CardStatus.open;
      case 'done':
        return CardStatus.done;
      default:
        return CardStatus.open;
    }
  }

  String toApi() {
    switch (this) {
      case CardStatus.open:
        return 'Open';
      case CardStatus.done:
        return 'Done';
    }
  }

  String get label {
    switch (this) {
      case CardStatus.open:
        return 'Aberto';
      case CardStatus.done:
        return 'Finalizado';
    }
  }
}
