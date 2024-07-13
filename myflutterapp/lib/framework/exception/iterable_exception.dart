class IterableException<E extends Exception> implements Exception {
  final List<E> exceptions;
  IterableException(this.exceptions);

  Iterator<E> get iterator => exceptions.iterator;
}
