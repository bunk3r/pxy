# pxy

```bash
# ./pxy.sh -h

#
#      _____                   _____      _____
#  ___|\    \ _____      _____|\    \    /    /|
# |    |\    \\    \    /    /| \    \  /    / |
# |    | |    |\    \  /    / |  \____\/    /  /
# |    |/____/| \____\/____/   \ |    /    /  /
# |    ||    || /    /\    \    \|___/    /  /
# |    ||____|//    /  \    \       /    /  /
# |____|      /____/ /\ \____\     /____/  /
# |    |      |    |/  \|    |    |     | /
# |____|      |____|    |____|    |_____|/
#

Usage: ./pxy.sh: [-d] [-i] [-l] [-f <file>] [-t <number>] [-b <dbfile>] [-c 1-3] [-s <type>] [-r]

	[-d]: download new data from shodan
	[-i]: interactive session
	[-l]: load pxies from local shodan JSON files
	[-f <file>  ]: load pxies from file ("IP|port" per line)
	[-t <number>]: curl timeout (default to "5" seconds)
	[-b <dbfile>]: sqlite3 file (default to "pxies.db")
	[-c <number>]:
	   1: recheck non active pxies
	   2: all
	   3: active
	[-s geo|active|lit|litssl|litsocks]
	   geo: show geographical data
	   active: show active pxies
	   lit: show active elite pxies
	   litssl: show active elite ssl pxies
	   litsocks: show active elite socks pxies
	[-r]: reset DB (delete file)

```
