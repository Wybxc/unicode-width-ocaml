# Unicode Width (OCaml Bindings)

## Examples

```ocaml
let () =
  let width = Unicode_width.of_utf8_string "你好，世界！" in
  assert (width = 6)
```

#### License

<sup>
Distributed under the terms of the <a href="LICENSE">Apache-2.0</a> license.
</sup>
