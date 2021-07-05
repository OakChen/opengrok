#! /bin/bash

replace_font() {
	if [[ -f /scripts/embed-font.tmp && -f "$1" && ! -f "$1.bak" ]]; then
		cp "$1" "$1.bak"
		cat /scripts/embed-font.tmp "$1.bak" > "$1"
		sed -i 's#font-family:\([^}]*\)monospace#font-family: "Liberation Mono", "JetBrains Mono", "Roboto Mono", "Courier New", \1monospace#g' "$1"
		sed -i 's#font-family:monospace#font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace#g' "$1"
		sed -i 's#font-family:\([^}]*\)sans-serif#font-family: Roboto,\1sans-serif#g' "$1"
		sed -i 's#font-family:sans-serif#font-family:Roboto,sans-serif#g' "$1"
		sed -i 's# pre {# pre {\n    font-size: 90%;\n    font-family: "Liberation Mono", "JetBrains Mono", "Roboto Mono", "Courier New", monospace;#g' "$1"
		sed -i 's# pre{# pre{font-size:90%;font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace;#g' "$1"
		sed -i 's#.con{font-size:small}#.con{font-size:small;font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace;}#g' "$1"
	fi
}

# 重复尝试替换字体
# shellcheck disable=SC2034
for i in $(seq 0 10); do
	if [[ ! -d /usr/local/tomcat/webapps/ROOT/default/ ]]; then
		sleep 3
	fi
done

# shellcheck disable=SC2044
for file in $(find /usr/local/tomcat/webapps/ROOT/default/ -name "*.css"); do
	replace_font "${file}"
done
