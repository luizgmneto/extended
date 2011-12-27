DIR="$(dirname "$0")"
cd "$DIR"
export FBLIB=libfbembed.so
export FIREBIRD="$DIR"
export LD_LIBRARY_PATH="$DIR"
startlazarus
