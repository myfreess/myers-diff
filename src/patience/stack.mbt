struct Stack[T] {
  mut top : T
  mut stack : @immut/list.T[T]
}

fn push[T](self : Stack[T], t : T) -> Unit {
  self.stack = Cons(self.top, self.stack)
  self.top = t
}

fn peek[T](self : Stack[T]) -> T {
  self.top
}