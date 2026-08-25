{
  config,
  ...
}:
config.scheme {
  template = builtins.readFile ./eww.scss.mustache;
}
