
replace_font() {
	if [[ -f /tmp/embed-font.tmp && -f "$1" && ! -f "$1.bak" ]]; then
		cp $1 $1.bak
		cat /tmp/embed-font.tmp $1.bak > $1
		sed -i 's#font-family:\([^}]*\)monospace#font-family: "Liberation Mono", "JetBrains Mono", "Roboto Mono", "Courier New", \1monospace#g' $1
		sed -i 's#font-family:monospace#font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace#g' $1
		sed -i 's#font-family:\([^}]*\)sans-serif#font-family: Roboto,\1sans-serif#g' $1
		sed -i 's#font-family:sans-serif#font-family:Roboto,sans-serif#g' $1
		sed -i 's# pre {# pre {\n    font-size: 90%;\n    font-family: "Liberation Mono", "JetBrains Mono", "Roboto Mono", "Courier New", monospace;#g' $1
		sed -i 's# pre{# pre{font-size:90%;font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace;#g' $1
		sed -i 's#.con{font-size:small}#.con{font-size:small;font-family:"Liberation Mono","JetBrains Mono","Roboto Mono","Courier New",monospace;}#g' $1
	fi
}

for file in $(find /usr/local/tomcat/webapps/ROOT/default/ -name "*.css"); do
	replace_font ${file}
done
