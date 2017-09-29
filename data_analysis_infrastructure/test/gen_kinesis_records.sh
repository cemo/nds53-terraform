#!/bin/bash

STREAM=$1
COUNT=${2:-300}

set -eu

if [ -z "$STREAM" ]; then
  echo "usage: $0 stream [count]" >&2
  exit 1
fi

tags=('foo' 'bar' 'buz')
partition_key="pk-1"

echo '{"Records": ['

for i in $(seq 1 $(($COUNT - 1))); do
  echo -n '{"Data": "'
  echo -n "{ \\\"time\\\": $(gdate +%s.%6N), \\\"tag\\\": \\\"${tags[$(( $RANDOM % ${#tags[@]} ))]}\\\", \\\"value\\\": $RANDOM }"
  echo -n '", '
  echo "\"PartitionKey\": \"$partition_key\"},"
done

echo -n '{"Data": "'
echo -n "{ \\\"time\\\": $(gdate +%s.%6N), \\\"tag\\\": \\\"${tags[$(( $RANDOM % ${#tags[@]} ))]}\\\", \\\"value\\\": $RANDOM }"
echo -n '", '
echo "\"PartitionKey\": \"$partition_key\"}],"

echo "\"StreamName\": \"$STREAM\"}"
