{
  config,
  ...
}:
config.scheme {
  template = builtins.readFile ./eww.mustache.scss;
}
