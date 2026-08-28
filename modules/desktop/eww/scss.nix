{
  config,
  ...
}:
let
  baseSize = config.fonts.size;
in
config.scheme {
  template =
    builtins.replaceStrings
      [
        "@@font-family@@"
        "@@font-size@@"
        "@@font-size-icon@@"
        "@@font-size-label@@"
        "@@font-size-small@@"
        "@@font-size-idx@@"
      ]
      [
        config.fonts.normal
        (toString baseSize)
        (toString (baseSize + 6))
        (toString (baseSize - 2))
        (toString (baseSize - 6))
        (toString (baseSize - 4))
      ]
      (builtins.readFile ./eww.mustache.scss);
}
