godot --export-debug Web
rsync -v --info=progress2 ~/Programming/Godot/easter_jam_2024/dist/web/* vega:./chronominions/
godot --export-debug "Linux/X11"
godot --export-debug "Windows Desktop"
