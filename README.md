# Desktop Lamp
A Godot 4 application to use a hardware display as a light source.

## Why?
I like to keep the lights low in my office, and my desk free of extra appliances. I can pop this
up to use my monitor as a quick light source while scribbling on paper or reading from a book. It also
doubles as a nice way to black out my second monitor while gaming full screen on my primary display.

## Configurable
When using the application, changes are saved to the `settings.json` file located at: `%appdata%\Godot\app_userdata\Desk Lamp\settings.json`. Launch the app and press F2 to open this directory in File Explorer.

Modify this file to customize your setup. I recommend closing the app before making changes to this file. When interacting with the app, changes are automatically saved, which can overwrite your work. Relaunch the app after making changes to see the effects. If the app stops working after making changes to the file, simply back up your work and delete the file. The app will recreate a valid `settings.json` on next launch.

Here's a breakdown of the structure and settings:

```json
{
    // Default brightness when enabling lamp.
    // Valid ranges are 0.0 - 1.0
	"brightness": 1.0,

    // Brightness adjust amount each time you press +/- keys.
	"brightness_step_amount": 0.05,

    // The current color palette selection.
    // Select the next or previous color palette using left/right arrow keys.
    // Select color palettes 0-9 using number keys.
	"color_selection_number": 0,

    // Whether the lamp is enabled on launch.
	"enabled": false,

    // The list of "off" colors. This is the displayed color when "enabled" = false.
    // Specify as many of these as you like and cycle through them using the left/right arrow keys.
    // The first 10 colors in this list are accessible using num keys 0-9.
    // Colors can be any valid color Godot understands. When specifying hex codes, be sure to inclue the '#' symbol.
    // When there are fewer than 10 colors in this list, or when the number of entries is fewer than the "on_colors" list, the "off" color defaults to "black" when incrementing the color selection.
	"off_colors": [
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black"
	],
    // The list of "on" colors. This is the displayed color when "enabled" = true.
    // Specify as many of these as you like and cycle through them using the left/right arrow keys.
    // The first 10 colors in this list are accessible using num keys 0-9.
    // Colors can be any valid color Godot understands. When specifying hex codes, be sure to inclue the '#' symbol.
    // When there are fewer than 10 colors in this list, or when the number of entries is fewer than the "off_colors" list, the "on" color defaults to "white" when incrementing the color selection.
	"on_colors": [
		"#ffffff",
		"#f5f5dc",
		"#fff8e7",
		"#fdfd96",
		"#ffd580",
		"#c0fefc",
		"#add8e6",
		"#e6e6fa",
		"#ffe4e1",
		"#d3d3d3"
	]
}
```

## OS Compatibility
I designed this for use in Windows 11. If you build this for Mac/Linux/Other you will probably need
to update the Input Map to make sense for your platform. These are configured in the Godot Editor's `Project Settings -> Input Map` tab.

## Contributing
Fork the repo, make your changes, and open a pull request. Include clear code comments and update this README with any relevant documentation. Add helpful notes in your pull request to explain the goals and context of your contributions.

## License
This project is licensed under MIT. See LICENSE for details.