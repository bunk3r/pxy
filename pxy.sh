#!/bin/bash
#
# PXY - the open pxies tool
# https://github.com/bunk3r/pxy
#
# Author: Andrea "bunker" Purificato - www.purificato.org
#
# REMEMBER: shodan init 'APIKEY' first time
#
# CONFIG
. pxyconfig

banner() {
    b=$((( RANDOM % 5)+1))

    case "$b" in
        1)
            echo ' /$$$$$$$  /$$   /$$ /$$     /$$';
            echo '| $$__  $$| $$  / $$|  $$   /$$/';
            echo '| $$  \ $$|  $$/ $$/ \  $$ /$$/ ';
            echo '| $$$$$$$/ \  $$$$/   \  $$$$/  ';
            echo '| $$____/   >$$  $$    \  $$/   ';
            echo '| $$       /$$/\  $$    | $$    ';
            echo '| $$      | $$  \ $$    | $$    ';
            echo '|__/      |__/  |__/    |__/    ';
            echo '                                ';
            echo '                                ';
            ;;
        2)
            echo '         __   __      __   __       __   ';
            echo '        /\ \ /_/\    /\ \ /\ \     /\_\ ';
            echo '       /  \ \\ \ \   \ \_\\ \ \   / / / ';
            echo '      / /\ \ \\ \ \__/ / / \ \ \_/ / /  ';
            echo '     / / /\ \_\\ \__ \/_/   \ \___/ /   ';
            echo '    / / /_/ / / \/_/\__/\    \ \ \_/    ';
            echo '   / / /__\/ /   _/\/__\ \    \ \ \     ';
            echo '  / / /_____/   / _/_/\ \ \    \ \ \    ';
            echo ' / / /         / / /   \ \ \    \ \ \   ';
            echo '/ / /         / / /    /_/ /     \ \_\  ';
            echo '\/_/          \/_/     \_\/       \/_/  ';
            echo '                                        ';
            ;;
        3)
            echo '                                              ';
            echo '     _____                   _____      _____ ';
            echo ' ___|\    \ _____      _____|\    \    /    /|';
            echo '|    |\    \\    \    /    /| \    \  /    / |';
            echo '|    | |    |\    \  /    / |  \____\/    /  /';
            echo '|    |/____/| \____\/____/   \ |    /    /  / ';
            echo '|    ||    || /    /\    \    \|___/    /  /  ';
            echo '|    ||____|//    /  \    \       /    /  /   ';
            echo '|____|      /____/ /\ \____\     /____/  /    ';
            echo '|    |      |    |/  \|    |    |     | /     ';
            echo '|____|      |____|    |____|    |_____|/      ';
            echo '                                              ';
            ;;
        4)
            echo ' ______   __  __     __  __    ';
            echo '/\  == \ /\_\_\_\   /\ \_\ \   ';
            echo '\ \  _-/ \/_/\_\/_  \ \____ \  ';
            echo ' \ \_\     /\_\/\_\  \/\_____\ ';
            echo '  \/_/     \/_/\/_/   \/_____/ ';
            echo '                               ';
            ;;
        5)
            echo ' ________  ___    ___ ___    __  ';
            echo '|\   __  \|\  \  /  /|\  \  / /| ';
            echo '\ \  \|\  \ \  \/  / | \  \/ / / ';
            echo ' \ \   ____\ \    / / \ \   / /  ';
            echo '  \ \  \___| /    \/   \/  / /   ';
            echo '   \ \__\   /  /\  \ __/  / /    ';
            echo '    \|__|  /__/ /\__\\___/ /     ';
            echo '           |__|/ \|__\___|/      ';
            echo '                                 ';
            echo '                                 ';
            ;;
    esac
    echo ""
}


