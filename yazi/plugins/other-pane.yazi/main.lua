--- @sync entry
-- vifm-style dual pane on top of tabs: the "other pane" is the next tab.
--   switch  go to the other tab, opening one in the CWD if there is only one
--   copy    copy the selection (or hovered file) into the other tab's CWD
--   move    same, but move

local function entry(_, job)
	local act = job.args[1]
	local single = #cx.tabs < 2

	if act == "switch" then
		if single then
			ya.emit("tab_create", { current = true })
		else
			ya.emit("tab_switch", { 1, relative = true })
		end
		return
	end

	if single then
		return ya.notify { title = "other-pane", content = "Open a second tab first (Tab)", timeout = 3, level = "warn" }
	end

	ya.emit("yank", { cut = act == "move" })
	ya.emit("tab_switch", { 1, relative = true })
	ya.emit("paste", {})
	ya.emit("tab_switch", { -1, relative = true })
	if act == "copy" then
		ya.emit("unyank", {})
	end
	ya.emit("escape", { select = true })
end

return { entry = entry }
