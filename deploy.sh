mkdir dist/web || true
godot43 --export-debug Web
rsync -v --info=progress2 dist/web/* vega:./GrandpasHillRacer/
# godot43 --export-debug "Linux/X11"
# godot43 --export-debug "Windows Desktop"
