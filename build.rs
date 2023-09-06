pub fn main() -> std::io::Result<()> {
    ocaml_build::Sigs::new("src/unicode_width.ml").generate()
}
