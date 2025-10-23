let os = ($nu.os-info.name | str downcase)
if $os == "linux" {
	notify-send -e --app-name You Blink!
} else {
    echo "Unsupported OS"
}

