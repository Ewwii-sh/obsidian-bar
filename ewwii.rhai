fn metric(label, value, onchange, timeout) {
    let need_active = onchange != "";

    box(#{
        orientation: "h",
        class: "metric",
        space_evenly: false,
    }, [
        box(#{ class: "label" }, [
            label(#{ text: label }),
        ]),
        scale(#{
            min: 0,
            max: 101,
            active: need_active,
            value: value,
            onchange: onchange,
            timeout: timeout,
        })
    ])
}

// widgets
fn bar(
    // center
    music, is_playing,

    // left
    ws_info, mem_usage_perc,

    // right
    battery_state, battery_percent, volume, time
) {
  box(#{ 
    orientation: "h",
  }, [
    left(
        ws_info, mem_usage_perc
    ),
    center(music, is_playing),
    right(battery_state, battery_percent, volume, time),
  ])
}

fn cal(day, year) {
    box(#{
        orientation: "v",
    }, [
        box(#{ class: "calendar", orientation: "v" }, [
            box(#{ class: "calendar-in" }, [
                calendar(#{
                    class: "calendar",
                    day: day,
                    year: year,
                })
            ])
        ])
    ])
}
    
fn separator() {
  box(#{
    class: "separator",
    width: "1px",
    height: "20px",
    margin: "0 8px",
  }, [])
}

fn right(battery_state, battery_percent, volume, time) {
  // battery box class:
  let battery_box_class = if battery_state == "charging" {
    "battery-charging"
  } else if battery_state == "fully-charged" {
    "battery-full"
  } else {
    "battery-discharging"
  };

  box(#{
      class: "right", orientation: "h", space_evenly: false, halign: "end",
  }, [
    box(#{ visible: battery_state != "unknown" }, [
        button(#{
            onclick: "",
            class: battery_box_class,
            label: `󰁹 ${battery_percent}% `,
        }),
    ]),

    separator(),

    metric("", volume, "pamixer --set-volume {}", "500ms"),

    button(#{ onclick: "scripts/calendar_popup", timeout: "5s", label: " : " + time }),
  ])
}

fn left(
    ws_info,
    mem_usage_perc
) {
    let ws_info = parse_json(ws_info);
    for i in 1..10 {
        let key = "workspace_" + i;
        if ws_info[key] == () {
            ws_info[key] = "·";
        }
    }

    box(#{
        class: "workspace",
        orientation: "h",
        space_evenly: false,
        halign: "start",
        spacing: 5,
    }, [
            button(#{ onclick: "hyprctl dispatch workspace 1", label: ws_info["workspace_1"] }),
            button(#{ onclick: "hyprctl dispatch workspace 2", label: ws_info["workspace_2"] }),
            button(#{ onclick: "hyprctl dispatch workspace  3", label: ws_info["workspace_3"] }),
            button(#{ onclick: "hyprctl dispatch workspace  4", label: ws_info["workspace_4"] }),
            button(#{ onclick: "hyprctl dispatch workspace  5", label: ws_info["workspace_5"] }),
            button(#{ onclick: "hyprctl dispatch workspace  6", label: ws_info["workspace_6"] }),
            button(#{ onclick: "hyprctl dispatch workspace  7", label: ws_info["workspace_7"] }),
            button(#{ onclick: "hyprctl dispatch workspace  8", label: ws_info["workspace_8"] }),
            button(#{ onclick: "hyprctl dispatch workspace  9", label: ws_info["workspace_9"] }),
            button(#{ onclick: "hyprctl dispatch workspace  10", label: ws_info["workspace_10"] }),

            separator(),

            metric("", mem_usage_perc, "", "1s"),
        ])
}

fn center(music, is_playing) {
    let play_btn_label = if !(is_playing == "true") { "󰐊" } else { "" };

    box(#{
        class: "center",
        orientation: "h",
        space_evenly: false,
        halign: "center",
    }, [
        // title
        label(#{ text: ": " + music }),

        box(#{ width: "10px" }, []), // spacing

        // Previous button
        button(#{ onclick: "mpc prev", label: "󰒮" }),

        // Play button
        button(#{
            onclick: "mpc toggle",
            label: play_btn_label, // can be both play/pause button
        }),

        // Next track button
        button(#{ onclick: "mpc next", label: "󰒭" }),
    ])
}

enter([
    poll("day", #{ interval: "20h", cmd: "date '+%d'" }),
    poll("year", #{ interval: "20h", cmd: "date '+%Y'" }),

    listen("is_playing", #{ initial: "false", cmd: "scripts/music" }),

    listen("music", #{ initial: "", cmd: "scripts/music_title" }),

    poll("battery_state", #{ interval: "2s", initial: "unknown", cmd: "scripts/getbattery state" }),
    poll("battery_percent", #{ interval: "2s", initial: "0", cmd: "scripts/getbattery percent" }),

    listen("volume", #{ initial: "", cmd: "scripts/getvol" }),

    poll("time", #{ interval: "10s", cmd: "date '+%H:%M'" }),

    listen("wsp_info", #{ initial: "{}", cmd: "scripts/workspace" }),

    poll("mem_usage_perc", #{ 
        interval: "2s",
        initial: "0%", 
        cmd: "awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {print (total-avail)/total*100}' /proc/meminfo",
    }),

    // windows
    defwindow("obsidian_bar", #{
        monitor: 0,
        windowtype: "dock",
        geometry: #{ 
            x: "0%",
            y: "0%",
            width: "100%",
            height: "10px",
        },
        exclusive: true,
    }, bar(
        music, is_playing,

        wsp_info, mem_usage_perc,

        battery_state, battery_percent, volume, time
    )),

    defwindow("calendar_popup", #{
        geometry: #{
            x: "10px",
            y: "0px",
            anchor: "top right",
            width: "270px",
            height: "60px"
        },
        windowtype: "dialog",
    }, cal(day, year)),
]);

