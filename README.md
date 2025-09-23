# Obsidian Bar

A dark and sleek bar made with ewwii for [hyprland](https://hypr.land).

## Screenshot

![ObsidianBAR_Screenshot](.github/screenshot.png)

## Install

Obsidian bar can be installed through [eiipm](https://github.com/Ewwii-sh/eiipm). Obsidian bar is set up in a way that it will be intalled in the CWD (Current Working Directory). So you can use the commands below to properly install it:

```bash
# Make a new directory where it will be installed
$ mkdir obsidian-bar

# then enter into it
$ cd obsidian-bar

# Then install obsidian bar (which is set in a way to install to CWD)
$ eiipm i obsidian-bar
```

After running the commands provided above, you will have obsidian bar installed in the current directory. So you can run the following command to render it:

```bash
$ ewwii open obsidian-bar --config .
```

## Dependencies

Obsidian bar is powered by ewwii, and of course, it is the main dependency.

Other than that, obsidian bar also relies on the following:

| Program  | Used for                    |
| -------- | --------------------------- |
| `upower` | Fetching battery percentage |
| `mpd`    | Playing music               |
