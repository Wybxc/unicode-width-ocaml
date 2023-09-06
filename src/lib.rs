use unicode_width::UnicodeWidthStr;

#[ocaml::func]
#[ocaml::sig("string -> int")]
pub fn of_utf8_string(s: &str) -> usize {
    UnicodeWidthStr::width(s)
}

#[ocaml::func]
#[ocaml::sig("string -> int")]
pub fn of_utf8_string_cjk(s: &str) -> usize {
    UnicodeWidthStr::width_cjk(s)
}
