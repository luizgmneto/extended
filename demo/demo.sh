DIR="$(dirname "$0")"
cd "$DIR"
export FBLIB=libfbembed.so
export FIREBIRD="$DIR"
"$DIR/demo"
