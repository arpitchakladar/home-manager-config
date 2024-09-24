config:

with config.scheme.withHashtag;
builtins.toFile "theme.rasi"
''
${builtins.readFile ./theme.rasi}
configuration {
	font: "${config.programs.rofi.font}";
}

* {
	bg: ${base00};
	bg-alt: ${base01};
	fg: ${base07};
	fg-alt: ${base03};
}

window {
	border-color: ${base03};
}
''
