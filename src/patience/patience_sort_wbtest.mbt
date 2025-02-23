
fn run_test(old~ : String, new~ : String) -> Array[(Int, Int)] {
  let old = @diff.lines(old)[:]
  let new = @diff.lines(new)[:]
  longest_increasing_subsequence(find_unique(old~, new~))
}

test "totally different" {
  let old =
    #|aaaaa
    #|bbbbb
    #|ccccc
  let new = ""
  inspect!(run_test(old~, new~), content="[]")
}

test "divide into two" {
  let old =
    #|aaaaa
    #|00000
    #|bbbbb
    #|ccccc
  let new =
    #|ddddd
    #|eeeee
    #|00000
    #|fffff
  inspect!(run_test(old~, new~), content="[(1, 2)]")
}


test "reverse order" {
  let old =
    #|aaaaa
    #|bbbbb
    #|ccccc
  let new =
    #|ccccc
    #|bbbbb
    #|aaaaa
  inspect!(run_test(old~, new~), content="[(0, 2)]")
}

test "insert" {
  let old =
    #|aaaaa
    #|bbbbb
    #|ccccc
  let new =
    #|aaaaa
    #|11111
    #|bbbbb
    #|22222
    #|ccccc
  inspect!(run_test(old~, new~), content="[(0, 0), (1, 2), (2, 4)]")
}

test "reorder" {
  let old =
    #|aaaaa
    #|
    #|bbbbb
    #|
    #|ccccc
  let new = 
    #|bbbbb
    #|
    #|aaaaa
    #|
    #|ccccc
  inspect!(run_test(old~, new~), content="[(0, 2), (4, 4)]")
}

test "insert then reorder" {
  let old =
    #|aaaaa
    #|bbbbb
    #|ccccc
  let new =
    #|bbbbb
    #|00000
    #|aaaaa
    #|11111
    #|22222
    #|ccccc
  inspect!(run_test(old~, new~), content="[(0, 2), (2, 5)]")
}

