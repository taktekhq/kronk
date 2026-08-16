#!/bin/sh
set -eu

set -a
. "$HOME/kronk-gate.env"
set +a

exec "$HOME/kronk-gate"
