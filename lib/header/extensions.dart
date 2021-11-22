extension KList<T> on List<T> {
  List<T> intersperse(T t, {bool addToEnd = false}) {
    final result = <T>[];
    for (int i = 0; i < this.length; i++) {
      result.add(this[i]);
      final isLastItem = i == (this.length - 1);
      if (!isLastItem || addToEnd) result.add(t);
    }
    return result;
  }
}
