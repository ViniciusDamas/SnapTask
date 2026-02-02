enum CardStatus { open, done }

extension CardStatusLabel on CardStatus {
  String get label {
    switch (this) {
      case CardStatus.open:
        return 'Aberto';
      case CardStatus.done:
        return 'Finalizado';
    }
  }
}
