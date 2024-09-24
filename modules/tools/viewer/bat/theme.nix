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
                <string>#0F1419</string> <!-- Background (base00) -->
                <key>foreground</key>
                <string>#E6E1CF</string> <!-- Foreground (base05) -->
                <key>caret</key>
                <string>#F3F4F5</string> <!-- Caret (base07) -->
                <key>invisibles</key>
                <string>#3E4B59</string> <!-- Invisibles (base03) -->
                <key>lineHighlight</key>
                <string>#272D38</string> <!-- Line highlight (base02) -->
                <key>selection</key>
                <string>#3E4B59</string> <!-- Selection (base03) -->
            </dict>
        </dict>
        
        <!-- Syntax-Specific Colors -->
        <dict>
            <key>scope</key>
            <string>comment</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#BFBDB6</string> <!-- Comments (base04) -->
            </dict>
        </dict>
        
        <dict>
            <key>scope</key>
            <string>string</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#FFB454</string> <!-- Strings (base0A) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>constant.numeric</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#FF8F40</string> <!-- Numbers (base09) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>variable</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#F07178</string> <!-- Variables (base08) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>keyword</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#59C2FF</string> <!-- Keywords (base0D) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>support.function</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#D2A6FF</string> <!-- Functions (base0E) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>constant.language</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#B8CC52</string> <!-- Constants (base0B) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>entity.name.tag</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#95E6CB</string> <!-- Tags (base0C) -->
            </dict>
        </dict>

        <dict>
            <key>scope</key>
            <string>invalid</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#E6B673</string> <!-- Invalid (base0F) -->
            </dict>
        </dict>
    </array>
</dict>
</plist>
''
