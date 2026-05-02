if getgenv().loaded then
	getgenv().library:unload_menu()
end
getgenv().loaded = true

-- services
local uis = cloneref(game:GetService("UserInputService"))
local players = cloneref(game:GetService("Players"))
local ws = cloneref(game:GetService("Workspace"))
local rs = cloneref(game:GetService("ReplicatedStorage"))
local http_service = cloneref(game:GetService("HttpService"))
local gui_service = cloneref(game:GetService("GuiService"))
local lighting = cloneref(game:GetService("Lighting"))
local run = cloneref(game:GetService("RunService"))
local stats = cloneref(game:GetService("Stats"))
local coregui = cloneref(game:GetService("CoreGui"))
local debris = cloneref(game:GetService("Debris"))
local tween_service = cloneref(game:GetService("TweenService"))
local sound_service = cloneref(game:GetService("SoundService"))

-- shorthand
local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max
local floor = math.floor
local min = math.min
local abs = math.abs
local noise = math.noise
local rad = math.rad
local random = math.random
local pow = math.pow
local sin = math.sin
local pi = math.pi
local tan = math.tan
local atan2 = math.atan2
local clamp = math.clamp

local insert = table.insert
local find = table.find
local remove = table.remove
local concat = table.concat

-- library init
getgenv().library = {
	directory = "fecurity",
	folders = {
		"/fonts",
		"/configs",
	},
	flags = {},
	config_flags = {},
	connections = {},
	notifications = { notifs = {}, offset = 0 },
	playerlist_data = {
		players = {},
		player = {},
	},
	colorpicker_open = false,
	gui,
}

local themes = {
	preset = {
		accent = rgb(211, 123, 167),
		text = rgb(255, 255, 255),
		text_outline = rgb(0, 0, 0),
	},
	utility = {
		accent = {
			BackgroundColor3 = {},
			TextColor3 = {},
			ImageColor3 = {},
			ScrollBarImageColor3 = {},
		},
		text = {
			TextColor3 = {},
		},
		text_outline = {
			Color = {},
		},
	},
}

local keys = {
	[Enum.KeyCode.LeftShift] = "LS",
	[Enum.KeyCode.RightShift] = "RS",
	[Enum.KeyCode.LeftControl] = "LC",
	[Enum.KeyCode.RightControl] = "RC",
	[Enum.KeyCode.Insert] = "INS",
	[Enum.KeyCode.Backspace] = "BS",
	[Enum.KeyCode.Return] = "Ent",
	[Enum.KeyCode.LeftAlt] = "LA",
	[Enum.KeyCode.RightAlt] = "RA",
	[Enum.KeyCode.CapsLock] = "CAPS",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.KeypadOne] = "Num1",
	[Enum.KeyCode.KeypadTwo] = "Num2",
	[Enum.KeyCode.KeypadThree] = "Num3",
	[Enum.KeyCode.KeypadFour] = "Num4",
	[Enum.KeyCode.KeypadFive] = "Num5",
	[Enum.KeyCode.KeypadSix] = "Num6",
	[Enum.KeyCode.KeypadSeven] = "Num7",
	[Enum.KeyCode.KeypadEight] = "Num8",
	[Enum.KeyCode.KeypadNine] = "Num9",
	[Enum.KeyCode.KeypadZero] = "Num0",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.Semicolon] = ",",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Slash] = "/",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3",
	[Enum.KeyCode.Escape] = "ESC",
	[Enum.KeyCode.Space] = "SPC",
}

library.__index = library

for _, path in next, library.folders do
	makefolder(library.directory .. path)
end

local flags = library.flags
local config_flags = library.config_flags

local fonts = {}
do
	function Register_Font(Name, Weight, Style, Asset)
		if not isfile(Asset.Id) then
			writefile(Asset.Id, Asset.Font)
		end

		if isfile(Name .. ".font") then
			delfile(Name .. ".font")
		end

		local Data = {
			name = Name,
			faces = {
				{
					name = "Normal",
					weight = Weight,
					style = Style,
					assetId = getcustomasset(Asset.Id),
				},
			},
		}

		writefile(Name .. ".font", http_service:JSONEncode(Data))

		return getcustomasset(Name .. ".font")
	end

	local ProggyTiny = Register_Font("adwdawdwadadwadawdawdawdawd!", 100, "Normal", {
		Id = "ProggyTinyyyy.ttf",
		Font = game:HttpGet("https://files.catbox.moe/94ooyr.ttf"),
	})

	fonts = {
		main = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	}
end

-- library functions
function library:tween(obj, properties)
	return tween_service:Create(
		obj,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0),
		properties
	):Play()
end

function library:next_flag()
	local idx = #self.flags + 1
	return string.format("flag_%s", idx)
end

function library:resizify(frame)
	local Frame = Instance.new("TextButton")
	Frame.Position = dim2(1, -10, 1, -10)
	Frame.BorderColor3 = rgb(0, 0, 0)
	Frame.Size = dim2(0, 10, 0, 10)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = rgb(255, 255, 255)
	Frame.Parent = frame
	Frame.BackgroundTransparency = 1
	Frame.Text = ""

	local resizing = false
	local start_size
	local start
	local og_size = frame.Size

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			start = input.Position
			start_size = frame.Size
		end
	end)

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)

	library:connection(uis.InputChanged, function(input, game_event)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local viewport_x = camera.ViewportSize.X
			local viewport_y = camera.ViewportSize.Y

			local current_size = dim2(
				start_size.X.Scale,
				math.clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, viewport_x),
				start_size.Y.Scale,
				math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, viewport_y)
			)
			frame.Size = current_size
		end
	end)
end

function library:mouse_in_frame(uiobject)
	local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y
		and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
	local x_cond = uiobject.AbsolutePosition.X <= mouse.X
		and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

	return (y_cond and x_cond)
end

function library:draggify(frame)
	local dragging = false
	local start_size = frame.Position
	local start

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = input.Position
			start_size = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	library:connection(uis.InputChanged, function(input, game_event)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local viewport_x = camera.ViewportSize.X
			local viewport_y = camera.ViewportSize.Y

			local current_position = dim2(
				0,
				clamp(start_size.X.Offset + (input.Position.X - start.X), 0, viewport_x - frame.Size.X.Offset),
				0,
				math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), 0, viewport_y - frame.Size.Y.Offset)
			)

			frame.Position = current_position
		end
	end)
