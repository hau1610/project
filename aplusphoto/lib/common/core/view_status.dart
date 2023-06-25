

enum ViewStatus { initial, success, error }

extension ViewStatusX on ViewStatus {
  bool get isInitial => this == ViewStatus.initial;
  bool get isEmpty => this == ViewStatus.success;
  bool get isError => this == ViewStatus.error;
}

