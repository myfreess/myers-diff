typealias Pile[T] = Stack[T]
type Piles[T] Array[Pile[T]]

fn is_empty[T](self : Piles[T]) -> Bool {
  self._.is_empty()
}

fn put_back[T](self : Piles[T], singleton : T) -> Unit {
  self._.push(Stack::{ top : singleton, stack : @immut/list.Nil })
}

fn last[T](self : Piles[T]) -> Pile[T]? {
  self._.last()
}

fn op_get[T](self : Piles[T], i : Int) -> Pile[T] {
  self._[i]
}

fn put_by_binary_search(self : Piles[BackPointer[(Int, Int)]], old_idx~ : Int, place~ : Int) -> Unit {
  let mut lo = -1
  let mut hi = self._.length()
  while lo + 1 < hi {
    let mid = (lo + hi) / 2
    if self[mid].top.value.0 < old_idx {
      lo = mid
    } else {
      hi = mid
    }
  }
  if lo >= 0 {
    let prev = Some(self[lo].top)
    if lo + 1 < self._.length() {
      self[lo + 1].push(BackPointer::{ value : (old_idx, place), prev })
    } else {
      self.put_back(BackPointer::{ value : (old_idx, place), prev })
    }
  }
}