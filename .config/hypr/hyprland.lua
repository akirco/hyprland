-- Source: /home/neil/.config/hypr/hyprland.conf
-- Some values might need MANUAL check. PLEASE DO BACKUP BEFORE TESTING, PLEASEEEE.
-- Env vars
hl.env("WLR_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")
hl.env("XCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-sky-cursors")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Gesture
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Monitors
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("~/.config/hypr/xdg-portal-hyprland")
	hl.exec_cmd("waybar")
	hl.exec_cmd("mako")
	hl.exec_cmd('awww-daemon && awww img awww img --resize="fit"  $(find ~/Pictures/wallpapers -type f | shuf -n 1)')
	hl.exec_cmd("fcitx5 --replace -d")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("systemctl --user restart pipewire")
end)

-- General Config
hl.config({
	input = {
		touchpad = {
			natural_scroll = true,
		},
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		enable_swallow = true,
	},
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 0,
		allow_tearing = true,
		layout = "scrolling",
	},
	master = {
		new_on_top = true,
		new_status = "slave",
	},
	dwindle = {
		preserve_split = true,
	},
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.8,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.3,
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		direction = "right",
	},
	decoration = {
		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			new_optimizations = true,
			xray = false,
			size = 3,
			passes = 1,
			ignore_opacity = true,
			input_methods = true,
			vibrancy = 0.17,
		},
		rounding = 28,
		active_opacity = 0.9,
		inactive_opacity = 0.95,
		fullscreen_opacity = 0.93,
		dim_around = 0.6,
		dim_inactive = true,
		dim_strength = 0.1,
	},
})

hl.layer_rule({
	match = { namespace = "logout_dialog" },
	blur = true,
})

hl.layer_rule({
	match = { namespace = "wofi" },
	blur = true,
	dim_around = true,
	no_anim = true,
})

hl.layer_rule({
	match = { namespace = "notifications" },
	blur = true,
	ignore_alpha = 0.8, -- 数值直接写死为浮点数，不需要加双引号
})

-- Windowrules
hl.window_rule({
	name = "pigma",
	match = {
		title = "^(pigma)$",
	},
	workspace = "3",
	idle_inhibit = "focus",
})
hl.window_rule({
	name = "workspace-apps",
	match = {
		class = "^(deepseek)$",
	},
	workspace = "4",
	idle_inhibit = "focus",
})
hl.window_rule({
	name = "workspace-apps",
	match = {
		class = "^(mihomoui)$",
	},
	workspace = "5",
	idle_inhibit = "focus",
})
hl.window_rule({
	name = "telegram",
	match = {
		class = "^(org.telegram.desktop)$",
	},
	workspace = "6",
	idle_inhibit = "focus",
})
hl.window_rule({
	name = "imv",
	match = {
		class = "^(imv|com.gabm.satty|mpv)$",
	},
	opacity = "1.5 1.5",
})
hl.window_rule({
	name = "wofi",
	match = {
		class = "^(wofi)$",
	},
	dim_around = true,
	animation = "popin,50%",
})
hl.window_rule({
	name = "float-center-large-title",
	match = {
		title = "^(termgpt|satty|btop|Media viewer|yazi|Open [Ff]iles|Open Folder|Open [Ff]ile|Save File|Volume Control)$",
	},
	float = true,
	size = { 1344, 810 },
	center = true,
})
hl.window_rule({
	name = "float-center-large-class",
	match = {
		class = "^(imv|yad|org.pulseaudio.pavucontrol|thunar|qt5ct|download|org.kde.polkit-kde-authentication-agent-1)$",
	},
	float = true,
	size = { 1344, 810 },
	center = true,
})
hl.window_rule({
	name = "pip-mode",
	match = {
		title = "^([Pp]icture-in-[Pp]icture)$",
	},
	float = true,
	pin = true,
	size = { 480, 270 },
	move = { 1382, 778 },
	no_shadow = true,
})

-- Keybindings
hl.bind("ALT + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + Q", hl.dsp.exec_cmd("foot"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("pkill wofi || wofi"))

-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/window_switch switch"))
-- hl.bind("ALT + TAB", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/window_switch move"))

local wm = require("lua.window_manager")
hl.bind("SUPER + SPACE", function()
	wm.run("switch")
end, { description = "Wofi Window Switcher" })
hl.bind("ALT + TAB", function()
	wm.run("move")
end, { description = "Restore Window from Minimized" })

hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/cliphist"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/cliphist -m"))
hl.bind("ALT + B", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/wallpaper"))
hl.bind("ALT + O", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/projects"))
hl.bind("ALT + W", hl.dsp.window.close())
hl.bind(
	"ALT + F",
	hl.dsp.window.float({
		action = "toggle",
	})
)
hl.bind("ALT + C", hl.dsp.exec_cmd("hyprpicker -a | cliphist store"))
hl.bind("ALT + F4", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))
hl.bind("ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode"))

