
replace_font() {
	if [[ -f /tmp/embed-font.tmp && -f "$1" && ! -f "$1.bak" ]]; then
		cp $1 $1.bak
		cat /tmp/embed-font.tmp $1.bak > $1
		sed -i "s/font-family:\([^?]*\)monospace/font-family: \"Roboto Mono\",\1monospace/g" $1
		sed -i "s/font-family:monospace/font-family:\"Roboto Mono\",monospace/g" $1
		sed -i "s/font-family:\([^?]*\)sans-serif/font-family: Roboto,\1sans-serif/g" $1
		sed -i "s/font-family:sans-serif/font-family:Roboto,sans-serif/g" $1
		sed -i "s/ pre {/ pre {\n    font-size: 90%;\n    font-family: \"Roboto Mono\", \"Courier New\", monospace;/g" $1
		sed -i "s/ pre{/ pre{font-size:90%;font-family:\"Roboto Mono\",\"Courier New\",monospace;/g" $1
	fi
}

replace_font /usr/local/tomcat/webapps/ROOT/default/print.css
replace_font /usr/local/tomcat/webapps/ROOT/default/mandoc.css
replace_font /usr/local/tomcat/webapps/ROOT/default/style.css
replace_font /usr/local/tomcat/webapps/ROOT/default/print.min.css
replace_font /usr/local/tomcat/webapps/ROOT/default/mandoc.min.css
replace_font /usr/local/tomcat/webapps/ROOT/default/style.min.css
