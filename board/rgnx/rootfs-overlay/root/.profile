amixer sset Master unmute >/dev/null 2>&1
amixer sset Master 50% >/dev/null 2>&1
amixer sset PCM 50% unmute >/dev/null 2>&1 || true
echo "Master volume set to 50%."