# USAGE
usage(){
    printf "Usage: %s: [-d] [-i] [-l] [-f <file>] [-t <number>] [-b <dbfile>] [-c 1-3] [-s geo|active|elite|elitessl] [-r]\n\n" $0;
    echo -e "\t[-d]: download new data from shodan";
    echo -e "\t[-i]: interactive session";
    echo -e "\t[-l]: load pxies from local shodan JSON files";
    echo -e "\t[-f <file>  ]: load pxies from file (\"IP|port\" per line)";
    echo -e "\t[-t <number>]: curl timeout (default to \"5\" seconds)";
    echo -e "\t[-b <dbfile>]: sqlite3 file (default to \"pxies.db\")";
    echo -e "\t[-c <number>]:\n\t   1: recheck non active pxies\n\t   2: all\n\t   3: active";
    echo -e "\t[-s geo|active|elite]\n\t   geo: show geographical data\n\t   active: show active pxies\n\t\
   elite: show active elite pxies\n\t   elitessl: show active elite ssl pxies";
    echo -e "\t[-r]: reset DB (delete file)";
    exit 2;
}

# WAIT FOR INPUT
iwait() {
    read -p "Done! Press any key to continue... " -n1 -s;
    echo "";
}

# pxie_check(pixieline)
pxie_check() {
    P_IP=$(echo $1 |cut -d '|' -f 1);
    P_PORT=$(echo $1 |cut -d '|' -f 2);
    TSTAMP=$(date +%s);

    echo -n " # Testing $P_IP:$P_PORT ... "
    # HTTPS
    OUT=$(curl -s -k --proxy-insecure --ssl -x "http://$P_IP:$P_PORT" -m $TIMEOUT "$SSLCKURL" | grep -E "^(ELITE|L1|L2) PROXY");
    if [[ -n "$OUT" ]]; then
        echo "http(SSL)!";
        sqlite3 "$PDBFILE" "UPDATE proxy SET type=\"http\", ssl=\"y\", level=\"$OUT\", checked=\"y\", date=\"$TSTAMP\", active=\"y\" WHERE IP=\"$P_IP\" AND port=$P_PORT";
        return 1
    fi
    # HTTP
    OUT=$(curl -s -x "http://$P_IP:$P_PORT" -m $TIMEOUT "$CHECKURL" | grep -E "^(ELITE|L1|L2) PROXY");
    if [[ -n "$OUT" ]]; then
        echo "http!";
        sqlite3 "$PDBFILE" "UPDATE proxy SET type=\"http\", level=\"$OUT\", checked=\"y\", date=\"$TSTAMP\", active=\"y\" WHERE IP=\"$P_IP\" AND port=$P_PORT";
        return 1
    fi
    # SOCKS4
    OUT=$(curl -s -x "socks4://$P_IP:$P_PORT" -m $TIMEOUT "$CHECKURL" | grep -E "^(ELITE|L1|L2) PROXY");
    if [[ -n "$OUT" ]]; then
        echo "socks4!";
        sqlite3 "$PDBFILE" "UPDATE proxy SET type=\"socks4\", level=\"$OUT\", checked=\"y\", date=\"$TSTAMP\", active=\"y\" WHERE IP=\"$P_IP\" AND port=$P_PORT";
        return 1
    fi
    # SOCKS5
    OUT=$(curl -s -x "socks5://$P_IP:$P_PORT" -m $TIMEOUT "$CHECKURL" | grep -E "^(ELITE|L1|L2) PROXY");
    if [[ -n "$OUT" ]]; then
        echo "socks5!";
        sqlite3 "$PDBFILE" "UPDATE proxy SET type=\"socks5\", level=\"$OUT\", checked=\"y\", date=\"$TSTAMP\", active=\"y\" WHERE IP=\"$P_IP\" AND port=$P_PORT";
        return 1
    fi
    # checked not working!
    sqlite3 "$PDBFILE" "UPDATE proxy SET checked=\"y\", date=\"$TSTAMP\", active=\"n\" WHERE IP=\"$P_IP\" AND port=$P_PORT";
    echo ""
    return;
}

#pxie_insert(pxieline)
pxie_insert() {
    P_IP=$(echo $1 |cut -d '|' -f 1);
    P_PORT=$(echo $1 |cut -d '|' -f 2);
    P_ORG=$(echo $1 |cut -d '|' -f 3);
    P_CNAME=$(echo $1 | cut -d '|' -f 4);
    P_CCODE=$(echo $1 | cut -d '|' -f 5);
    sqlite3 "$PDBFILE" "INSERT OR IGNORE INTO proxy(IP,port,org,country_name,country_code) VALUES(\"$P_IP\",$P_PORT,\"$P_ORG\",\"$P_CNAME\",\"$P_CCODE\")";
    return 0
}

