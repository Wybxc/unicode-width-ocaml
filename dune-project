(lang dune 3.5)
(name unicode-width)

(generate_opam_files true)

(maintainers "Wybxc <wybxc@qq.com>")
(authors "Wybxc <wybxc@qq.com>")
(homepage "https://github.com/Wybxc/unicode-width-ocaml")
(bug_reports "https://github.com/Wybxc/unicode-width-ocaml/issues")

(package
 (name unicode-width)
 (synopsis "Unicode width for OCaml")
 (description "Displayed width of Unicode characters and strings")
 (depends
  (ocaml (>= "4.03.0"))
  (dune (>= "3.5"))
  conf-rust))