-- =====================================================================
-- 动态切换滚动方向 (Left ⇄ Down)
-- =====================================================================

hl.bind("ALT + H", function()
	local current_dir = hl.get_config("scrolling:direction")

	local new_dir = "left"
	if current_dir == "left" then
		new_dir = "down"
	end

	hl.config({ scrolling = { direction = new_dir } })

	if hl.notification then
		hl.notification.create({
			text = "Changed to " .. new_dir,
			icon = "info",
			timeout = 1500,
		})
	end
end, { description = "Toggle Scrolling Direction Between Left and Down" })

hl.bind("ALT + J", hl.dsp.layout("togglesplit"))
hl.bind("ALT+ F1", hl.dsp.exec_cmd("pkill yad || ~/.config/hypr/scripts/binds --yad"))
hl.bind("ALT+ F2", hl.dsp.exec_cmd("~/.config/hypr/scripts/mihomo ui"))
hl.bind("ALT+ F3", hl.dsp.exec_cmd("~/.config/hypr/scripts/mihomo switch"))
hl.bind("ALT+ S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("/home/neil/Projects/rust/virs/target/release/alayer toggle"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("foot --title btop sh -c btop"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("foot --title yazi sh -c yazi"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("foot --title pigma sh -c pigma"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("foot --hold sh -c neofetch"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("foot sh -c cava"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("foot -H -T termgpt sh -c ~/.config/bashrc/bin/ai -i"))
hl.bind(
	"SUPER + D",
	hl.dsp.window.move({
		workspace = "special:min",
		follow = false,
	})
)

-- =====================================================================
-- 动态布局一键切换 (Dwindle ⇄ Scrolling)
-- =====================================================================

hl.bind("SUPER + S", function()
	local current_layout = hl.get_config("general:layout")
	if current_layout == "dwindle" then
		hl.config({ general = { layout = "scrolling" } })
		if hl.notification then
			hl.notification.create({ text = "Switched to Scrolling", icon = "info", timeout = 1500 })
		end
	else
		hl.config({ general = { layout = "dwindle" } })
		if hl.notification then
			hl.notification.create({ text = "Switched to Dwindle", icon = "info", timeout = 1500 })
		end
	end
end, { description = "Toggle Desktop Layout Between Dwindle and Scrolling" })

hl.bind("SUPER + L", hl.dsp.exec_cmd("swaylock"))
hl.bind(
	"SUPER + O",
	hl.dsp.window.set_prop({
		prop = "opaque",
		value = "toggle",
	})
)
hl.bind(
	"SUPER + F",
	hl.dsp.window.fullscreen({
		action = "toggle",
	})
)
hl.bind(
	"SUPER + U",
	hl.dsp.window.swap({
		next = true,
	})
)
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/pin"))
hl.bind("SUPER + Z", hl.dsp.workspace.toggle_special("min"))
-- hl.bind("SUPER + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/showkeys"))
-- -------------------------------------------------------------------------- --
--                                showkeys new                                --
-- -------------------------------------------------------------------------- --

local _showkeys_active = false

-- 核心调用系统 notify-send 发送异步通知
local function show_key_notification(key_symbol)
	hl.dispatch(
		hl.dsp.exec_cmd(
			'notify-send -a "show-keys" -t 800 -h string:x-canonical-private-synchronous:key " " "' .. key_symbol .. '"'
		)
	)
end

