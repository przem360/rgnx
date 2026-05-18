# Odciszamy i ustawiamy głośność na 100%
amixer sset Master unmute
amixer sset Master 100%
# Niektóre karty wymagają też odciszenia PCM lub Headphone
amixer sset PCM 100% unmute || true
