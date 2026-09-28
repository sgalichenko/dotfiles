-- Rounded borders around every pane, not only between them
require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

-- Git status signs in the file list (fetchers registered in yazi.toml)
require("git"):setup {
	order = 1500,
}

-- The owner of the hovered file in the status bar, next to its permissions
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("#81A1C1"),
		ui.Span(":"):fg("#4C566A"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("#81A1C1"),
		" ",
	}
end, 500, Status.RIGHT)