banner;

# GETOPTS
while getopts dilf:t:b:c:rs:h par
do
    case $par in
        d)	echo " -> Downloading data from shodan and updating DB..."
            for p in privoxy squid socks; do
                FN=$p"_`date +%Y-%m-%d_%H-%M-%S`";
                shodan download --limit -1 $FN "product:$p" && shodan parse --separator : --fields ip_str,port $FN.json.gz
            done
            SHODAN="true"
            ;;
        i)	echo " -> Interactive session specified";
            INTERACT="true"
            ;;
        l)	echo " -> Loading from local shodan JSON files..."
            SHODAN="true"
            ;;
        f)	F="${OPTARG//[^a-zA-Z0-9\/\.\-_]/}"
            echo " -> Loding pxies from file \"$F\"..."
            ;;
        t)	T="${OPTARG//[^0-9]/}"
            if [[ -z "$T" ]]; then
                echo " -> Please only numbers! Ignoring it..."
            else
                TIMEOUT="$T"
            fi
            echo " -> Timeout set to: $TIMEOUT"
            ;;
        b)	PDBFILE="${OPTARG//[^a-zA-Z0-9\/\.\-_]/}"
            echo " -> DB file \"$PDBFILE\" set"
            ;;
        c)	TYPE="${OPTARG//[^0-9]/}";
            if [ "$TYPE" -eq 1 ]; then
                CQUERY="select IP,port from proxy where active='n' order by date ASC";
            elif [ "$TYPE" -eq 2 ]; then
                CQUERY="select IP,port from proxy";
            elif [ "$TYPE" -eq 3 ]; then
                CQUERY="select IP,port from proxy where active='y' order by date ASC";
            else
                echo " -> Please only \"1-3\"! Ignoring it..."
            fi
            ;;
        r)	echo " -> Reset DB - delete old file..."
            if [ -f "$PDBFILE" ]; then
                rm "$PDBFILE"
            fi
            ;;
        s)	SHOW="${OPTARG//[^a-zA-Z]/}"
            if [[ "$SHOW" == "geo" ]]; then
                sqlite3 $PDBFILE "select type,IP,port,level,quote(country_name),quote(country_code) from proxy where active='y'";
                exit;
            elif [[ "$SHOW" == "active" ]]; then
                sqlite3 $PDBFILE --separator ' ' "select type,IP,port,level from proxy where active='y'";
                exit;
            elif [[ "$SHOW" == "elite" ]]; then
                sqlite3 $PDBFILE --separator ' ' "select type,IP,port from proxy where active='y' and level like 'ELITE%'";
                exit;
            elif [[ "$SHOW" == "elitessl" ]]; then
                sqlite3 $PDBFILE --separator ' ' "select type,IP,port from proxy where active='y' and ssl='y' and level like 'ELITE%'";
                exit;
            else
                usage;
            fi
            ;;
        h|?)
            usage;
            ;;
    esac
done
shift $(($OPTIND - 1))

if [ -f "$PDBFILE" ]; then
    echo "File \"$PDBFILE\" found! Using it...";
else
    echo " -> Creating new DB..."
    sqlite3 "$PDBFILE" 'CREATE TABLE proxy (id INTEGER PRIMARY KEY, IP TEXT, port NUMERIC, type TEXT, ssl TEXT, level TEXT, checked TEXT, date NUMERIC, active TEXT, org TEXT, country_name TEXT, country_code TEXT, UNIQUE(IP, port));';
fi

if [[ -n "$SHODAN" ]]; then
    echo " -> Importing data from shodan JSON files and updating DB..."
    IFS=$'\n';
    for p in `shodan parse --separator '|' --fields ip_str,port,org,location.country_name,location.country_code *.json.gz | sort -u`; do
        pxie_insert "$p";
    done
    unset IFS;
fi
if [[ -n "$INTERACT" ]]; then iwait; fi

if [[ -n "$F" ]]; then
    while read -r p; do
        pxie_insert "$p";
        pxie_check "$p";
    done < "$F"
else
    IFS=$'\n';
    for p in `sqlite3 $PDBFILE "$CQUERY"`; do
        pxie_check "$p";
    done
    unset IFS;
fi
if [[ -n "$INTERACT" ]]; then iwait; fi
exit
