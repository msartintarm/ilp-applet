# Generates HTML stuff so I can easily paste into NEOS document.
# For Case 2 only (for now)

ssssspushdqweiuyqweiuyqwe `dirname $0` >& /dev/null

for i in {1..8}; do

    CASE_FILE="case${i}_file.txt"

# Styles
    echo "" >& $CASE_FILE
    echo "<style type=\"text/css\">" >& $CASE_FILE
    cat styles.css >> $CASE_FILE
    echo "</style>" >> $CASE_FILE
    echo "" >> $CASE_FILE

# Scripts
    echo "" >> $CASE_FILE
    echo "<script type=\"application/javascript\">" >> $CASE_FILE
    cat example.js >> $CASE_FILE
    echo "" >> $CASE_FILE
    cat case${i}.js >> $CASE_FILE
    echo "</script>" >> $CASE_FILE
    echo "" >> $CASE_FILE

# HTML source (some tags must be removed)
    echo "" >> $CASE_FILE

# One div below body. Need to take care of last div closing tag manually.

    while read line; do

	if [ -z $IN_BODY ]; then
	    [[ "$line" == *body* ]] && IN_BODY=1
	else
	    if [[ "$line" == *body* ]]; then
		echo "    </div>" >> $CASE_FILE
		unset IN_BODY
	    else echo "$line" >> $CASE_FILE
	    fi
	fi
    done < case${i}.html


    echo Case $i file generated in $CASE_FILE.

done

popd
