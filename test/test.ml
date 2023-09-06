let () =
  let s = "abc" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 3)

let () =
  let s = "あいう" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 6)

let () =
  let s = "你好" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 4)

let () =
  let s = "안녕하세요" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 10)

let () =
  let s = "“”" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 2)

let () =
  let s = "“”" in
  let width = Unicode_width.of_utf8_string_cjk s in
  assert (width = 4)

let () =
  let s = "ĀāǍǎ" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 4)

let () =
  let s = "😅" in
  let width = Unicode_width.of_utf8_string s in
  assert (width = 2)

let () =
  Printf.printf "All tests passed!\n"