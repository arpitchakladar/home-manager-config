config:

with config.scheme.withHashtag;
''
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
	<key>name</key>
	<string>customTheme</string>
	<key>settings</key>
	<array>
		<!-- General Colors -->
		<dict>
			<key>settings</key>
			<dict>
				<key>background</key>
				<string>${base00}</string>
				<key>foreground</key>
				<string>${base05}</string>
				<key>caret</key>
				<string>${base07}</string>
				<key>invisibles</key>
				<string>${base03}</string>
				<key>lineHighlight</key>
				<string>${base02}</string>
				<key>selection</key>
				<string>${base03}</string>
			</dict>
		</dict>
		
		<!-- Syntax-Specific Colors -->
		<dict>
			<key>scope</key>
			<string>comment</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base04}</string>
			</dict>
		</dict>
		
		<dict>
			<key>scope</key>
			<string>string</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0A}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>constant.numeric</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base09}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>variable</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base08}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>keyword</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0D}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>support.function</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0E}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>constant.language</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0B}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>entity.name.tag</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0C}</string>
			</dict>
		</dict>

		<dict>
			<key>scope</key>
			<string>invalid</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>${base0F}</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>
''