-- 全局一键开关控制函数
local function toggle_show_keys()
	_showkeys_active = not _showkeys_active

	-- 构造你要监控的 100% XKB 标准按键与符号数组
	local keys_to_monitor = {
		-- 控制键与特殊符号
		{ "space", "␣" },
		{ "Return", "⏎" },
		{ "BackSpace", "⌫" },
		{ "Tab", "⇥" },
		{ "Escape", "Esc" },
		{ "Caps_Lock", "⇪" },
		{ "grave", "`" },

		-- 修饰键
		{ "Shift_L", "⇧" },
		{ "Shift_R", "⇧" },
		{ "Control_L", "Ctrl" },
		{ "Control_R", "Ctrl" },
		{ "Alt_L", "Alt" },

		-- A-Z 字母表
		{ "a", "A" },
		{ "b", "B" },
		{ "c", "C" },
		{ "d", "D" },
		{ "e", "E" },
		{ "f", "F" },
		{ "g", "G" },
		{ "h", "H" },
		{ "i", "I" },
		{ "j", "J" },
		{ "k", "K" },
		{ "l", "L" },
		{ "m", "M" },
		{ "n", "N" },
		{ "o", "O" },
		{ "p", "P" },
		{ "q", "Q" },
		{ "r", "R" },
		{ "s", "S" },
		{ "t", "T" },
		{ "u", "U" },
		{ "v", "V" },
		{ "w", "W" },
		{ "x", "X" },
		{ "y", "Y" },
		{ "z", "Z" },
	}

	-- 循环正确注入主键盘和小键盘的 0-9 数字键
	for i = 0, 9 do
		local num_str = tostring(i)
		table.insert(keys_to_monitor, { num_str, num_str })
		table.insert(keys_to_monitor, { "KP_" .. num_str, num_str })
	end

	if _showkeys_active then
		-- 1. 开启通知
		hl.notification.create({ text = "已开启", icon = "info", timeout = 1000 })

		-- 2. 批量绑定事件
		for _, k in ipairs(keys_to_monitor) do
			-- 🌟 彻底修复：使用 [1] 和 [2] 索引，确保拿到纯字符串！
			local key_name = k[1] -- 比如: "space"
			local key_symbol = k[2] -- 比如: "␣"

			hl.bind(key_name, function()
				if _showkeys_active then
					show_key_notification(key_symbol)
				end
			end, { non_consuming = true })
		end
	else
		-- 3. 关闭通知
		hl.notification.create({ text = "已关闭", icon = "warning", timeout = 1000 })

		-- 4. 批量解绑事件
		for _, k in ipairs(keys_to_monitor) do
			-- 🌟 彻底修复：解绑时同样必须用 [1] 拿到纯字符串名字
			local key_name = k[1]
			if hl.unbind then
				hl.unbind(key_name)
			end
		end
	end
end

-- =====================================================================
-- 快捷键绑定（SUPER + ALT + s 启动/关闭）
-- =====================================================================
hl.bind("SUPER + K", function()
	toggle_show_keys()
end, { description = "Toggle Show Pressed Keys On Screen" })

-- -------------------------------------------------------------------------- --
--                                     end                                    --
-- -------------------------------------------------------------------------- --

hl.bind(
	"CONTROL+left",
	hl.dsp.focus({
		direction = "left",
	})
)
hl.bind(
	"CONTROL+right",
	hl.dsp.focus({
		direction = "right",
	})
)
hl.bind(
	"CONTROL+up",
	hl.dsp.focus({
		direction = "up",
	})
)
hl.bind(
	"CONTROL+down",
	hl.dsp.focus({
		direction = "down",
	})
)
hl.bind("SUPER+ comma", hl.dsp.layout("colresize -0.05"))
hl.bind("SUPER+ period", hl.dsp.layout("colresize +0.05"))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("~/.config/hypr/scripts/aichat"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/ocr_translate"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- 1. 移动活动窗口到右侧工作区
hl.bind("SUPER+SHIFT+Right", hl.dsp.window.move({ workspace = "r+1" }), {
	description = "Move to Right Workspace",
})

-- 2. 移动活动窗口到左侧工作区
hl.bind("SUPER+SHIFT+ Left", hl.dsp.window.move({ workspace = "r-1" }), {
	description = "Move to Left Workspace",
})

-- 3. 移动活动窗口到一个全新的空工作区
hl.bind("SUPER+SHIFT+Down", hl.dsp.window.move({ workspace = "empty" }), {
	description = "Move to New",
})

-- -------------------------------------------------------------------------- --
--                                    智能工作区                                   --
-- -------------------------------------------------------------------------- --

-- =====================================================================
-- 1. 状态追踪变量（不要删除此行，用于记录 Up/Down 的历史位置）
-- =====================================================================
local _hypr_prev_ws = nil

-- =====================================================================
-- 2. 智能向右工作区导航
-- =====================================================================
hl.bind("SUPER + Right", function()
	local cur_id = hl.get_active_workspace().id
	local workspaces = hl.get_workspaces()
	table.sort(workspaces, function(a, b)
		return a.id < b.id
	end)
	local target_id = nil
	for _, ws in ipairs(workspaces) do
		if ws.id > cur_id then
			target_id = ws.id
			break
		end
	end
	if target_id then
		hl.dispatch(hl.dsp.focus({ workspace = target_id }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "r+1" }))
	end
end, { description = "Smart Next Workspace" })

