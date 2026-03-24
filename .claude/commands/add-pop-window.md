---
name: add-pop-window
description: Add a new pop window rule (floating, pinned, sized, centered) to the Hyprland config
---

Add a new entry to `~/.config/hypr/pop-windows.yaml`, then run `hypr-pop-windows-gen` to apply it immediately.

**Step 1 — Find window class and title**

Tell the user to open the target app, then run:
```
hyprctl clients -j | jq '.[] | {class, title}'
```
This shows the exact `class` and `title` values for all open windows. They'll need these in the next steps.

**Step 2 — Gather inputs**

Ask the user for each of these in order (wait for each answer before asking the next):

1. **name** — a short identifier for this rule, e.g. `bitwarden`. Will be stored as `name = pop-<name>` in the generated config.
2. **class** — the window class regex, e.g. `chrome-.*-Default`. Accept as-is — do not escape or modify.
3. **title** — the window title (optional). If the class looks broad or generic (matches many apps), strongly recommend providing a title to narrow the match. If the user skips it, omit `title` from the YAML entry.
4. **size** — two integers for width and height, e.g. `450 700`. Default: `1300 900`.
5. **position** — `center` (default) or specific `x y` integer coordinates, e.g. `100 200`.

**Step 3 — Write to user YAML**

Read `~/.config/hypr/pop-windows.yaml`. If the file does not exist, treat it as an empty list.

Check if an entry with the same `name` already exists:
- **If it exists**: update that entry in-place with the new values.
- **If it does not exist**: append a new entry.

Write the updated YAML back to `~/.config/hypr/pop-windows.yaml`. Format:
```yaml
- name: <name>
  class: <class>
  title: <title>        # omit this line if no title was provided
  size: <w> <h>
  position: <center|x y>
```

**Step 4 — Apply**

Run:
```
hypr-pop-windows-gen
```

This regenerates `~/.config/hypr/pop-windows.conf` from the merged distro + user YAML and reloads Hyprland if it is running.

**Step 5 — Confirm**

Tell the user:
- Exactly what YAML entry was written (or updated), with the full block
- That changes are now live (Hyprland was reloaded)
- The file path: `~/.config/hypr/pop-windows.yaml`