end

function library:convert(str)
	local values = {}
	for value in string.gmatch(str, "[^,]+") do
		insert(values, tonumber(value))
	end
	if #values == 4 then
		return unpack(values)
	else
		return
	end
end

function library:convert_enum(enum)
	local enum_parts = {}
	for part in string.gmatch(enum, "[%w_]+") do
		insert(enum_parts, part)
		local enum_table = Enum
		for i = 2, #enum_parts do
			local enum_item = enum_table[enum_parts[i]]
			enum_table = enum_item
		end
		return enum_table
	end
end

local config_holder
local cfg_name

function library:update_config_list()
	if not config_holder then
		return
	end

	local list = {}
	for idx, file in next, listfiles(library.directory .. "/configs") do
		local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
		list[#list + 1] = name
	end
	config_holder.refresh_options(list)
end

function library:get_config()
	local Config = {}
	for _, v in next, flags do
		if type(v) == "table" and v.key then
			Config[_] = { active = v.active, mode = v.mode, key = tostring(v.key) }
		elseif type(v) == "table" and v["Transparency"] and v["Color"] then
			Config[_] = { Transparency = v["Transparency"], Color = v["Color"]:ToHex() }
		else
			Config[_] = v
		end
	end
	return http_service:JSONEncode(Config)
end

function library:load_config(config_json)
	local config = http_service:JSONDecode(config_json)
	for _, v in next, config do
		local function_set = library.config_flags[_]
		if _ == "config_name_list" then
			continue
		end
		if function_set then
			if type(v) == "table" and v["Transparency"] and v["Color"] then
				function_set(hex(v["Color"]), v["Transparency"])
			elseif type(v) == "table" and v["active"] then
				function_set(v)
			else
				function_set(v)
			end
		end
	end
end

function library:round(number, float)
	local multiplier = 1 / (float or 1)
	return floor(number * multiplier + 0.5) / multiplier
end

function library:apply_theme(instance, theme, property)
	insert(themes.utility[theme][property], instance)
end

function library:update_theme(theme, color)
	for _, property in themes.utility[theme] do
		for m, object in property do
			if object[_] == themes.preset[theme] then
				object[_] = color
			end
		end
	end
	themes.preset[theme] = color
end

function library:connection(signal, callback)
	local connection = signal:Connect(callback)
	insert(library.connections, connection)
	return connection
end

function library:apply_stroke(parent)
	local STROKE = library:create("UIStroke", {
		Parent = parent,
		Color = themes.preset.text_outline,
		LineJoinMode = Enum.LineJoinMode.Miter,
	})
	library:apply_theme(STROKE, "text_outline", "Color")
end

function library:create(instance, options)
	local ins = Instance.new(instance)
	for prop, value in options do
		ins[prop] = value
	end
	if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then
		library:apply_theme(ins, "text", "TextColor3")
	end
	return ins
end

function library:unload_menu()
	if library["items"] then
		library["items"]:Destroy()
	end
	if library["other"] then
		library["other"]:Destroy()
	end
	for index, connection in library.connections do
		connection:Disconnect()
		connection = nil
	end
	library = nil
end

function library:change_fontsize(int)
	for _, property in themes.utility.text do
		for m, object in property do
			object.TextSize = int
		end
	end
end

-- window
function library:window(properties)
	local cfg = {
		name = properties.name or properties.Name or "menu",
		size = properties.size or properties.Size or dim2(0, 752, 0, 502),
		selected_tab,
		items = {},
	}

	library["items"] = library:create("ScreenGui", {
		Parent = coregui,
		Name = "\0",
		Enabled = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})

	library["other"] = library:create("ScreenGui", {
		Parent = coregui,
		Name = "\0",
		Enabled = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})

	local items = cfg.items

	-- main frame
	items["main"] = library:create("Frame", {
		Parent = library["items"],
		Name = "\0",
		Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
		BorderColor3 = rgb(0, 0, 0),
		Size = cfg.size,
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})
	items["main"].Position = dim2(0, items["main"].AbsolutePosition.X, 0, items["main"].AbsolutePosition.Y)

	-- tab sidebar
	items["tab_element_holder"] = library:create("Frame", {
		Name = "\0",
		Parent = items["main"],
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 82, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	items["tab_buttons"] = library:create("Frame", {
		Parent = items["tab_element_holder"],
		Name = "\0",
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	items["tab_holder"] = library:create("Frame", {
		Parent = items["tab_buttons"],
		Name = "\0",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 1, 0),
		Position = dim2(0, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UIListLayout", {
		Parent = items["tab_holder"],
		Padding = dim(0, 15),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	library:create("UIPadding", {
		Parent = items["tab_holder"],
		PaddingTop = dim(0, 10),
	})

	-- dragging & resizing
	library:draggify(items["main"])
	library:resizify(items["main"])

	-- keybind list frame
	cfg.keybind_list = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = library["other"],
		BackgroundTransparency = 1,
		Position = dim2(0, 100, 0, 600),
		Size = dim2(0, 202, 0, 66),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(255, 255, 255),
	})
	library:resizify(cfg.keybind_list)
	library:draggify(cfg.keybind_list)

	library:create("UIStroke", {
		Parent = cfg.keybind_list,
		LineJoinMode = Enum.LineJoinMode.Miter,
		Transparency = 1,
	})

	local inline1 = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = cfg.keybind_list,
		BackgroundTransparency = 1,
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(56, 56, 56),
	})

	library:create("UIStroke", {
		Color = rgb(56, 56, 56),
		LineJoinMode = Enum.LineJoinMode.Miter,
		Parent = inline1,
		Transparency = 1,
	})

	local inline2 = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = inline1,
		BackgroundTransparency = 1,
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(46, 46, 46),
	})

	library:create("UIStroke", {
		Color = rgb(46, 46, 46),
		LineJoinMode = Enum.LineJoinMode.Miter,
		Parent = inline2,
		Transparency = 1,
	})

	local inline3 = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = inline2,
		BackgroundTransparency = 1,
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(46, 46, 46),
	})

	library:create("UIStroke", {
		Color = rgb(46, 46, 46),
		LineJoinMode = Enum.LineJoinMode.Miter,
		Parent = inline3,
		Transparency = 1,
	})

	local inline4 = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = inline3,
		BackgroundTransparency = 1,
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(46, 46, 46),
	})

	library:create("UIStroke", {
		Color = rgb(56, 56, 56),
		LineJoinMode = Enum.LineJoinMode.Miter,
		Parent = inline4,
		Transparency = 1,
	})

	local inline5 = library:create("Frame", {
		Parent = inline4,
		BackgroundTransparency = 1,
		Size = dim2(1, 0, 1, 0),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(0, 0, 0),
	})

	local tab_holder = library:create("Frame", {
		Parent = inline5,
		BackgroundTransparency = 1,
		Position = dim2(0, 17, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 28),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Parent = tab_holder,
		Padding = dim(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalFlex = Enum.UIFlexAlignment.Fill,
	})

	local button = library:create("TextButton", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = "keybinds",
		Parent = tab_holder,
		TextStrokeTransparency = 0,
		BackgroundTransparency = 1,
		Size = dim2(0, 200, 0, 50),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	local accent = library:create("Frame", {
		AnchorPoint = vec2(0, 1),
		Parent = button,
		Position = dim2(0, 0, 1, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 4),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})
	library:apply_theme(accent, "accent", "BackgroundColor3")

	local split = library:create("Frame", {
		AnchorPoint = vec2(0, 1),
		Parent = accent,
		Position = dim2(0, 0, 1, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})
	library:apply_theme(split, "accent", "BackgroundColor3")

	library:create("UIGradient", {
		Color = rgbseq({ rgbkey(0, rgb(167, 167, 167)), rgbkey(1, rgb(167, 167, 167)) }),
		Parent = split,
	})

	local inline6 = library:create("Frame", {
		Parent = inline5,
		Size = dim2(1, -34, 0, 0),
		BackgroundTransparency = 1,
		Position = dim2(0, 17, 0, 31),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(0, 0, 0),
	})

	local inline7 = library:create("Frame", {
		Parent = inline6,
		Size = dim2(1, -2, 1, -2),
		Position = dim2(0, 1, 0, 1),
		BackgroundTransparency = 1,
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = rgb(46, 46, 46),
	})

	local inline8 = library:create("Frame", {
		Parent = inline7,
		Size = dim2(1, -2, 1, -2),
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BackgroundColor3 = rgb(21, 21, 21),
	})
	library.keybind_list = inline8

	library:create("UIListLayout", {
		Parent = inline8,
		Padding = dim(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	library:create("UIPadding", {
		PaddingTop = dim(0, 8),
		PaddingBottom = dim(0, 8),
		Parent = inline8,
		PaddingRight = dim(0, 2),
		PaddingLeft = dim(0, 8),
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = inline7,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = inline6,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 10),
		PaddingRight = dim(0, 34),
		Parent = inline5,
	})

	library:create("UIPadding", {
		Parent = inline4,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = inline3,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = inline2,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = inline1,
	})

	library:create("UIPadding", {
		PaddingBottom = dim(0, 2),
		PaddingRight = dim(0, 2),
		Parent = cfg.keybind_list,
	})

	-- playerlist frame
	items["outline"] = library:create("Frame", {
		Parent = library["other"],
		Name = "\0",
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0.1417543888092041, 0, 0.3601022958755493, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})
	cfg.mod_list = items["outline"]

	library:draggify(items["outline"])
	library:resizify(items["outline"])
	items["outline"].Position = dim2(
		0,
		items["main"].AbsoluteSize.X + items["main"].AbsolutePosition.X + 5,
		0,
		items["main"].AbsolutePosition.Y + 58
	)

	items["inline"] = library:create("Frame", {
		Parent = items["outline"],
		Name = "\0",
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		Text = "MODERATOR LIST",
		Parent = items["inline"],
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(1, 0, 0, 11),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = dim2(0, 15, 0, 15),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["scrolling"] = library:create("ScrollingFrame", {
		ScrollBarImageColor3 = rgb(132, 135, 250),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		Parent = items["inline"],
		Name = "\0",
		Size = dim2(1, 0, 1, -23),
		BackgroundColor3 = rgb(255, 255, 255),
		BackgroundTransparency = 1,
		Position = dim2(0, 0, 0, 23),
		ScrollingEnabled = false,
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = dim2(0, 0, 0, 0),
	})

	library:create("UIPadding", {
		Parent = items["scrolling"],
		PaddingTop = dim(0, 18),
		PaddingRight = dim(0, 15),
		PaddingLeft = dim(0, 15),
	})

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = items["scrolling"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, -31, 1, -10),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["playerlist_holder"] = library:create("Frame", {
		Parent = items["object"],
		BackgroundTransparency = 1,
		Name = "\0",
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 1, -23),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["ScrollingFrame"] = library:create("ScrollingFrame", {
		ScrollBarImageColor3 = rgb(132, 135, 250),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		Parent = items["playerlist_holder"],
		Size = dim2(1, 0, 1, -20),
		BackgroundTransparency = 1,
		Position = dim2(0, 0, 0, 10),
		BackgroundColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = dim2(0, 0, 0, 0),
	})

	library:create("UIPadding", {
		PaddingTop = dim(0, 10),
		PaddingBottom = dim(0, 10),
		Parent = items["ScrollingFrame"],
		PaddingRight = dim(0, 10),
		PaddingLeft = dim(0, 10),
	})

	library:create("UIListLayout", {
		Parent = items["ScrollingFrame"],
		Padding = dim(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	library:create("UIStroke", {
		Color = rgb(18, 18, 20),
		Parent = items["playerlist_holder"],
	})

	function cfg.add_mod(name)
		library:create("TextLabel", {
			TextWrapped = true,
			Name = name,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = name,
			Parent = items["ScrollingFrame"],
			TextStrokeTransparency = 0,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = dim2(0, 20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = fonts.main,
			TextSize = 9,
			BackgroundColor3 = rgb(255, 255, 255),
		})
	end

	function cfg.remove_mod(name)
		if items["ScrollingFrame"][name] then
			items["ScrollingFrame"][name]:Destroy()
		end
	end

	return setmetatable(cfg, library)
end

-- tab
function library:tab(properties)
	local cfg = {
		name = properties.name or "tab",
		items = {},
		icon = properties.icon or "rbxassetid://139765537381996",
	}

	local items = cfg.items

	items["button"] = library:create("TextButton", {
		Parent = self.items["tab_holder"],
		Name = "\0",
		BackgroundTransparency = 1,
		Position = dim2(0, -1, 0, 0),
		Text = "",
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 66),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(27, 27, 27),
	})

	items["logo"] = library:create("ImageLabel", {
		ImageColor3 = rgb(69, 69, 71),
		BorderColor3 = rgb(0, 0, 0),
		Parent = items["button"],
		AnchorPoint = vec2(0.5, 0.5),
		Image = cfg.icon,
		BackgroundTransparency = 1,
		Position = dim2(0.5, 0, 0.5, -10),
		Name = "\0",
		Size = dim2(0, 32, 0, 32),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})
	library:apply_theme(items["logo"], "accent", "ImageColor3")

	items["text"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(69, 69, 71),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0,
		Parent = items["button"],
		Name = "\0",
		BackgroundTransparency = 1,
		Position = dim2(0, 0, 0, 19),
		Size = dim2(1, 0, 1, 0),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})
	library:apply_theme(items["text"], "accent", "TextColor3")

	items["tab"] = library:create("Frame", {
		Parent = self.items["main"],
		Name = "\0",
		Visible = false,
		BackgroundTransparency = 1,
		Position = dim2(0, 80, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -80, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UIPadding", {
		PaddingTop = dim(0, 14),
		PaddingBottom = dim(0, 14),
		Parent = items["tab"],
		PaddingRight = dim(0, 14),
		PaddingLeft = dim(0, 14),
	})

	library:create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Parent = items["tab"],
		Padding = dim(0, 14),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalFlex = Enum.UIFlexAlignment.Fill,
	})

	for _, side in { "left", "middle", "right" } do
		items[side .. "_column"] = library:create("Frame", {
			Parent = items["tab"],
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(18, 18, 20),
		})
	end

	function cfg.open_tab()
		local selected_tab = self.selected_tab

		if selected_tab then
			selected_tab[1].ImageColor3 = rgb(69, 69, 71)
			selected_tab[2].TextColor3 = rgb(69, 69, 71)
			selected_tab[3].Visible = false
		end

		items["logo"].ImageColor3 = themes.preset.accent
		items["text"].TextColor3 = themes.preset.accent
		items["tab"].Visible = true

		self.selected_tab = {
			items["logo"],
			items["text"],
			items["tab"],
		}
	end

	items["button"].MouseButton1Down:Connect(function()
		cfg.open_tab()
	end)

	if not self.selected_tab then
		cfg.open_tab(true)
	end

	return setmetatable(cfg, library)
end

-- section
function library:section(properties)
	local cfg = {
		name = properties.name or properties.Name or "section",
		side = properties.side or "left",
		items = {},
	}

	local items = cfg.items

	items["outline"] = library:create("Frame", {
		Name = "\0",
		Parent = self.items[cfg.side .. "_column"],
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	items["inline"] = library:create("Frame", {
		Parent = items["outline"],
		Name = "\0",
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = items["inline"],
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(1, 0, 0, 11),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = dim2(0, 15, 0, 15),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["scrolling_frame"] = library:create("ScrollingFrame", {
		ScrollBarImageColor3 = rgb(119, 119, 239),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		Parent = items["inline"],
		Name = "\0",
		Size = dim2(1, 0, 1, -23),
		BackgroundTransparency = 1,
		Position = dim2(0, 0, 0, 23),
		BackgroundColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = dim2(0, 0, 0, 0),
	})

	items["elements"] = library:create("Frame", {
		Name = "\0",
		Parent = items["scrolling_frame"],
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -31, 0, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UIListLayout", {
		Parent = items["elements"],
		Padding = dim(0, 15),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	library:create("UIPadding", {
		Parent = items["scrolling_frame"],
		PaddingTop = dim(0, 18),
		PaddingRight = dim(0, 15),
		PaddingLeft = dim(0, 15),
	})

	return setmetatable(cfg, library)
end

-- elements
function library:toggle(options)
	local cfg = {
		enabled = options.enabled or nil,
		name = options.name or "Toggle",
		info = options.info or "",
		flag = options.flag or library:next_flag(),
		default = options.default or false,
		folding = options.folding or false,
		callback = options.callback or function() end,
		items = {},
	}

	flags[cfg.flag] = cfg.default

	local items = cfg.items

	items["object"] = library:create("TextButton", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, 0, 0, 22),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["info"] = library:create("TextLabel", {
		TextWrapped = true,
		Parent = items["object"],
		TextColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.info,
		Name = "\0",
		TextStrokeTransparency = 0,
		Size = dim2(1, 0, 0, 11),
		Position = dim2(0, 0, 0, 13),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		FontFace = fonts.main,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["toggle_holder"] = library:create("Frame", {
		AnchorPoint = vec2(1, 0),
		Parent = items["object"],
		Name = "\0",
		Position = dim2(1, 0, 0, 5),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 34, 0, 20),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = items["toggle_holder"],
		CornerRadius = dim(0, 99),
	})

	items["circle"] = library:create("Frame", {
		Parent = items["toggle_holder"],
		Name = "\0",
		Position = dim2(0, 2, 0, 2),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 16, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(68, 68, 70),
	})
	library:apply_theme(items["circle"], "accent", "BackgroundColor3")

	library:create("UICorner", {
		Parent = items["circle"],
		CornerRadius = dim(0, 99),
	})

	function cfg.set(bool)
		items["circle"].BackgroundColor3 = bool and themes.preset.accent or rgb(68, 68, 70)
		items["circle"].Position = bool and dim_offset(15, 2) or dim_offset(2, 2)
		cfg.callback(bool)
		flags[cfg.flag] = bool
	end

	items["object"].MouseButton1Click:Connect(function()
		cfg.enabled = not cfg.enabled
		cfg.set(cfg.enabled)
	end)

	cfg.set(cfg.default)
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:slider(options)
	local cfg = {
		name = options.name or nil,
		suffix = options.suffix or "",
		flag = options.flag or library:next_flag(),
		callback = options.callback or function() end,
		min = options.min or options.minimum or 0,
		max = options.max or options.maximum or 100,
		intervals = options.interval or options.decimal or 1,
		default = options.default or 10,
		value = options.default or 10,
		dragging = false,
		items = {},
	}

	flags[cfg.flag] = cfg.default

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		Name = "\0",
		BackgroundTransparency = 1,
		Size = dim2(1, 0, 0, 28),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["slider"] = library:create("TextButton", {
		Parent = items["object"],
		Text = "",
		AutoButtonColor = false,
		Name = "\0",
		Position = dim2(0, 0, 0, 22),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 6),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(33, 33, 33),
	})

	items["fill"] = library:create("Frame", {
		Name = "\0",
		Parent = items["slider"],
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0.5, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})
	library:apply_theme(items["fill"], "accent", "BackgroundColor3")

	items["circle"] = library:create("Frame", {
		AnchorPoint = vec2(0.5, 0.5),
		Parent = items["fill"],
		Name = "\0",
		Position = dim2(1, 0, 0.5, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 12, 0, 12),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})
	library:apply_theme(items["circle"], "accent", "BackgroundColor3")

	library:create("UICorner", {
		Parent = items["circle"],
		CornerRadius = dim(0, 99),
	})

	items["value"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = "0",
		TextStrokeTransparency = 0,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	function cfg.set(value)
		cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
		items["fill"].Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
		items["value"].Text = tostring(cfg.value) .. cfg.suffix
		flags[cfg.flag] = cfg.value
		cfg.callback(flags[cfg.flag])
	end

	items["slider"].MouseButton1Down:Connect(function()
		cfg.dragging = true
	end)

	library:connection(uis.InputChanged, function(input)
		if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local size_x = (input.Position.X - items["slider"].AbsolutePosition.X) / items["slider"].AbsoluteSize.X
			local value = ((cfg.max - cfg.min) * size_x) + cfg.min
			cfg.set(value)
		end
	end)

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cfg.dragging = false
		end
	end)

	cfg.set(cfg.default)
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:dropdown(options)
	local cfg = {
		name = options.name or "Dropdown",
		info = options.info or "",
		flag = options.flag or library:next_flag(),
		options = options.items or { "" },
		callback = options.callback or function() end,
		multi = options.multi or false,
		scrolling = options.scrolling or false,
		open = false,
		option_instances = {},
		multi_items = {},
		ignore = options.ignore or false,
		items = {},
	}

	cfg.default = options.default or (cfg.multi and { cfg.items[1] }) or cfg.items[1] or "None"
	flags[cfg.flag] = cfg.default

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, 0, 0, 25),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(237, 237, 237),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["info"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.info,
		Parent = items["object"],
		Name = "\0",
		Size = dim2(1, 0, 0, 11),
		Position = dim2(0, 0, 0, 13),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		TextWrapped = true,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["dropdown_holder"] = library:create("TextButton", {
		AnchorPoint = vec2(1, 0.5),
		Parent = items["object"],
		Name = "\0",
		Text = "",
		AutoButtonColor = false,
		Position = dim2(1, 0, 0.5, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 85, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	items["text_holder"] = library:create("TextButton", {
		Parent = items["dropdown_holder"],
		Name = "\0",
		Text = "",
		AutoButtonColor = false,
		BorderColor3 = rgb(0, 0, 0),
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	library:create("UICorner", {
		Parent = items["dropdown_holder"],
		CornerRadius = dim(0, 3),
	})

	library:create("UICorner", {
		Parent = items["text_holder"],
		CornerRadius = dim(0, 3),
	})

	items["inner_text"] = library:create("TextLabel", {
		TextWrapped = true,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = "RMB",
		Parent = items["text_holder"],
		TextStrokeTransparency = 0,
		Size = dim2(1, 0, 1, 0),
		Position = dim2(0, 4, 0, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
		FontFace = fonts.main,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	-- dropdown popup
	local dropdown_popup = library:create("Frame", {
		Name = "\0",
		Parent = library["other"],
		Visible = false,
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 85, 0, 100),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = dropdown_popup,
		CornerRadius = dim(0, 3),
	})

	local popup_inline = library:create("Frame", {
		Name = "\0",
		Parent = dropdown_popup,
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	library:create("UICorner", {
		Parent = popup_inline,
		CornerRadius = dim(0, 3),
	})

	local popup_list = library:create("ScrollingFrame", {
		ScrollBarImageColor3 = rgb(119, 119, 239),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		Parent = popup_inline,
		Name = "\0",
		Size = dim2(1, -6, 1, -6),
		Position = dim2(0, 3, 0, 3),
		BackgroundTransparency = 1,
		BackgroundColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = dim2(0, 0, 0, 0),
	})

	library:create("UIListLayout", {
		Parent = popup_list,
		Padding = dim(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	function cfg.refresh_options(new_options)
		cfg.options = new_options
		for _, v in next, cfg.option_instances do
			v:Destroy()
		end
		cfg.option_instances = {}

		for _, v in next, cfg.options do
			local opt = library:create("TextButton", {
				FontFace = fonts.main,
				TextColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				Text = v,
				Parent = popup_list,
				TextStrokeTransparency = 0,
				AutoButtonColor = false,
				Name = v,
				Size = dim2(1, 0, 0, 18),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextSize = 9,
				BackgroundColor3 = rgb(255, 255, 255),
			})

			insert(cfg.option_instances, opt)

			if cfg.multi then
				opt.MouseButton1Click:Connect(function()
					if cfg.multi_items[v] then
						cfg.multi_items[v] = false
						opt.TextColor3 = rgb(255, 255, 255)
					else
						cfg.multi_items[v] = true
						opt.TextColor3 = themes.preset.accent
					end

					local selected = {}
					for name, enabled in next, cfg.multi_items do
						if enabled then
							insert(selected, name)
						end
					end
					flags[cfg.flag] = selected
					cfg.callback(selected)
					items["inner_text"].Text = #selected > 0 and concat(selected, ", ") or "None"
				end)
			else
				opt.MouseButton1Click:Connect(function()
					items["inner_text"].Text = v
					flags[cfg.flag] = v
					cfg.callback(v)
					dropdown_popup.Visible = false
					cfg.open = false
				end)
			end
		end
	end

	cfg.refresh_options(cfg.options)

	items["dropdown_holder"].MouseButton1Click:Connect(function()
		cfg.open = not cfg.open
		dropdown_popup.Visible = cfg.open
		if cfg.open then
			dropdown_popup.Position = dim2(
				0,
				items["dropdown_holder"].AbsolutePosition.X,
				0,
				items["dropdown_holder"].AbsolutePosition.Y + items["dropdown_holder"].AbsoluteSize.Y + 1
			)
		end
	end)

	library:connection(uis.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if cfg.open and not library:mouse_in_frame(dropdown_popup) and not library:mouse_in_frame(items["dropdown_holder"]) then
				dropdown_popup.Visible = false
				cfg.open = false
			end
		end
	end)

	function cfg.set(value)
		if cfg.multi and type(value) == "table" then
			cfg.multi_items = {}
			for _, v in next, value do
				cfg.multi_items[v] = true
			end
			for _, opt in next, cfg.option_instances do
				opt.TextColor3 = cfg.multi_items[opt.Text] and themes.preset.accent or rgb(255, 255, 255)
			end
			items["inner_text"].Text = #value > 0 and concat(value, ", ") or "None"
			flags[cfg.flag] = value
			cfg.callback(value)
		else
			items["inner_text"].Text = value
			flags[cfg.flag] = value
			cfg.callback(value)
		end
	end

	cfg.set(cfg.default)
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:textbox(options)
	local cfg = {
		name = options.name or "Textbox",
		placeholder = options.placeholder or "",
		flag = options.flag or library:next_flag(),
		callback = options.callback or function() end,
		items = {},
	}

	flags[cfg.flag] = ""

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, 0, 0, 25),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(237, 237, 237),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["textbox_holder"] = library:create("Frame", {
		AnchorPoint = vec2(1, 0.5),
		Parent = items["object"],
		Name = "\0",
		Position = dim2(1, 0, 0.5, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 85, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = items["textbox_holder"],
		CornerRadius = dim(0, 3),
	})

	local textbx = library:create("TextBox", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		PlaceholderColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		PlaceholderText = cfg.placeholder,
		TextStrokeTransparency = 0,
		Parent = items["textbox_holder"],
		Name = "\0",
		Size = dim2(1, -4, 1, 0),
		Position = dim2(0, 2, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	textbx.FocusLost:Connect(function()
		flags[cfg.flag] = textbx.Text
		cfg.callback(textbx.Text)
	end)

	function cfg.set(value)
		textbx.Text = value
		flags[cfg.flag] = value
		cfg.callback(value)
	end

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:button(options)
	local cfg = {
		name = options.name or "Button",
		callback = options.callback or function() end,
		items = {},
	}

	local items = cfg.items

	items["object"] = library:create("TextButton", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = self.items["elements"],
		TextStrokeTransparency = 0,
		AutoButtonColor = false,
		Name = "\0",
		Size = dim2(1, 0, 0, 22),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
		TextSize = 9,
	})

	library:create("UICorner", {
		Parent = items["object"],
		CornerRadius = dim(0, 3),
	})

	items["object"].MouseButton1Click:Connect(function()
		cfg.callback()
	end)

	return setmetatable(cfg, library)
end

function library:keybind(options)
	local cfg = {
		name = options.name or "Keybind",
		flag = options.flag or library:next_flag(),
		default = options.default or Enum.KeyCode.RightControl,
		callback = options.callback or function() end,
		changing = false,
		items = {},
	}

	flags[cfg.flag] = { active = true, mode = "toggle", key = cfg.default }

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, 0, 0, 25),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(237, 237, 237),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["keybind_holder"] = library:create("TextButton", {
		AnchorPoint = vec2(1, 0.5),
		Parent = items["object"],
		Name = "\0",
		Text = "",
		AutoButtonColor = false,
		Position = dim2(1, 0, 0.5, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 45, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = items["keybind_holder"],
		CornerRadius = dim(0, 3),
	})

	local key_text = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = "...",
		Parent = items["keybind_holder"],
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	local mode_text = library:create("TextButton", {
		AnchorPoint = vec2(1, 0.5),
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = "T",
		Parent = items["object"],
		TextStrokeTransparency = 0,
		AutoButtonColor = false,
		Name = "\0",
		Position = dim2(1, -51, 0.5, 0),
		Size = dim2(0, 22, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
		TextSize = 9,
	})

	library:create("UICorner", {
		Parent = mode_text,
		CornerRadius = dim(0, 3),
	})

	local keyname = cfg.default.Name
	key_text.Text = keys[cfg.default] or keyname

	items["keybind_holder"].MouseButton1Click:Connect(function()
		cfg.changing = true
		key_text.Text = "..."
	end)

	library:connection(uis.InputBegan, function(input, game_event)
		if cfg.changing then
			if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then

				cfg.changing = false
				local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
				flags[cfg.flag].key = key
				keyname = key.Name
				key_text.Text = keys[key] or keyname
				cfg.callback(flags[cfg.flag])
			end
		elseif not game_event then
			local toggle = flags[cfg.flag]
			if toggle.active and (input.KeyCode == toggle.key or input.UserInputType == toggle.key) then
				if toggle.mode == "toggle" then
					toggle.active = not toggle.active
				elseif toggle.mode == "hold" then
					toggle.active = true
				end
				cfg.callback(toggle)
			end
		end
	end)

	library:connection(uis.InputEnded, function(input)
		local toggle = flags[cfg.flag]
		if toggle.active and toggle.mode == "hold" and (input.KeyCode == toggle.key or input.UserInputType == toggle.key) then
			toggle.active = false
			cfg.callback(toggle)
		end
	end)

	local mode_names = { "toggle", "hold" }
	local mode_idx = 1

	mode_text.MouseButton1Click:Connect(function()
		mode_idx = mode_idx % #mode_names + 1
		local new_mode = mode_names[mode_idx]
		flags[cfg.flag].mode = new_mode
		mode_text.Text = new_mode == "toggle" and "T" or "H"
		cfg.callback(flags[cfg.flag])
	end)

	-- keybind list
	local kb_line = library:create("Frame", {
		BackgroundTransparency = 1,
		Name = "\0",
		Parent = library.keybind_list,
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, 0, 0, 12),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	local kb_name = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = kb_line,
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(0.5, 0, 0, 12),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	local kb_key = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = themes.preset.accent,
		BorderColor3 = rgb(0, 0, 0),
		Text = keys[cfg.default] or keyname,
		Parent = kb_line,
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(0.5, 0, 0, 12),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})
	library:apply_theme(kb_key, "accent", "TextColor3")

	function cfg.set(value)
		if type(value) == "table" then
			flags[cfg.flag] = value
			keyname = value.key.Name
			key_text.Text = keys[value.key] or keyname
			kb_key.Text = keys[value.key] or keyname
			mode_text.Text = value.mode == "toggle" and "T" or "H"
			cfg.callback(value)
		end
	end

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:colorpicker(options)
	local cfg = {
		name = options.name or "Colorpicker",
		flag = options.flag or library:next_flag(),
		default = options.default or themes.preset.accent,
		transparency = options.transparency or 0,
		callback = options.callback or function() end,
		items = {},
	}

	flags[cfg.flag] = { Color = cfg.default, Transparency = cfg.transparency }

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(0, 0, 0),
		BorderColor3 = rgb(0, 0, 0),
		Text = "",
		Parent = self.items["elements"],
		BackgroundTransparency = 1,
		Name = "\0",
		Size = dim2(1, 0, 0, 25),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["title"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(237, 237, 237),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = items["object"],
		Name = "\0",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	items["color_holder"] = library:create("TextButton", {
		AnchorPoint = vec2(1, 0.5),
		Parent = items["object"],
		Name = "\0",
		Text = "",
		AutoButtonColor = false,
		Position = dim2(1, 0, 0.5, 0),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 18, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = cfg.default,
	})

	library:create("UICorner", {
		Parent = items["color_holder"],
		CornerRadius = dim(0, 3),
	})

	-- colorpicker popup
	local popup = library:create("Frame", {
		Name = "\0",
		Parent = library["other"],
		Visible = false,
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 200, 0, 230),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = popup,
		CornerRadius = dim(0, 3),
	})

	local popup_inline = library:create("Frame", {
		Name = "\0",
		Parent = popup,
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	library:create("UICorner", {
		Parent = popup_inline,
		CornerRadius = dim(0, 3),
	})

	-- saturation/brightness
	local sb = library:create("ImageLabel", {
		Image = "rbxassetid://4155801252",
		BorderColor3 = rgb(0, 0, 0),
		Parent = popup_inline,
		Position = dim2(0, 6, 0, 6),
		Size = dim2(1, -12, 0, 140),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 0, 0),
	})

	library:create("UICorner", {
		Parent = sb,
		CornerRadius = dim(0, 3),
	})

	local sb_cursor = library:create("Frame", {
		AnchorPoint = vec2(0.5, 0.5),
		BorderColor3 = rgb(0, 0, 0),
		Parent = sb,
		Size = dim2(0, 6, 0, 6),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(0, 0, 0),
	})

	library:create("UICorner", {
		Parent = sb_cursor,
		CornerRadius = dim(0, 99),
	})

	-- hue
	local hue = library:create("ImageLabel", {
		Image = "rbxassetid://2935576198",
		BorderColor3 = rgb(0, 0, 0),
		Parent = popup_inline,
		Position = dim2(0, 6, 0, 152),
		Size = dim2(1, -12, 0, 12),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UICorner", {
		Parent = hue,
		CornerRadius = dim(0, 3),
	})

	local hue_cursor = library:create("Frame", {
		AnchorPoint = vec2(0.5, 0.5),
		BorderColor3 = rgb(0, 0, 0),
		Parent = hue,
		Size = dim2(0, 6, 0, 14),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UICorner", {
		Parent = hue_cursor,
		CornerRadius = dim(0, 99),
	})

	-- transparency
	local alpha = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = popup_inline,
		Position = dim2(0, 6, 0, 168),
		Size = dim2(1, -12, 0, 12),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UICorner", {
		Parent = alpha,
		CornerRadius = dim(0, 3),
	})

	local alpha_bg = library:create("ImageLabel", {
		Image = "rbxassetid://2215084684",
		BorderColor3 = rgb(0, 0, 0),
		Parent = alpha,
		Size = dim2(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
		ScaleType = Enum.ScaleType.Tile,
		TileSize = dim2(0, 12, 0, 12),
	})

	library:create("UICorner", {
		Parent = alpha_bg,
		CornerRadius = dim(0, 3),
	})

	local alpha_fill = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = alpha_bg,
		Size = dim2(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 0, 0),
	})

	library:create("UICorner", {
		Parent = alpha_fill,
		CornerRadius = dim(0, 3),
	})

	local alpha_cursor = library:create("Frame", {
		AnchorPoint = vec2(0.5, 0.5),
		BorderColor3 = rgb(0, 0, 0),
		Parent = alpha,
		Size = dim2(0, 6, 0, 14),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("UICorner", {
		Parent = alpha_cursor,
		CornerRadius = dim(0, 99),
	})

	-- hex
	local hex_holder = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = popup_inline,
		Position = dim2(0, 6, 0, 186),
		Size = dim2(1, -12, 0, 18),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = hex_holder,
		CornerRadius = dim(0, 3),
	})

	local hex_input = library:create("TextBox", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		PlaceholderColor3 = rgb(68, 68, 70),
		BorderColor3 = rgb(0, 0, 0),
		PlaceholderText = "#FFFFFF",
		Parent = hex_holder,
		TextStrokeTransparency = 0,
		Size = dim2(1, -4, 1, 0),
		Position = dim2(0, 2, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	local current_h, current_s, current_v = cfg.default:ToHSV()
	local current_h = current_h or 0
	local current_s = current_s or 1
	local current_v = current_v or 1
	local current_a = cfg.transparency

	local function update_colorpicker()
		local color_from_hsv = hsv(current_h, current_s, current_v)
		sb.BackgroundColor3 = hsv(current_h, 1, 1)
		alpha_fill.BackgroundColor3 = color_from_hsv
		items["color_holder"].BackgroundColor3 = color_from_hsv
		items["color_holder"].BackgroundTransparency = current_a

		local sb_x = clamp(current_s * sb.AbsoluteSize.X, 0, sb.AbsoluteSize.X)
		local sb_y = clamp((1 - current_v) * sb.AbsoluteSize.Y, 0, sb.AbsoluteSize.Y)
		sb_cursor.Position = dim2(0, sb_x, 0, sb_y)

		local hue_x = clamp(current_h * hue.AbsoluteSize.X, 0, hue.AbsoluteSize.X)
		hue_cursor.Position = dim2(0, hue_x, 0.5, 0)

		local alpha_x = clamp((1 - current_a) * alpha.AbsoluteSize.X, 0, alpha.AbsoluteSize.X)
		alpha_cursor.Position = dim2(0, alpha_x, 0.5, 0)

		hex_input.Text = "#" .. color_from_hsv:ToHex()

		flags[cfg.flag] = { Color = color_from_hsv, Transparency = current_a }
		cfg.callback(color_from_hsv, current_a)
	end

	-- mouse events for sb, hue, alpha dragging
	local sb_dragging = false
	sb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sb_dragging = true
			local pos = input.Position - sb.AbsolutePosition
			current_s = clamp(pos.X / sb.AbsoluteSize.X, 0, 1)
			current_v = clamp(1 - pos.Y / sb.AbsoluteSize.Y, 0, 1)
			update_colorpicker()
		end
	end)

	local hue_dragging = false
	hue.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			hue_dragging = true
			local pos = input.Position.X - hue.AbsolutePosition.X
			current_h = clamp(pos / hue.AbsoluteSize.X, 0, 1)
			update_colorpicker()
		end
	end)

	local alpha_dragging = false
	alpha.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			alpha_dragging = true
			local pos = input.Position.X - alpha.AbsolutePosition.X
			current_a = clamp(1 - pos / alpha.AbsoluteSize.X, 0, 1)
			update_colorpicker()
		end
	end)

	library:connection(uis.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if sb_dragging then
				local pos = input.Position - sb.AbsolutePosition
				current_s = clamp(pos.X / sb.AbsoluteSize.X, 0, 1)
				current_v = clamp(1 - pos.Y / sb.AbsoluteSize.Y, 0, 1)
				update_colorpicker()
			elseif hue_dragging then
				local pos = input.Position.X - hue.AbsolutePosition.X
				current_h = clamp(pos / hue.AbsoluteSize.X, 0, 1)
				update_colorpicker()
			elseif alpha_dragging then
				local pos = input.Position.X - alpha.AbsolutePosition.X
				current_a = clamp(1 - pos / alpha.AbsoluteSize.X, 0, 1)
				update_colorpicker()
			end
		end
	end)

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sb_dragging = false
			hue_dragging = false
			alpha_dragging = false
		end
	end)

	hex_input.FocusLost:Connect(function()
		local ok, result = pcall(hex, hex_input.Text)
		if ok then
			local h, s, v = result:ToHSV()
			current_h, current_s, current_v = h, s, v
			update_colorpicker()
		end
	end)

	items["color_holder"].MouseButton1Click:Connect(function()
		popup.Visible = not popup.Visible
		if popup.Visible then
			popup.Position = dim2(
				0,
				items["color_holder"].AbsolutePosition.X - 180 + items["color_holder"].AbsoluteSize.X,
				0,
				items["color_holder"].AbsolutePosition.Y + items["color_holder"].AbsoluteSize.Y + 1
			)
		end
	end)

	library:connection(uis.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if popup.Visible and not library:mouse_in_frame(popup) and not library:mouse_in_frame(items["color_holder"]) then
				popup.Visible = false
			end
		end
	end)

	update_colorpicker()

	function cfg.set(color_val, trans_val)
		if color_val then
			local h, s, v = color_val:ToHSV()
			current_h, current_s, current_v = h, s, v
		end
		if trans_val ~= nil then
			current_a = trans_val
		end
		update_colorpicker()
	end

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:label(options)
	local cfg = {
		name = options.name or "Label",
		items = {},
	}

	local items = cfg.items

	items["object"] = library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.name,
		Parent = self.items["elements"],
		TextStrokeTransparency = 0,
		Name = "\0",
		Size = dim2(1, 0, 0, 11),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	function cfg.set(new_text)
		items["object"].Text = new_text
	end

	return setmetatable(cfg, library)
end

-- notification system
function library:notification(options)
	local cfg = {
		title = options.title or "Notification",
		message = options.message or "",
		time = options.time or 5,
		items = {},
		notif_id = #library.notifications.notifs + 1,
	}

	local notifs = library.notifications
	local notif_count = #notifs.notifs

	local notif = library:create("Frame", {
		BorderColor3 = rgb(0, 0, 0),
		Parent = library["other"],
		Position = dim2(1, -210, 1, -40 - (40 * notif_count)),
		Size = dim2(0, 200, 0, 30),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(18, 18, 20),
	})

	library:create("UICorner", {
		Parent = notif,
		CornerRadius = dim(0, 3),
	})

	local notif_inline = library:create("Frame", {
		Name = "\0",
		Parent = notif,
		Position = dim2(0, 1, 0, 1),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(7, 7, 9),
	})

	library:create("UICorner", {
		Parent = notif_inline,
		CornerRadius = dim(0, 3),
	})

	library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = themes.preset.accent,
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.title,
		Parent = notif_inline,
		TextStrokeTransparency = 0,
		Size = dim2(1, 0, 0.5, 0),
		Position = dim2(0, 4, 0, 2),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	library:create("TextLabel", {
		FontFace = fonts.main,
		TextColor3 = rgb(255, 255, 255),
		BorderColor3 = rgb(0, 0, 0),
		Text = cfg.message,
		Parent = notif_inline,
		TextStrokeTransparency = 0,
		Size = dim2(1, 0, 0.5, 0),
		Position = dim2(0, 4, 0.5, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		TextSize = 9,
		BackgroundColor3 = rgb(255, 255, 255),
	})

	insert(notifs.notifs, notif)

	task.delay(cfg.time, function()
		local idx = find(notifs.notifs, notif)
		if idx then
			remove(notifs.notifs, idx)
			notif:Destroy()
			for i = idx, #notifs.notifs do
				local target_pos = clamp(notifs.notifs[i].Position.Y.Offset + 40, 0, 9999)
				notifs.notifs[i].Position = dim2(1, -210, 1, -40 - (40 * (i - 1)))
			end
		end
	end)

	return setmetatable(cfg, library)
end