-- =====================================================================
-- 3. 智能向左工作区导航
-- =====================================================================
hl.bind("SUPER + Left", function()
	local cur_id = hl.get_active_workspace().id
	local workspaces = hl.get_workspaces()
	table.sort(workspaces, function(a, b)
		return a.id < b.id
	end)
	local target_id = nil
	for i = #workspaces, 1, -1 do
		if workspaces[i].id < cur_id then
			target_id = workspaces[i].id
			break
		end
	end
	if target_id and target_id > 0 then
		hl.dispatch(hl.dsp.focus({ workspace = target_id }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "r-1" }))
	end
end, { description = "Smart Previous Workspace" })

-- =====================================================================
-- 4. 垂直交互：去空工作区与返回上一级（已完美修正 animation 和 timer 语法）
-- =====================================================================
-- 内部垂直动画切换通用函数
local function switch_vertical(target_ws)
	-- 修正1：必须明确传入 bezier = "default"，且样式采用 slidevert
	hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slidevert" })

	hl.dispatch(hl.dsp.focus({ workspace = target_ws }))

	-- 修正2：hl.timer 的第一个参数必须是函数主体，第二个参数才是配置表
	hl.timer(function()
		-- 0.5秒时间到，将工作区切回默认的左右滑 (style = "slide")
		hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slide" })
	end, { timeout = 500, type = "oneshot" })
end

-- SUPER + SHIFT + Down：垂直降落到全新空工作区
hl.bind("SUPER + SHIFT + Down", function()
	_hypr_prev_ws = hl.get_active_workspace().id
	switch_vertical("empty")
end, { description = "Move to New" })

-- SUPER + SHIFT + Up：垂直返回上一次记录的工作区
hl.bind("SUPER + SHIFT + Up", function()
	if _hypr_prev_ws and _hypr_prev_ws ~= hl.get_active_workspace().id then
		switch_vertical(_hypr_prev_ws)
	end
end, { description = "Back to Previous Workspace" })

-- -------------------------------------------------------------------------- --
--                                     end                                    --
-- -------------------------------------------------------------------------- --

-- =====================================================================
-- SUPER + 鼠标左键：拖拽移动窗口 (完美对齐旧版 movewindow)
-- =====================================================================
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {
	mouse = true,
	description = "Move Window",
})

-- =====================================================================
-- SUPER + 鼠标右键：拖拽缩放窗口 (完美对齐旧版 resizewindow)
-- =====================================================================
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {
	mouse = true,
	description = "Resize Window",
})

-- =====================================================================
-- 键盘像素级精细缩放活动窗口
-- =====================================================================

-- 1. 向左收缩/扩展宽度 (x = -70)
hl.bind("CONTROL + SHIFT + left", hl.dsp.window.resize({ x = -70, y = 0, relative = true }), {
	repeating = true,
	description = "Resize Window Left",
})

-- 2. 向右扩展/收缩宽度 (x = 70)
hl.bind("CONTROL + SHIFT + right", hl.dsp.window.resize({ x = 70, y = 0, relative = true }), {
	repeating = true,
	description = "Resize Window Right",
})

-- 3. 向上收缩/扩展高度 (y = -50)
hl.bind("CONTROL + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), {
	repeating = true,
	description = "Resize Window Up",
})

-- 4. 向下扩展/收缩高度 (y = 50)
hl.bind("CONTROL + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), {
	repeating = true,
	description = "Resize Window Down",
})

-- ------------------------------ opacity start ----------------------------- --
-- =====================================================================
-- 窗口与 Waybar 协同透明度调节逻辑 (纯 Lua 版 - 彻底修复覆盖不生效 Bug)
-- =====================================================================

local WAYBAR_CSS = os.getenv("HOME") .. "/.config/waybar/style.css"
local STEP = 0.1

