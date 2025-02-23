fn find_unique(old~ : ArrayView[@diff.Line], new~ : ArrayView[@diff.Line]) -> Array[(Int, Int)] {
  struct CountRecord {
    old_idx : Int
    mut old_count : Int
    mut new_idx : Int
    mut new_count : Int
  }
  // assume hashmap preserve insert order
  let match_lines = @hashmap.new()
  for i = 0; i < old.length(); i = i + 1 {
    if match_lines.contains(old[i].text) {
      let count_record : CountRecord = match_lines[old[i].text].unwrap()
      count_record.old_count = count_record.old_count + 1
    } else {
      match_lines[old[i].text] = CountRecord::{ old_idx : i, old_count : 1, new_idx : -1, new_count : 0 }
    }
  }
  for i = 0; i < new.length(); i = i + 1 {
    if match_lines.contains(new[i].text) {
      let count_record = match_lines[new[i].text].unwrap()
      count_record.new_count = count_record.new_count + 1
      if count_record.new_idx == -1 {
        count_record.new_idx = i
      }
    }
  }
  let match_lines = match_lines.iter().filter(fn {
    (_, record) => record.new_count == 1 && record.old_count == 1
  })
  let unique_match_lines = []
  for pair in match_lines {
    let (_, record) = pair
    unique_match_lines.push((record.old_idx, record.new_idx))
  }
  // unique_match_lines.sort_by_key(fn { (old_idx, _) => old_idx })
  return unique_match_lines
}

