part of 'rx_stream.dart';

/// A node in a doubly-linked list that holds data of type T.
class Node<T> {
  final T? data;
  Node<T>? next;
  Node<T>? prev;
  
  Node({this.data, this.next, this.prev});
  
  /// Creates a pair of connected nodes with the same data
  static (Node<E>, Node<E>) createPair<E>(E data) => (
        Node(data: data),
        Node(data: data, prev: Node(data: data)),
      );
}

/// A subscription to a [MiniStream] that can be used to cancel the subscription.
class MiniSubscription<T> {
  const MiniSubscription(
    this.data, 
    this.onError, 
    this.onDone, 
    this.cancelOnError, 
    this.listener,
  );
  
  final OnData<T> data;
  final Function? onError;
  final Callback? onDone;
  final bool cancelOnError;
  final FastList<T> listener;

  Future<void> cancel() async => listener.removeListener(this);
}

/// A lightweight stream implementation with value semantics and change notifications.
class MiniStream<T> {
  final FastList<T> _listenable = FastList<T>();
  late T _value;
  bool _isClosed = false;

  /// The current value of the stream.
  T get value => _value;
  
  /// Sets the current value and notifies listeners.
  set value(T val) => add(val);
  
  /// The number of active listeners.
  int get length => _listenable.length;
  
  /// Whether there are any active listeners.
  bool get hasListeners => _listenable.isNotEmpty;
  
  /// Whether the stream has been closed.
  bool get isClosed => _isClosed;

  /// Adds a value to the stream and notifies all listeners.
  void add(T event) {
    _value = event;
    _listenable._notifyData(event);
  }

  /// Adds an error to the stream and notifies all error listeners.
  void addError(Object error, [StackTrace? stackTrace]) {
    _listenable._notifyError(error, stackTrace);
  }

  /// Subscribes to the stream.
  MiniSubscription<T> listen(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final subscription = MiniSubscription<T>(
      onData,
      onError,
      onDone,
      cancelOnError,
      _listenable,
    );
    _listenable.addListener(subscription);
    return subscription;
  }

  /// Closes the stream and notifies all listeners.
  void close() {
    if (_isClosed) {
      throw StateError('Cannot close an already closed stream');
    }
    _listenable._notifyDone();
    _listenable.clear();
    _isClosed = true;
  }
}

/// A fast, memory-efficient linked list implementation for managing subscriptions.
class FastList<T> {
  Node<MiniSubscription<T>>? _head;
  Node<MiniSubscription<T>>? _tail;
  int _length = 0;

  /// Whether the list is empty.
  bool get isEmpty => _length == 0;
  
  /// Whether the list is not empty.
  bool get isNotEmpty => !isEmpty;
  
  /// The number of elements in the list.
  int get length => _length;

  /// Notifies all listeners with the given data.
  void _notifyData(T data) {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.data(data);
      currentNode = currentNode.next;
    }
  }

  /// Notifies all listeners that the stream is done.
  void _notifyDone() {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.onDone?.call();
      currentNode = currentNode.next;
    }
  }

  /// Notifies all error listeners with the given error.
  void _notifyError(Object error, [StackTrace? stackTrace]) {
    var currentNode = _head;
    while (currentNode != null) {
      final onError = currentNode.data?.onError;
      if (onError != null) {
        if (onError is Function(dynamic, StackTrace?)) {
          onError(error, stackTrace ?? StackTrace.current);
        } else if (onError is Function(dynamic)) {
          onError(error);
        } else {
          onError(error, stackTrace);
        }
      }
      currentNode = currentNode.next;
    }
  }

  /// Gets the element at the specified position, or null if out of bounds.
  ({bool found, MiniSubscription<T>? value}) elementAt(int position) {
    if (isEmpty || position < 0 || position >= _length) {
      return (found: false, value: null);
    }

    var node = _head;
    var current = 0;

    while (current != position) {
      node = node!.next;
      current++;
    }
    return (found: true, value: node!.data);
  }

  /// Adds a listener to the list.
  void addListener(MiniSubscription<T> data) {
    final newNode = Node(data: data);
    
    if (isEmpty) {
      _head = _tail = newNode;
    } else {
      _tail!.next = newNode;
      newNode.prev = _tail;
      _tail = newNode;
    }
    _length++;
  }

  /// Whether the list contains the given element.
  bool contains(T element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) return true;
      currentNode = currentNode.next;
    }
    return false;
  }

  /// Removes the first occurrence of the given element from the list.
  void removeListener(MiniSubscription<T> element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) {
        _removeNode(currentNode);
        break;
      }
      currentNode = currentNode.next;
    }
  }

  /// Removes all elements from the list.
  void clear() {
    _head = _tail = null;
    _length = 0;
  }

  /// Removes the given node from the list.
  void _removeNode(Node<MiniSubscription<T>> node) {
    // Update previous node's next pointer
    if (node.prev == null) {
      _head = node.next;
    } else {
      node.prev!.next = node.next;
    }

    // Update next node's previous pointer
    if (node.next == null) {
      _tail = node.prev;
    } else {
      node.next!.prev = node.prev;
    }

    _length--;
  }
}