-- 核心通用调整函数
local function adjust_opacity(direction)
	-- 1. 获取当前激活窗口
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end

	-- 获取该窗口当前的透明度属性 (如果没有覆盖则默认为 1.0)
	local cur_alpha = active_window.opacity or 1.0
	local new_alpha = cur_alpha

	-- 2. 读取并解析 Waybar 当前的透明度
	local waybar_alpha = 0.9
	local f_read = io.open(WAYBAR_CSS, "r")
	local css_content = ""
	if f_read then
		css_content = f_read:read("*all")
		f_read:close()
		-- 正则匹配 rgba 中的不透明度数值
		local matched =
			string.match(css_content, "@define%-color waybar%-bg rgba%([0-9 ]+,[0-9 ]+,[0-9 ]+,%s*([0-9.]+)%)")
		if matched then
			waybar_alpha = tonumber(matched) or 0.9
		end
	end
	local new_waybar_alpha = waybar_alpha

	-- 3. 根据方向增减计算并执行边界限制
	if direction == "up" then
		if cur_alpha >= 1.0 then
			if hl.notification then
				hl.notification.create({
					text = string.format("Opacity is already at maximum: %.1f", cur_alpha),
					icon = "warning",
					timeout = 2000,
				})
			end
			return
		end
		new_alpha = math.min(1.0, cur_alpha + STEP)
		new_waybar_alpha = math.min(1.0, waybar_alpha + STEP)
	elseif direction == "down" then
		if cur_alpha <= 0.1 then
			if hl.notification then
				hl.notification.create({
					text = string.format("Opacity is already at minimum: %.1f", cur_alpha),
					icon = "warning",
					timeout = 2000,
				})
			end
			return
		end
		new_alpha = math.max(0.1, cur_alpha - STEP)
		new_waybar_alpha = math.max(0.1, waybar_alpha - STEP)
	end

	-- 4. 🌟 终极修复：新版强制覆盖必须直接拼入 " override" 关键字
	-- 这样底层才会被告知强制无视全局变量，改为绝对应用当前数值
	local opacity_value_string = string.format("%.1f override", new_alpha)
	hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity", value = opacity_value_string }))

	-- 5. 使用 Lua 内置正则秒级覆写 Waybar 样式表
	if css_content ~= "" then
		local target_pattern = "@define%-color waybar%-bg rgba%(14,%s*16,%s*17,%s*[0-9.]*%)"
		local replacement = string.format("@define-color waybar-bg rgba(14, 16, 17, %.1f)", new_waybar_alpha)
		local updated_css, count = string.gsub(css_content, target_pattern, replacement)

		if count > 0 then
			local f_write = io.open(WAYBAR_CSS, "w")
			if f_write then
				f_write:write(updated_css)
				f_write:close()
			end
		end
	end

	-- 6. 弹出调节成功的内置系统通知
	if hl.notification then
		hl.notification.create({
			text = string.format("Opacity: %.1f (waybar: %.1f)", new_alpha, new_waybar_alpha),
			icon = "info",
			timeout = 2000,
		})
	end
end

-- =====================================================================
-- 快捷键绑定（直接写死包含 + 号的完整格式）
-- =====================================================================

-- SUPER + CONTROL + 向上方向键：调高透明度
hl.bind("SUPER + CONTROL + up", function()
	adjust_opacity("up")
end, {
	repeating = true,
	description = "Increase Active Window and Waybar Opacity",
})

-- SUPER + CONTROL + 向下方向键：调低透明度
hl.bind("SUPER + CONTROL + down", function()
	adjust_opacity("down")
end, {
	repeating = true,
	description = "Decrease Active Window and Waybar Opacity",
})

-- -------------------------------------------------------------------------- --
--                                  透明度切换end                                  --
-- -------------------------------------------------------------------------- --

-- SUPER + CONTROL + 向上方向键：调高透明度
hl.bind("SUPER + CONTROL + up", function()
	adjust_opacity("up")
end, {
	repeating = true,
	description = "Increase Active Window and Waybar Opacity",
})

-- SUPER + CONTROL + 向下方向键：调低透明度
hl.bind("SUPER + CONTROL + down", function()
	adjust_opacity("down")
end, {
	repeating = true,
	description = "Decrease Active Window and Waybar Opacity",
})

-- ----------------------------------- end ---------------------------------- --
-- =====================================================================
-- 屏幕缩放/放大控制
-- =====================================================================
-- 按下 SUPER + equal：画面放大至 2x
hl.bind("SUPER + equal", function()
	hl.config({ cursor = { zoom_factor = 2.0 } })
end, { description = "Zoom Factor 2x" })

-- 松开 SUPER + equal：恢复 1x 缩放 (对应旧版 binddr)
hl.bind("SUPER + equal", function()
	hl.config({ cursor = { zoom_factor = 1.0 } })
end, { release = true, description = "Zoom Factor Reset" })

-- =====================================================================
-- 退出/关机生命周期拦截器
-- =====================================================================
hl.on("hyprland.shutdown", function()
	hl.dispatch(hl.dsp.exec_cmd("pkill mihomo"))

	hl.dispatch(hl.dsp.exec_cmd("pkill greetd"))
end)
