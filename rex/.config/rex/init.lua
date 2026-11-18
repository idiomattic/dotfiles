-- Layers mirror AeroSpace, which owns alt and alt+shift:
--   alt       = windows (AeroSpace)
--   ctrl+alt  = panes
--   alt+cmd   = tabs
-- Within a layer, h/j/k/l picks a direction and shift moves instead of focusing.

local directions = {
  h = "left", j = "down", k = "up", l = "right",
  left = "left", down = "down", up = "up", right = "right",
}

-- Panes
for key, direction in pairs(directions) do
  rex.bind("ctrl+alt+" .. key, "pane.focus", { direction = direction })
  rex.bind("shift+ctrl+alt+" .. key, "pane.move", { direction = direction })
end
rex.bind("ctrl+alt+n", "pane.split", { direction = "auto" })
-- Tabs: the sidebar is vertical, so j/k and up/down follow it.
local tab_steps = {
  k = "previous", up = "previous", left = "previous",
  j = "next", down = "next", right = "next",
}
local tab_moves = { previous = "backward", next = "forward" }
for key, step in pairs(tab_steps) do
  rex.bind("alt+cmd+" .. key, "client.tab." .. step)
  rex.bind("shift+alt+cmd+" .. key, "client.tab.move", { direction = tab_moves[step] })
end
for index = 1, 9 do
  rex.bind("cmd+" .. index, "client.tab.goto", { index = index })
end
