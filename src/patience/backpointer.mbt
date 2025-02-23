struct BackPointer[T] {
  value : T
  prev : BackPointer[T]?
}

fn to_array[T](self : BackPointer[T]) -> Array[T] {
  match self.prev {
    None => [self.value]
    Some(prev) => prev.to_array()..push(self.value)
  }
}