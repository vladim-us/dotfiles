local M = {}

---@param fontFamily 'jetbrains' | 'fira' |  'geist'
M.getFonts = function(fontFamily)
	local families = {
		jetbrains = {
			family = "JetBrainsMono Nerd Font",
			weight = "Regular",
			italic = false,
			stretch = "Normal",
		},
		fira = {
			family = "FiraCode Nerd Font",
			weight = "Regular",
			italic = false,
			stretch = "Normal",
		},
		geist = {
			family = "GeistMono Nerd Font",
			weight = 400,
			italic = false,
			stretch = "Normal",
		},
	}

	local fonts = {}
	table.insert(fonts, 1, families[fontFamily])

	-- Fallback fonts
	for family, font in pairs(families) do
		if family ~= fontFamily then
			table.insert(fonts, font)
		end
	end
	-- apple does its own thing
	table.insert(fonts, { family = "Apple Color Emoji" })
	return fonts
end

return M
