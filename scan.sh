#! /bin/bash
REGEX='"Vulnerable": (true|false)'
FILE=ips.csv

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


if [ ! -f "$FILE" ]; then
    printf "List is missing, create a '${GREEN}ips.csv${NC}' with '${GREEN};${NC}' as delimiter\r\n"
    printf "Without a headline, Format: IP;PORT\r\n"

    exit 1
fi

echo "====";
while IFS=";" read -r ip port
do
    OUTPUT=`bin/terrapin -connect "$ip:$port" -json`

    [[ $OUTPUT =~ $REGEX ]]

    COLOR=${RED}
    if [ ${BASH_REMATCH[1]} == "false" ]
    then
        COLOR=${GREEN}
    fi

    printf "$ip => Vulnerable: ${COLOR}${BASH_REMATCH[1]}${NC}\r\n"

done < <(tail $FILE)
echo "====";
exit 0;