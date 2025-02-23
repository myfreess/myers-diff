fn main {
  let args = @sys.get_cli_args()
  guard args is [executable, oldfile, newfile] else {
    println("wrong arguments: \{args}")
    println("Usage: \{args[0]} <file1> <file2>")
  }
  let old = 
    try {
      (@diff.lines(@fs.read_file_to_string!(oldfile)))[:]
    } catch {
      _ => {
        println("\{executable}: failed to load file \{oldfile}")
        panic()
      }
    }
  let new = 
    try {
      (@diff.lines(@fs.read_file_to_string!(newfile)))[:]
    } catch {
      _ => {
        println("\{executable}: failed to load file \{newfile}")
        panic()
      }
    }
  guard @diff.linear_diff(old~, new~) is Some(result) else {
    println("Nothing changed")
  }
  let ins = @chalk.chalk().color(Green)
  let del = @chalk.chalk().color(Red)
  let title = @chalk.chalk().modifier(Bold)
  println("")
  println(title.render("--- \{oldfile}"))
  println(title.render("+++ \{newfile}"))
  for edit in result.iter() {
    match edit {
      Insert(_) => println(ins.render(@diff.pprint_edit(edit)))
      Delete(_) => println(del.render(@diff.pprint_edit(edit)))
      Equal(_) => println(@diff.pprint_edit(edit))
    }
  }
}
