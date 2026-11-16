-- Skid Hub (Bronx): Skid Hub GUI library + every feature from the old menu.
-- The GUI (tabs, sections, sliders, dropdowns, themes, Christmas decorations) is the Skid Hub library, embedded below.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
pcall(function()
    if getgenv().Library and type(getgenv().Library.Unload) == "function" then
        getgenv().Library:Unload()
    end
end)
getgenv().ChristmasAutoWindow = false

local function LoadChristmasUI()



-- Variables 
    -- Services
    local InputService, HttpService, GuiService, RunService, Stats, CoreGui, TweenService, SoundService, Workspace, Players = game:GetService("UserInputService"), game:GetService("HttpService"), game:GetService("GuiService"), game:GetService("RunService"), game:GetService("Stats"), game:GetService("CoreGui"), game:GetService("TweenService"), game:GetService("SoundService"), game:GetService("Workspace"), game:GetService("Players")
    local Camera, lp, gui_offset = Workspace.CurrentCamera, Players.LocalPlayer, GuiService:GetGuiInset().Y
    local mouse = lp:GetMouse()
    -- Hidden UI: use the executor's hidden container when it has one, CoreGui otherwise.
    local HiddenParent = CoreGui
    pcall(function()
        if type(gethui) == "function" then
            local hidden = gethui()
            if hidden then HiddenParent = hidden end
        end
    end)

    -- Data types
    local vec2, vec3, dim2, dim, rect, dim_offset = Vector2.new, Vector3.new, UDim2.new, UDim.new, Rect.new, UDim2.fromOffset

    -- Extra data types
    local color, rgb, hex, hsv, rgbseq, rgbkey, numseq, numkey = Color3.new, Color3.fromRGB, Color3.fromHex, Color3.fromHSV, ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new, NumberSequenceKeypoint.new
-- 

-- Library init
    getgenv().Library = {
        Directory = "xezios",
        Folders = {
            "/fonts",
            "/configs",
        },
        Christmas = true,
        Flags = {},
        ConfigFlags = {},
        Connections = {},   
        Notifications = {Notifs = {}},
        OpenElement = {}; -- type: table or userdata
    }

    local themes = {
        preset = {
            accent = rgb(240, 56, 72),
            window_outline = rgb(0, 0, 0),
            inline = rgb(26, 34, 29),
            background = rgb(14, 22, 18),
            visible_backgrounds = rgb(18, 27, 21),
            text_color = rgb(248, 242, 228),
            glow = rgb(60, 230, 130),
            deselected = rgb(112, 136, 118),
        },
        utility = {},
        gradients = {
            Selected = {};
            Deselected = {};
        },
    }

    for theme,color in themes.preset do 
        themes.utility[theme] = {
            BackgroundColor3 = {}; 	
            TextColor3 = {};
            ImageColor3 = {};
            ScrollBarImageColor3 = {};
            Color = {};
        }
    end 

    local Keys = {
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
    
    Library.__index = Library

    pcall(function()
        if not makefolder then return end
        if isfolder and not isfolder(Library.Directory) then makefolder(Library.Directory) end
        for _,path in Library.Folders do
            local p = Library.Directory .. path
            if not (isfolder and isfolder(p)) then makefolder(p) end
        end
    end)

    local Flags = Library.Flags
    local ConfigFlags = Library.ConfigFlags
    local Notifications = Library.Notifications 
--

-- Library functions 
    -- Misc functions
        function Library:GetTransparency(obj)
            if obj:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif obj:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif obj:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("UIStroke") then 
                return { "Transparency" }
            end 

            return nil
        end

        function Library:Tween(Object, Properties, Info)
            local tween = TweenService:Create(Object, Info or TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), Properties)
            tween:Play()
            return tween
        end

        function Library:Fade(obj, prop, vis, speed)
            if not (obj and prop) then
                return
            end

            local OldTransparency = obj[prop]
            obj[prop] = vis and 1 or OldTransparency

            local Tween = Library:Tween(obj, { [prop] = vis and OldTransparency or 1 }, TweenInfo.new(speed or 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0))

            Library:Connection((Tween or Library:Tween(Items.Window, {}, TweenInfo.new(0.25))).Completed, function()
                if not vis then
                    task.wait()
                    obj[prop] = OldTransparency
                end
            end)

            return Tween
        end

        function Library:Resizify(Parent)
            local UIS = game:GetService("UserInputService")
            local Camera = workspace.CurrentCamera

            -- === RESIZE HANDLE ===
            local mobile = UIS.TouchEnabled
            local Resizing = Library:Create("TextButton", {
                AnchorPoint = Vector2.new(1, 1);
                Position = dim2(1, 0, 1, 0);
                Size = mobile and dim2(0, 36, 0, 36) or dim2(0, 12, 0, 12); -- Larger handle for mobile
                BorderSizePixel = 0;
                BackgroundTransparency = mobile and 0.85 or 1;
                Text = "";
                Parent = Parent;
                ZIndex = 999;
                AutoButtonColor = false;
            })

            -- Optional for visual edge: 
            if mobile then Resizing.BackgroundColor3 = Color3.fromRGB(180,180,180) end

            local IsResizing = false
            local StartInputPos
            local StartSize

            local MIN_SIZE = mobile and Vector2.new(220, 160) or Vector2.new(180, 120) -- Larger min for mobile

            local function beginResize(input)
                IsResizing = true
                StartInputPos = input.Position
                StartSize = Parent.Size
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        IsResizing = false
                    end
                end)
            end

            -- INPUT BEGIN
            Resizing.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    beginResize(input)
                end
            end)

            -- INPUT END
            Resizing.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    IsResizing = false
                end
            end)
            
            -- INPUT MOVE (Mouse or Touch)
            UIS.InputChanged:Connect(function(input)
                if not IsResizing then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

                local delta = input.Position - StartInputPos
                local viewport = Camera.ViewportSize

                local newX = math.clamp(
                    StartSize.X.Offset + delta.X,
                    MIN_SIZE.X,
                    viewport.X - Parent.AbsolutePosition.X
                )

                local newY = math.clamp(
                    StartSize.Y.Offset + delta.Y,
                    MIN_SIZE.Y,
                    viewport.Y - Parent.AbsolutePosition.Y
                )

                Parent.Size = UDim2.fromOffset(newX, newY)
            end)
        end

        -- Improved Hovering for mobile input
        function Library:Hovering(Object)
            local x, y

            if InputService.TouchEnabled then
                -- On mobile, check latest touch location (or last mouse location as a fallback)
                -- UserInputService has no GetTouches (it threw on phones); on touch devices
                -- GetMouseLocation already returns the last touch position.
                local okTouch, touchPos = pcall(function() return InputService:GetMouseLocation() end)
                if okTouch and touchPos then
                    x, y = touchPos.X, touchPos.Y
                end
            end

            if not x or not y then
                if mouse then
                    x, y = mouse.X, mouse.Y
                else
                    -- fallback: try MouseLocation for both pc/mobile
                    if InputService then
                        local pos = InputService:GetMouseLocation()
                        x, y = pos.X, pos.Y
                    else
                        return false
                    end
                end
            end

            if type(Object) == "table" then
                for _, obj in pairs(Object) do
                    if obj and Library:Hovering(obj) then
                        return true
                    end
                end
                return false
            end

            if not Object or not Object.AbsolutePosition then
                return false
            end

            local pos = Object.AbsolutePosition
            local size = Object.AbsoluteSize

            return (
                x >= pos.X and x <= pos.X + size.X and
                y >= pos.Y and y <= pos.Y + size.Y
            )
        end

        -- Update Draggify for mobile: handles both mouse, touch without clamping to screen bounds
        function Library:Draggify(Parent)
            local Dragging = false
            local StartPos, StartInput
            local Camera = workspace.CurrentCamera
            local UIS = game:GetService("UserInputService")

            local function beginDrag(input)
                Dragging = true
                StartInput = input.Position
                StartPos = Parent.Position
                -- For mobile, properly end drag on touch end
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end

            Parent.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    beginDrag(input)
                end
            end)

            Parent.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if not Dragging then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

                local delta = input.Position - StartInput
                local newX = StartPos.X.Offset + delta.X
                local newY = StartPos.Y.Offset + delta.Y

                -- No clamping, allow dragging through/outside the screen
                Parent.Position = UDim2.new(0, newX, 0, newY)
            end)

            -- Fallback for legacy InputService or multi-touch cases
            Library:Connection(InputService.InputChanged, function(Input, game_event) 
                if Dragging and (
                        Input.UserInputType == Enum.UserInputType.MouseMovement or
                        (Input.UserInputType == Enum.UserInputType.Touch)
                    ) then
                    if not StartPos or not StartInput then return end

                    local newX = StartPos.X.Offset + (Input.Position.X - StartInput.X)
                    local newY = StartPos.Y.Offset + (Input.Position.Y - StartInput.Y)

                    -- No clamping here either
                    Parent.Position = UDim2.new(0, newX, 0, newY)
                end
            end)
        end 


        function Library:Convert(str)
            local Values = {}

            for Value in string.gmatch(str, "[^,]+") do
                table.insert(Values, tonumber(Value))
            end

            if #Values == 4 then              
                return unpack(Values)
            else
                return
            end
        end
        
        function Library:Lerp(start, finish, t)
            t = t or 1 / 8

            return start * (1 - t) + finish * t
        end

        function Library:ConvertEnum(enum)
            local EnumParts = {}
            
            for part in string.gmatch(enum, "[%w_]+") do
                table.insert(EnumParts, part)
            end
        
            local EnumTable = Enum

            for i = 2, #EnumParts do
                local EnumItem = EnumTable[EnumParts[i]]
        
                EnumTable = EnumItem
            end
            
            return EnumTable
        end

        function Library:ConvertHex(color, alpha)
            local r = math.floor(color.R * 255)
            local g = math.floor(color.G * 255)
            local b = math.floor(color.B * 255)
            local a = alpha and math.floor(alpha * 255) or 255
            return string.format("#%02X%02X%02X%02X", r, g, b, a)
        end

        function Library:ConvertFromHex(color)
            color = color:gsub("#", "")
            local r = tonumber(color:sub(1, 2), 16) / 255
            local g = tonumber(color:sub(3, 4), 16) / 255
            local b = tonumber(color:sub(5, 6), 16) / 255
            local a = tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16) / 255 or 1
            return Color3.new(r, g, b), a
        end

        local ConfigHolder;
        function Library:UpdateConfigList() 
            if not ConfigHolder then 
                return 
            end
            
            local List = {}
            local ok, files = pcall(function() return listfiles(Library.Directory .. "/configs") end)

            if ok and type(files) == "table" then
                for _,file in files do
                    local Name = tostring(file):match("([^/\\]+)$") or tostring(file)
                    Name = Name:gsub("%.cfg$", "")
                    List[#List + 1] = Name
                end
            end

            ConfigHolder.RefreshOptions(List)
        end

        function Library:Keypicker(properties) 
            local Cfg = {
                Name = properties.Name or properties.name or "Color", 
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '' or "Colorpicker",
                Callback = properties.callback or properties.Callback or function() end,

                Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
                Alpha = properties.Alpha or properties.Transparency or 0,
                
                Mode = properties.Mode or "Keypicker"; -- Animation

                -- Other
                Open = false, 
                Items = {};
            }

            local DraggingSat = false 
            local DraggingHue = false 
            local DraggingAlpha = false 

            local h, s, v = Cfg.Color:ToHSV() 
            local a = Cfg.Alpha 

            Flags[Cfg.Flag] = {Color = Cfg.Color, Transparency = Cfg.Alpha}

            local Items = Cfg.Items; do 
                -- Component
                    Items.Button = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Name = "\0";
                        LayoutOrder = -1;
                        Parent = self.Items.Components;
                        Size = dim2(0, 28, 0, 14);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(26, 28, 28)
                    });
                    
                    Items.ButtonColor = Library:Create( "Frame" , {
                        Parent = Items.Button;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(119, 180, 91)
                    });
                    
                    Library:Create( "UICorner" , {
                        Parent = Items.ButtonColor;
                        CornerRadius = dim(0, 4)
                    });
                    
                    Library:Create( "UICorner" , {
                        Parent = Items.Button;
                        CornerRadius = dim(0, 4)
                    });
                --
                
                -- Colorpicker
                    Items.Window = Library:Create( "TextButton" , {
                        Parent = Library.Other;
                        Text = "";
                        AutoButtonColor = false;
                        Active = false;
                        Name = "\0";
                        Position = dim2(0, 100, 0, 10);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 230, 0, 200);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Window, "inline", "BackgroundColor3")

                    Items.Fade = Library:Create( "Frame" , {
                        Parent = Items.Window;
                        BackgroundTransparency = 1;
                        ZIndex = 500;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Window, "inline", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Window
                    });                    

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Window;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.visible_backgrounds
                    });	Library:Themify(Items.Inline, "visible_backgrounds", "BackgroundColor3")
                    
                    Library:Create( "UICorner" , {
                        Parent = Items.Inline
                    });                    

                    Items.Fill = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 26);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Fill, "inline", "BackgroundColor3")
                    
                    Items.Pallete = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -4, 1, -3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(40, 40, 40)
                    });
                    
                    Items.Outline = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Pallete;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -38, 1, -43);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")
                    
                    Items.Inner = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 221, 255)
                    });
                    
                    Items.Val = Library:Create( "TextButton" , {
                        Name = "\0";
                        Text = "";
                        AutoButtonColor = false;
                        Parent = Items.Inner;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIGradient" , {
                        Parent = Items.Val;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    Items.SatValPicker = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Inner;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 3, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.inline = Library:Create( "Frame" , {
                        Parent = Items.SatValPicker;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.Saturation = Library:Create( "Frame" , {
                        Parent = Items.Inner;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = Items.Saturation;
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    Items.HexTextbox = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.Pallete;
                        Name = "\0";
                        Position = dim2(0, 1, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -39, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.HexTextbox;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")
                    
                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.background
                    });	Library:Themify(Items.Background, "background", "BackgroundColor3")
                    
                    Items.AlphaInput = Library:Create( "TextBox" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        Parent = Items.Background;
                        TextColor3 = rgb(239, 239, 239);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "255, 255, 255, 0.5";
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        Active = false;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.HueTextbox = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.Pallete;
                        Name = "\0";
                        Position = dim2(0, 1, 1, -22);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -39, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.HueTextbox;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")
                    
                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.background
                    });	Library:Themify(Items.Background, "background", "BackgroundColor3")
                    
                    Items.RGBInput = Library:Create( "TextBox" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        Parent = Items.Background;
                        TextColor3 = rgb(239, 239, 239);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "255, 255, 255, 0.5";
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Active = false;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.Alpha = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 1);
                        Parent = Items.Pallete;
                        Name = "\0";
                        Position = dim2(1, 2, 1, 0);
                        Size = dim2(0, 16, 1, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Alpha;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")
                    
                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Background;
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(9, 9, 9))}
                    });
                    
                    Items.AlphaPicker = Library:Create( "Frame" , {
                        Parent = Items.Background;
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 2, 0, 3);
                        Position = dim2(0, -1, 0, -1);
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.RGB = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 1);
                        Parent = Items.Pallete;
                        Name = "\0";
                        Position = dim2(1, -18, 1, 0);
                        Size = dim2(0, 16, 1, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.RGB;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")
                    
                    Items.hue_drag = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.hue_drag;
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}
                    });
                    
                    Items.HuePicker = Library:Create( "Frame" , {
                        Parent = Items.hue_drag;
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 2, 0, 3);
                        Position = dim2(0, -1, 0, -1);
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 2);
                        PaddingBottom = dim(0, 3);
                        Parent = Items.Pallete;
                        PaddingRight = dim(0, 3);
                        PaddingLeft = dim(0, 2)
                    });
                -- 
            end;
            
            function Cfg.SetVisible(bool)
                Items.Fade.BackgroundTransparency = 0 
                Library:Tween(Items.Fade, {BackgroundTransparency = 1})

                Items.Window.Visible = bool
                Items.Window.Parent = bool and Library.Items or Library.Other
                Items.Window.Position = dim2(0, Items.Button.AbsolutePosition.X + 2, 0, Items.Button.AbsolutePosition.Y + 74)
            end
            
            function Cfg.Set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                local Color = hsv(h, s, v)

                Items.SatValPicker.Position = dim2(s, 0, 1 - v, 0)
                Items.AlphaPicker.Position = dim2(0, -1, a, -1)
                Items.HuePicker.Position = dim2(0, -1, h, -1)
                
                Items.ButtonColor.BackgroundColor3 = hsv(h,s,v)
                Items.Inner.BackgroundColor3 = hsv(h,1,1)

                Flags[Cfg.Flag] = {
                    Color = Color;
                    color = Color;
                    Transparency = a;
                    transparency = a;
                }
                
                local Color = Items.ButtonColor.BackgroundColor3 -- Overwriting to format<<
                Items.RGBInput.Text = string.format("%s, %s, %s, ", Library:Round(Color.R * 255), Library:Round(Color.G * 255), Library:Round(Color.B * 255))
                Items.RGBInput.Text ..= Library:Round(1 - a, 0.01)
                
                Items.AlphaInput.Text = Library:ConvertHex(Color, 1 - a)

                Cfg.Callback(Color, a)
            end


            function Cfg.UpdateColor(input)
                local pos
                if input and (input.Position ~= nil) then
                    pos = input.Position
                else
                    local Mouse = InputService:GetMouseLocation()
                    pos = vec2(Mouse.X, Mouse.Y - gui_offset)
                end

                if DraggingSat then	
                    s = ((pos - Items.Val.AbsolutePosition).X / Items.Val.AbsoluteSize.X)
                    v = 1 - ((pos - Items.Val.AbsolutePosition).Y / Items.Val.AbsoluteSize.Y)
                elseif DraggingHue then
                    h = ((pos - Items.RGB.AbsolutePosition).Y / Items.RGB.AbsoluteSize.Y)
                elseif DraggingAlpha then
                    a = ((pos - Items.Alpha.AbsolutePosition).Y / Items.Alpha.AbsoluteSize.Y)
                end

                Cfg.Set()
            end

            Items.Button.MouseButton1Click:Connect(function()
                Cfg.Open = not Cfg.Open
                Cfg.SetVisible(Cfg.Open)            
            end)
            if Items.Button.TouchTap then
                Items.Button.TouchTap:Connect(function()
                    Cfg.Open = not Cfg.Open
                    Cfg.SetVisible(Cfg.Open)
                end)
            end

            InputService.InputChanged:Connect(function(input)
                if (DraggingSat or DraggingHue or DraggingAlpha) and 
                    (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Cfg.UpdateColor(input)
                end
            end)

            Library:Connection(InputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    DraggingSat = false
                    DraggingHue = false
                    DraggingAlpha = false

                    if not Library:Hovering({Items.Button, Items.Window}) then
                        Cfg.SetVisible(false)
                        Cfg.Open = false
                    end 
                end
            end)    

            Library:Connection(InputService.InputBegan, function(input, game_event)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not Library:Hovering({Items.Button, Items.Window}) then
                        Cfg.SetVisible(false)
                        Cfg.Open = false
                    end 
                end 
            end)

            local function assign_input_handlers(UIElement, drag_var_name)
                if UIElement.MouseButton1Down then
                    UIElement.MouseButton1Down:Connect(function()
                        _G[drag_var_name] = false 
                        _G[drag_var_name] = true
                    end)
                end
                if UIElement.TouchTap then
                    UIElement.TouchTap:Connect(function()
                        _G[drag_var_name] = false
                        _G[drag_var_name] = true
                    end)
                end
                if UIElement.TouchLongPress then
                    UIElement.TouchLongPress:Connect(function()
                        _G[drag_var_name] = false
                        _G[drag_var_name] = true
                    end)
                end
            end

            assign_input_handlers(Items.Alpha, "DraggingAlpha")
            assign_input_handlers(Items.RGB, "DraggingHue")
            assign_input_handlers(Items.Val, "DraggingSat")


            Items.RGBInput.FocusLost:Connect(function()
                local text = Items.RGBInput.Text
                local r, g, b, a = Library:Convert(text)
                
                if r and g and b and a then 
                    Cfg.Set(rgb(r, g, b), 1 - a)
                end 
            end)

            Items.AlphaInput.FocusLost:Connect(function()
                local Color, Alpha = Library:ConvertFromHex(Items.AlphaInput.Text)
                Cfg.Set(Color, 1 - Alpha)
            end)

            Cfg.Set(Cfg.Color, Cfg.Alpha)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:GetConfig()
            local g = {}
            
            for Idx, Value in Flags do
                if type(Value) == "table" and Value.key then
                    g[Idx] = {active = Value.Active, mode = Value.Mode, key = tostring(Value.Key)}
                elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                    g[Idx] = {Transparency = Value["Transparency"], Color = Value["Color"]:ToHex()}
                else
                    g[Idx] = Value
                end
            end 

            return HttpService:JSONEncode(g)
        end

        function Library:LoadConfig(JSON) 
            local g = HttpService:JSONDecode(JSON)
            
            for Idx, Value in g do                
                if Idx == "config_name_list" then 
                    continue 
                end

                local Function = ConfigFlags[Idx]

                if Function then 
                    if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                        Function(hex(Value["Color"]), Value["Transparency"])
                    elseif type(Value) == "table" and Value["Active"] then 
                        Function(Value)
                    else
                        Function(Value)
                    end
                end 
            end 
        end 
        
        function Library:Round(num, float) 
            local Multiplier = 1 / (float or 1)
            return math.floor(num * Multiplier + 0.5) / Multiplier
        end

        function Library:Themify(instance, theme, property)
            table.insert(themes.utility[theme][property], instance)
        end

        function Library:SaveGradient(instance, theme) -- instance, tabfill or background, color
            table.insert(themes.gradients[theme], instance)
        end

        --[[
            gradients = {
            Selected = {};
            Deselected = {};
        },
        gradient_preset = {
            Selected = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)};
            Deselected = rgbseq{rgbkey(0, themes.preset.gradient), rgbkey(1, themes.preset.background)};
        },
        ]]

        function Library:RefreshTheme(theme, color)
            for property,instances in themes.utility[theme] do 
                for _,object in instances do
                    if object[property] == themes.preset[theme] then 
                        object[property] = color 
                    end
                end 
            end

            themes.preset[theme] = color 
        end 

        function Library:Connection(signal, callback)
            local connection = signal:Connect(callback)
            
            table.insert(Library.Connections, connection)

            return connection 
        end

        function Library:CloseElement() 
            if not (Library.OpenElement and Library.OpenElement.SetVisible) then 
                return 
            end 

            Library.OpenElement.SetVisible(false)
            Library.OpenElement.Open = false
		end

        function Library:Create(instance, options)
            local ins = Instance.new(instance) 

            for prop, value in options do
                ins[prop] = value
            end

            if ins == "TextButton" then 
                ins["AutoButtonColor"] = false 
                ins["Text"] = ""
            end 
            
            return ins 
        end

        function Library:Unload() 
            if Library.Items then 
                Library.Items:Destroy()
            end

            if Library.Other then 
                Library.Other:Destroy()
            end
            
            for _,connection in Library.Connections do 
                connection:Disconnect() 
                connection = nil 
            end

            getgenv().Library = nil 
        end
    --
    
    -- Library element functions
        function Library:Window(properties)
            local Cfg = {
                Prefix = properties.Prefix or "inferno.";
                Suffix = properties.Suffix or "wtf";
                Size = properties.Size or dim2(0, 620, 0, 471);
                TabInfo;
                Items = {};
            }

            local function makeDraggable(frame)
                local dragging = false
                local dragStart, startPos

                frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        dragStart = input.Position
                        startPos = frame.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)

                frame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                local UIS = game:GetService("UserInputService")
                UIS.InputChanged:Connect(function(input)
                    if not dragging then return end
                    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end)
            end

            Cfg._makeWindowDraggable = makeDraggable



            Library.Items = Library:Create("ScreenGui", {
                Parent = HiddenParent;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                ResetOnSpawn = false; -- helpful for mobile
            })

            Library.Other = Library:Create("ScreenGui", {
                Parent = HiddenParent;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                ResetOnSpawn = false;
            })

            local Items = Cfg.Items; do
                Items.Window = Library:Create("Frame", {
                    Parent = Library.Items;
                    Name = "\0";
                    AnchorPoint = vec2(0.5, 0.5);
                    Position = dim2(0.5, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = Cfg.Size;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                }); Library:Themify(Items.Window, "window_outline", "BackgroundColor3");

                -- Keep the main panel centered when the viewport changes (including rotation).
                Library:Connection(Camera:GetPropertyChangedSignal("ViewportSize"), function()
                    Items.Window.Position = dim2(0.5, 0, 0.5, 0)
                end)

                -- Scale the complete existing interface to fit phone screens.
                if InputService.TouchEnabled then
                    local viewport = Camera.ViewportSize
                    local availableWidth = math.max(240, viewport.X - 24)
                    local availableHeight = math.max(220, viewport.Y - 110)
                    local fitScale = math.min(
                        availableWidth / math.max(Cfg.Size.X.Offset, 1),
                        availableHeight / math.max(Cfg.Size.Y.Offset, 1)
                    )
                    local mobileScale = math.clamp(fitScale, 0.45, 0.78)

                    Items.MobileScale = Library:Create("UIScale", {
                        Parent = Items.Window;
                        Scale = mobileScale;
                    })

                    Library:Connection(Camera:GetPropertyChangedSignal("ViewportSize"), function()
                        local newViewport = Camera.ViewportSize
                        local width = math.max(240, newViewport.X - 24)
                        local height = math.max(220, newViewport.Y - 110)
                        local scale = math.min(
                            width / math.max(Cfg.Size.X.Offset, 1),
                            height / math.max(Cfg.Size.Y.Offset, 1)
                        )
                        Items.MobileScale.Scale = math.clamp(scale, 0.45, 0.78)
                    end)
                end

                Items.Outline = Library:Create("Frame", {
                    Parent = Items.Window;
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                }); Library:Themify(Items.Outline, "window_outline", "BackgroundColor3")

                Items.Inline = Library:Create("Frame", {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.inline
                }); Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                Items.TabHolderFrame = Library:Create("Frame", {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 139, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(10, 17, 13)
                });

                Items.Filler = Library:Create("Frame", {
                    Parent = Items.TabHolderFrame;
                    Name = "\0";
                    Position = dim2(1, -1, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.inline
                }); Library:Themify(Items.Filler, "inline", "BackgroundColor3")

                Items.TabHolder = Library:Create("Frame", {
                    Parent = Items.TabHolderFrame;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create("UIListLayout", {
                    Parent = Items.TabHolder;
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                Library:Create("UIPadding", {
                    Parent = Items.TabHolder;
                    PaddingTop = dim(0, 6)
                });

                Items.PageHolder = Library:Create("Frame", {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 140, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -141, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.background
                }); Library:Themify(Items.PageHolder, "background", "BackgroundColor3")

                Items.TitleHolder = Library:Create("Frame", {
                    Parent = Items.PageHolder;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 43);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Filler = Library:Create("Frame", {
                    Parent = Items.TitleHolder;
                    Name = "\0";
                    Position = dim2(0, 0, 1, -1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.inline
                }); Library:Themify(Items.Filler, "inline", "BackgroundColor3")

                Items.SectionTitle = Library:Create("TextLabel", {
                    RichText = true;
                    Parent = Items.TitleHolder;
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = '<font color = "rgb(255,255,255)">' .. Cfg.Prefix .. '</font>' .. Cfg.Suffix .. '';
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0.5, 0);
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
                    ZIndex = 2;
                    TextSize = 20;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Library:Themify(Items.SectionTitle, "accent", "TextColor3")

                Library:Create("UIPadding", {
                    Parent = Items.SectionTitle;
                    PaddingRight = dim(0, 8);
                    PaddingLeft = dim(0, 13)
                });

                Items.Pages = Library:Create("Frame", {
                    Parent = Items.PageHolder;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 43);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -43);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Fade = Library:Create("Frame", {
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Parent = Items.Pages;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.background;
                    ZIndex = 2;
                }); Library:Themify(Items.Fade, "background", "BackgroundColor3")

                Items.Glow = Library:Create("ImageLabel", {
                    ImageColor3 = rgb(255, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    ImageTransparency = 0.6499999761581421;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Window;
                    Name = "\0";
                    Size = dim2(1, 40, 1, 40);
                    Image = "rbxassetid://18245826428";
                    BackgroundTransparency = 1;
                    Position = dim2(0, -20, 0, -20);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(21, 21), vec2(79, 79))
                }); Library:Themify(Items.Glow, "glow", "ImageColor3")
            end

            do
                local UIS = game:GetService("UserInputService")
                local Camera = workspace.CurrentCamera
                local Dragging, DragInput, DragStart, StartPos
                local function update(input)
                    local delta
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                        if UIS.TouchEnabled and input.Position then
                            delta = input.Position - DragStart
                        elseif not UIS.TouchEnabled then
                            delta = input.Position - DragStart
                        else
                            return
                        end
                        -- Preserve the original scale components. The window is centered
                        -- with 0.5 scale; replacing them with 0 caused it to jump top-left
                        -- the first time it was dragged after reopening.
                        Items.Window.Position = UDim2.new(
                            StartPos.X.Scale,
                            StartPos.X.Offset + delta.X,
                            StartPos.Y.Scale,
                            StartPos.Y.Offset + delta.Y
                        )
                    end
                end

                Items.Window.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        DragStart = input.Position
                        StartPos = Items.Window.Position
                        DragInput = input
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                            end
                        end)
                    end
                end)

                Items.Window.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        DragInput = input
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if Dragging and input == DragInput then
                        update(input)
                    end
                end)

                -- Optionally also enable resizify (not altered)
                Library:Resizify(Items.Window)
            end
            -- END: Enhanced drag/move for Desktop & Mobile

            function Cfg.ToggleMenu(bool) 
                if Cfg.Tweening then 
                    return 
                end 

                Cfg.Tweening = true

                if bool then
                    Items.Window.AnchorPoint = vec2(0.5, 0.5)
                    Items.Window.Position = dim2(0.5, 0, 0.5, 0)
                end

                Items.Window.Visible = true

                -- Decorations are not faded piece by piece: they hide first and return once the menu is back.
                if not bool and Library.XmasSetShown then
                    Library.XmasSetShown(false)
                end

                local Children = Items.Window:GetDescendants()
                table.insert(Children, Items.Window)

                local Tween;
                for _,obj in Children do
                    if obj.Name == "XmasDecor" or obj:FindFirstAncestor("XmasDecor") then
                        continue
                    end

                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    task.wait()
                    Cfg.Tweening = false
                    Items.Window.Visible = bool

                    if bool and Library.XmasSetShown then
                        Library.XmasSetShown(true)
                    end

                    if Items.HideMenuButton then
                        Items.HideMenuButton.Visible = bool
                        Items.HideMenuGlow.Visible = bool
                    end
                    if Items.ShowMenuButton then
                        Items.ShowMenuButton.Visible = not bool
                        Items.ShowMenuGlow.Visible = not bool
                    end
                end)
            end

            -- Menu controls stay in the bottom-left corner on desktop and mobile.
            do
                local mobile = InputService.TouchEnabled
                local buttonWidth = mobile and 96 or 104
                local buttonHeight = 32
                local controlPosition = dim2(0, 16, 1, -16)

                local function createMenuControl(text)
                    local glow = Library:Create("ImageLabel", {
                        Name = "MenuControlGlow";
                        Parent = Library.Items;
                        AnchorPoint = vec2(0.5, 0.5);
                        Position = dim2(0, 16 + buttonWidth / 2, 1, -16 - buttonHeight / 2);
                        Size = dim2(0, buttonWidth + 36, 0, buttonHeight + 36);
                        Image = "rbxassetid://18245826428";
                        ImageColor3 = themes.preset.glow;
                        ImageTransparency = 0.65;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = rect(vec2(21, 21), vec2(79, 79));
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        ZIndex = 998;
                    })
                    Library:Themify(glow, "glow", "ImageColor3")

                    local button = Library:Create("TextButton", {
                        Name = "MenuVisibilityControl";
                        Parent = Library.Items;
                        AnchorPoint = vec2(0, 1);
                        Position = controlPosition;
                        Size = dim2(0, buttonWidth, 0, buttonHeight);
                        BackgroundColor3 = themes.preset.window_outline;
                        BorderSizePixel = 0;
                        AutoButtonColor = false;
                        Text = "";
                        ZIndex = 1000;
                        Visible = true;
                    })

                    Library:Create("Frame", {
                        Name = "ControlInline";
                        Parent = button;
                        Position = dim2(0, 1, 0, 1);
                        Size = dim2(1, -2, 1, -2);
                        BackgroundColor3 = themes.preset.inline;
                        BorderSizePixel = 0;
                        ZIndex = 1001;
                    })

                    local face = Library:Create("Frame", {
                        Name = "ControlFace";
                        Parent = button.ControlInline;
                        Position = dim2(0, 1, 0, 1);
                        Size = dim2(1, -2, 1, -2);
                        BackgroundColor3 = themes.preset.background;
                        BorderSizePixel = 0;
                        ZIndex = 1002;
                    })

                    Library:Create("TextLabel", {
                        Name = "ControlText";
                        Parent = face;
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        Text = text;
                        TextColor3 = themes.preset.text_color;
                        TextSize = mobile and 12 or 13;
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextXAlignment = Enum.TextXAlignment.Center;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        ZIndex = 1003;
                    })

                    Library:Create("UIStroke", {
                        Parent = button;
                        Color = themes.preset.accent;
                        Thickness = 1;
                        Transparency = 0.2;
                    })

                    return button, glow
                end

                Items.HideMenuButton, Items.HideMenuGlow = createMenuControl("Hide Menu")
                Items.ShowMenuButton, Items.ShowMenuGlow = createMenuControl("Show Menu")
                Items.ShowMenuButton.Visible = false
                Items.ShowMenuGlow.Visible = false

                Items.HideMenuButton.Activated:Connect(function()
                    if not Cfg.Tweening then
                        Cfg.ToggleMenu(false)
                    end
                end)

                Items.ShowMenuButton.Activated:Connect(function()
                    if not Cfg.Tweening then
                        Cfg.ToggleMenu(true)
                    end
                end)
            end

            function Cfg.ChangeMenuTitle(text)
                Items.SectionTitle.Text = text
            end

            function Cfg.ToggleKeybindList(bool)
                if Items.Keybind_List then Items.Keybind_List.Visible = bool end
            end
            

            Library:ChristmasDecorate(Cfg)

            return setmetatable(Cfg, Library)
        end 

        function Library:Tab(properties)
            local Cfg = {
                Name = properties.Name or properties.name or properties.Name or "visuals"; 
                Icon = properties.Icon or properties.icon or "rbxassetid://112730572155522";
                Items = {};
            }

            local Items = Cfg.Items; do 
                -- Tab buttons 
                    Items.Button = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = self.Items.TabHolder;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 30);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.Holder = Library:Create( "Frame" , {
                        Parent = Items.Button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 6, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -13, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.visible_backgrounds
                    });	Library:Themify(Items.Holder, "visible_backgrounds", "BackgroundColor3")
                    
                    Items.Icon = Library:Create( "ImageLabel" , {
                        ImageColor3 = themes.preset.deselected;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Holder;
                        Name = "\0";
                        AnchorPoint = vec2(0, 0.5);
                        Image = Cfg.Icon;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 8, 0.5, 0);
                        Size = dim2(0, 14, 0, 14);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Icon, "deselected", "ImageColor3"); Library:Themify(Items.Icon, "accent", "ImageColor3")
                    
                    Items.SectionTitle = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.deselected;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Parent = Items.Holder;
                        Name = "\0";
                        AnchorPoint = vec2(0, 0.5);
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 22, 0.5, 0);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        TextSize = 14;
                        BackgroundColor3 = rgb(10, 17, 13)
                    });	Library:Themify(Items.SectionTitle, "text_color", "TextColor3") Library:Themify(Items.SectionTitle, "deselected", "TextColor3") 
                    Items.SectionTitle.TextColor3 = themes.preset.deselected;
                    Library:Create( "UIPadding" , {
                        Parent = Items.SectionTitle;
                        PaddingRight = dim(0, 8);
                        PaddingLeft = dim(0, 8)
                    });
                    
                    Items.Indicator = Library:Create( "ImageLabel" , {
                        ImageColor3 = themes.preset.accent;
                        ImageTransparency = 1;
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Button;
                        AnchorPoint = vec2(0, 0.5);
                        Image = "rbxassetid://126397903791071";
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 2, 0, 19);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Indicator, "accent", "ImageColor3")                
                -- 

                -- Page directory 
                    Items.Pages = Library:Create( "Frame" , {
                        Parent = Library.Other; -- self.Items.Pages;
                        Visible = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Pages;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });
                    
                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 6);
                        PaddingBottom = dim(0, 6);
                        Parent = Items.Pages;
                        PaddingRight = dim(0, 6);
                        PaddingLeft = dim(0, 6)
                    });
                    
                    Items.Left = Library:Create( "ScrollingFrame" , {
                        ScrollBarImageColor3 = rgb(0, 0, 0);
                        Active = true;
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 0;
                        Parent = Items.Pages;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(0, 100, 0, 100);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        CanvasSize = dim2(0, 0, 0, 0)
                    });
                    
                    Library:Create( "UIListLayout" , {
                        Parent = Items.Left;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill
                    });
                    
                    Items.Right = Library:Create( "ScrollingFrame" , {
                        ScrollBarImageColor3 = rgb(0, 0, 0);
                        Active = true;
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 0;
                        Parent = Items.Pages;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(0, 100, 0, 100);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        CanvasSize = dim2(0, 0, 0, 0)
                    });
                    
                    Library:Create( "UIListLayout" , {
                        Parent = Items.Right;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill
                    });                
                -- 
            end 

            function Cfg.OpenTab() 
                local Tab = self.TabInfo
                
                if Tab then
                    Library:Tween(Tab.Indicator, {ImageTransparency = 1})
                    Library:Tween(Tab.Holder, {BackgroundTransparency = 1})
                    Library:Tween(Tab.Icon, {ImageColor3 = themes.preset.deselected})
                    Library:Tween(Tab.SectionTitle, {TextColor3 = themes.preset.deselected})

                    Tab.Pages.Visible = false
                    Tab.Pages.Parent = Library.Other
                end

                    self.Items.Fade.BackgroundTransparency = 0 
                    Library:Tween(self.Items.Fade, {BackgroundTransparency = 1})

                Library:Tween(Items.Indicator, {ImageTransparency = 0})
                Library:Tween(Items.Holder, {BackgroundTransparency = 0})
                Library:Tween(Items.Icon, {ImageColor3 = themes.preset.accent})
                Library:Tween(Items.SectionTitle, {TextColor3 = themes.preset.text_color})

                Items.Pages.Parent = self.Items.Pages;
                Items.Pages.Visible = true
                
                self.TabInfo = Cfg.Items
            end

            Items.Button.MouseButton1Down:Connect(function()
                Cfg.OpenTab()
            end)

            if not self.TabInfo then
                Cfg.OpenTab()
            end

            return setmetatable(Cfg, Library)
        end

        function Library:Section(properties)
            local Cfg = {
                Name = properties.Name or properties.name or "Section"; 
                Side = properties.side or properties.Side or "Left";

                -- Fill settings 
                -- Size = properties.size or properties.Size or nil;
                
                -- Other
                Items = {};
            };
            if Cfg.Side == 'left' then
                Cfg.Side = "Left";
            elseif Cfg.Side == 'right' then
                Cfg.Side = "Right";
            end
            
            local Items = Cfg.Items; do
                Items.Section = Library:Create( "Frame" , {
                    Parent = self.Items[ Cfg.Side ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = themes.preset.inline
                });	Library:Themify(Items.Section, "inline", "BackgroundColor3")
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Section;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = themes.preset.visible_backgrounds
                });	Library:Themify(Items.Inline, "visible_backgrounds", "BackgroundColor3")
                
                Items.SectionTitle = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Inline;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 6);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Library:Create( "UIPadding" , {
                    Parent = Items.SectionTitle;
                    PaddingRight = dim(0, 8);
                    PaddingLeft = dim(0, 6)
                });
                
                Items.Fill = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 26);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.inline
                });	Library:Themify(Items.Fill, "inline", "BackgroundColor3")
                
                Items.Elements = Library:Create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Inline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 36);
                    Size = dim2(1, -14, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.Elements;
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                Library:Create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = Items.Elements
                });
                
                Library:Create( "UIPadding" , {
                    PaddingBottom = dim(0, 2);
                    Parent = Items.Section
                });                
            end;

            return setmetatable(Cfg, Library)
        end  

        function Library:Toggle(properties) 
            local Cfg = {
                Name = properties.Name or properties.name or "Toggle";
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '' or "Toggle";
                Enabled = properties.Default or properties.default or false;
                Callback = properties.callback or properties.Callback or function() end;

                -- Sub / Group Section
                Folding = properties.Folding or false;
                Collapsable = properties.Collapsing or true;

                Items = {};
            }

            local Items = Cfg.Items; do 
                Items.Toggle = Library:Create( "TextButton" , {
                    Active = false;
                    TextTransparency = 1;
                    Text = "";
                    Parent = self.Items.Elements;
                    AutoButtonColor = false;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    Selectable = false;
                    BorderSizePixel = 0;
                    BorderColor3 = rgb(0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Toggle;
                    Name = "\0";
                    RichText = true;
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")
                
                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Toggle;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Library:Create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = Items.Components;
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                Items.ToggleComponent = Library:Create( "Frame" , {
                    Name = "\0";
                    Parent = Items.Components;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 29, 0, 14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(26, 28, 28)
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.ToggleComponent
                });
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.ToggleComponent;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(24, 24, 27)
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.Inline
                });
                
                Library:Create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(213, 213, 213)), rgbkey(1, rgb(213, 213, 213))};
                    Parent = Items.Inline
                });
                
                Items.Circle = Library:Create( "Frame" , {
                    AnchorPoint = vec2(0, 0.5);
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 2, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 8, 0, 8);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(68, 68, 69)
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.Circle;
                    CornerRadius = dim(0, 999)
                });                
            end;
            
            function Cfg.Set(bool)
                Flags[Cfg.Flag] = bool

                Cfg.Enabled = bool and true or false
                -- A callback error must never leave the switch showing the wrong state.
                local cbOk, cbErr = pcall(Cfg.Callback, bool or false)
                if not cbOk then warn("[Skid Hub] toggle callback error: " .. tostring(cbErr)) end

                Library:Tween(Items.ToggleComponent, {BackgroundColor3 = bool and themes.preset.accent or themes.preset.inline})
                Library:Tween(Items.Inline, {BackgroundColor3 = bool and themes.preset.accent or themes.preset.background})
                Library:Tween(Items.Circle, {BackgroundColor3 = bool and rgb(255, 255, 255) or themes.preset.deselected, Position = bool and dim2(1, -10, 0.5, 0) or dim2(0, 2, 0.5, 0)})                
            end
            
            Items.Toggle.MouseButton1Click:Connect(function()
                Cfg.Enabled = not Cfg.Enabled
                Cfg.Set(Cfg.Enabled)
            end)

            Cfg.Set(Cfg.Enabled)

            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:Slider(properties)
            local Cfg = {
                Name = properties.Name or properties.name or '',
                Suffix = properties.Suffix or properties.suffix or "",
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '',
                Callback = properties.callback or properties.Callback or function() end,

                -- Value Settings
                Min = properties.Min or properties.min or 0,
                Max = properties.Max or properties.max or 100,
                Intervals = properties.Decimal or properties.decimal or 1,
                Value = properties.Default or properties.default or 10,

                -- Other
                Dragging = false,
                Items = {}
            }

            local Items = Cfg.Items; do
                Items.Slider = Library:Create("Frame", {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Title = Library:Create("TextLabel", {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Slider;
                    Name = "\0";
                    RichText = true;
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Library:Themify(Items.Title, "text_color", "BackgroundColor3")

                Items.Components = Library:Create("Frame", {
                    Parent = Items.Slider;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create("UIListLayout", {
                    Parent = Items.Components;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right
                });

                Items.Value = Library:Create("TextLabel", {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.deselected;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = tostring(Cfg.Value);
                    Parent = Items.Components;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Library:Themify(Items.Value, "deselected", "BackgroundColor3")

                Items.Outline = Library:Create("TextButton", {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = Items.Slider;
                    Name = "\0";
                    Position = dim2(0, 0, 0, 21);
                    Size = dim2(1, 0, 0, 7);
                    Selectable = false;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(10, 17, 13)
                });

                Items.Fill = Library:Create("Frame", {
                    Name = "\0";
                    Parent = Items.Outline;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2((Cfg.Value - Cfg.Min)/(Cfg.Max - Cfg.Min), 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                }); Library:Themify(Items.Fill, "accent", "BackgroundColor3")

                Items.Circle = Library:Create("Frame", {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = Items.Fill;
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 11, 0, 11);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                }); Library:Themify(Items.Circle, "accent", "BackgroundColor3")

                Library:Create("UICorner", {
                    Parent = Items.Circle;
                    CornerRadius = dim(0, 999)
                });
            end

            -- MOBILE & UI draggable support
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")

            local function Clamp(val, min, max)
                if val < min then return min end
                if val > max then return max end
                return val
            end

            local function UpdateSliderFromXAbs(x)
                local absPos = Items.Outline.AbsolutePosition
                local absSize = Items.Outline.AbsoluteSize
                local rel = Clamp((x - absPos.X) / absSize.X, 0, 1)
                local steps = (Cfg.Max - Cfg.Min)/Cfg.Intervals
                local steppedValue = math.floor(rel * steps + 0.5) / steps
                local value = Cfg.Min + ((Cfg.Max - Cfg.Min) * steppedValue)
                Cfg.Set(value)
            end

            Items.Outline.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Cfg.Dragging = true
                    if input.UserInputType == Enum.UserInputType.Touch then
                        UpdateSliderFromXAbs(input.Position.X)
                    else
                        local mouse = UserInputService:GetMouseLocation()
                        UpdateSliderFromXAbs(mouse.X)
                    end
                end
            end)

            Items.Outline.MouseButton1Down:Connect(function(x, y)
                Cfg.Dragging = true
                local mouse = UserInputService:GetMouseLocation()
                UpdateSliderFromXAbs(mouse.X)
            end)

            Items.Outline.TouchTap:Connect(function(input)
                Cfg.Dragging = true
                UpdateSliderFromXAbs(input.Position.X)
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Cfg.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    -- mobile and pc support
                    local posX
                    if input.UserInputType == Enum.UserInputType.Touch then
                        posX = input.Position.X
                    else
                        posX = UserInputService:GetMouseLocation().X
                    end
                    UpdateSliderFromXAbs(posX)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Cfg.Dragging = false
                end
            end)


            function Cfg.Set(value)
                Cfg.Value = Library:Round(value, Cfg.Intervals)

                Items.Fill.Size = dim2((Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min), 0, 1, 0)
                Items.Value.Text = tostring(Cfg.Value) .. Cfg.Suffix

                Flags[Cfg.Flag] = Cfg.Value
                Cfg.Callback(Flags[Cfg.Flag])
            end

            local function GetPointerInsideOutline(input)
                -- works for both mouse and touch
                local pos = input.Position
                local abs = Items.Outline.AbsolutePosition
                local size = Items.Outline.AbsoluteSize
                return pos.X >= abs.X and pos.X <= abs.X + size.X
            end
            
            Items.Outline.MouseButton1Down:Connect(function()
                Cfg.Dragging = true 
            end)

            -- Touch support: begin dragging when touching slider
            Items.Outline.TouchTap:Connect(function()
                Cfg.Dragging = true
            end)

            Library:Connection(InputService.InputChanged, function(input)
                if Cfg.Dragging and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then 
                    local Size = (input.Position.X - Items.Outline.AbsolutePosition.X) / Items.Outline.AbsoluteSize.X
                    local Value = ((Cfg.Max - Cfg.Min) * Size) + Cfg.Min
                    Cfg.Set(Value)
                end
            end)

            Library:Connection(InputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Cfg.Dragging = false
                end 
            end)


            Cfg.Set(Cfg.Value)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:Dropdown(properties) 
            local Cfg = {
                Name = properties.Name or properties.name or '';
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '';
                Options = properties.Options or properties.options or properties.items or {""};
                Callback = properties.callback or properties.Callback or function() end;
                Multi = properties.Multi or properties.multi or false;
                Scrolling = properties.Scrolling or properties.scrolling or false;

                -- Ignore these 
                Open = false;
                OptionInstances = {};
                MultiItems = {};
                Items = {};
                Tweening = false;
                Ignore = properties.Ignore or false;
            }   

            Cfg.Default = properties.Default or properties.default or (Cfg.Multi and {Cfg.Items[1]}) or Cfg.Items[1] or "None"
            Flags[Cfg.Flag] = Cfg.Default
            
            local Items = Cfg.Items; do 
                -- Element
                    Items.Dropdown = Library:Create( "Frame" , {
                        Parent = self.Items.Elements;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.text_color;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Parent = Items.Dropdown;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        RichText = true;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")
                    
                    Items.Outline = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = Items.Dropdown;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 21);
                        Size = dim2(1, 0, 0, 20);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Outline, "inline", "BackgroundColor3")
                    
                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(31, 31, 31)
                    });
                    
                    Items.Arrow = Library:Create( "ImageLabel" , {
                        ImageColor3 = rgb(219, 222, 221);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Inline;
                        Name = "\0";
                        AnchorPoint = vec2(0, 0.5);
                        Image = "rbxassetid://70449495580650";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -15, 0.5, 0);
                        Size = dim2(0, 11, 0, 9);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Items.InnerText = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.text_color;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = Items.Inline;
                        Name = "\0";
                        AnchorPoint = vec2(0, 0.5);
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0.5, 1);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.InnerText, "text_color", "BackgroundColor3")                
                -- 
                
                -- Element Holder
                    Items.DropdownElements = Library:Create( "Frame" , {
                        Parent = Library.Other;
                        Size = dim2(0, 211, 0, 20);
                        Name = "\0";
                        Position = dim2(0, 0, 0, 21);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.DropdownElements, "inline", "BackgroundColor3")
                    
                    Items.DropdownHolder = Library:Create( "Frame" , {
                        Parent = Items.DropdownElements;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(31, 31, 31)
                    });
                    
                    Library:Create( "UIListLayout" , {
                        Parent = Items.DropdownHolder;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 2);
                        Parent = Items.DropdownElements
                    });                        
                -- 
            end 

            function Cfg.RenderOption(text)
                local Button = Library:Create( "TextButton" , {
                    Parent = Items.DropdownHolder;
                    AutoButtonColor = false;
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    Name = "\0";
                    TextColor3 = themes.preset.deselected;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 4, 0.5, 1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Button, "deselected", "TextColor3")
                
                Library:Create( "UIPadding" , {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 4);
                    Parent = Button;
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });                   

                table.insert(Cfg.OptionInstances, Button)

                return Button
            end
            
            function Cfg.SetVisible(bool)
                Items.DropdownElements.Position = dim2(0, Items.Outline.AbsolutePosition.X, 0, Items.Outline.AbsolutePosition.Y + 80)
				Items.DropdownElements.Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, 0)
                Items.DropdownElements.Visible = bool 
                Items.DropdownElements.Parent = bool and Library.Items or Library.Other

                Library:Tween(Items.Arrow, {Rotation = bool and 180 or 0})
            end
            
            function Cfg.Set(value)
                local Selected = {}
                local IsTable = type(value) == "table"

                for _,option in Cfg.OptionInstances do 
                    if option.Text == value or (IsTable and table.find(value, option.Text)) then 
                        table.insert(Selected, option.Text)
                        Cfg.MultiItems = Selected
                        option.TextColor3 = themes.preset.text_color
                        option.BackgroundTransparency = 0.95
                    else
                        option.TextColor3 = themes.preset.deselected
                        option.BackgroundTransparency = 1
                    end
                end

                Items.InnerText.Text = if IsTable then table.concat(Selected, ", ") else Selected[1] or ""
                Flags[Cfg.Flag] = if IsTable then Selected else Selected[1]
                
                Cfg.Callback(Flags[Cfg.Flag]) 
            end
            
            function Cfg.RefreshOptions(options) 
                for _,option in Cfg.OptionInstances do 
                    option:Destroy() 
                end
                
                Cfg.OptionInstances = {} 

                for _,option in options do
                    local Button = Cfg.RenderOption(option)
                    
                    Button.MouseButton1Down:Connect(function()
                        if Cfg.Multi then 
                            local Selected = table.find(Cfg.MultiItems, Button.Text)
                            
                            if Selected then 
                                table.remove(Cfg.MultiItems, Selected)
                            else
                                table.insert(Cfg.MultiItems, Button.Text)
                            end
                            
                            Cfg.Set(Cfg.MultiItems) 				
                        else 
                            Cfg.SetVisible(false)
                            Cfg.Open = false
                            
                            Cfg.Set(Button.Text)
                        end
                    end)
                end
            end

            Items.Outline.MouseButton1Click:Connect(function()
                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)

            Library:Connection(InputService.InputBegan, function(input, game_event)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Library:Hovering({Items.DropdownElements, Items.Dropdown}) then
                        Cfg.SetVisible(false)
                        Cfg.Open = false
                    end 
                end 
            end)

            Flags[Cfg.Flag] = {} 
            ConfigFlags[Cfg.Flag] = Cfg.Set
            
            Cfg.RefreshOptions(Cfg.Options)
            Cfg.Set(Cfg.Default)
                
            return setmetatable(Cfg, Library)
        end

        function Library:Label(properties)
            local Cfg = {
                Name = properties.Name or properties.name or "Label",

                -- Other
                Items = {};
            }

            local Items = Cfg.Items; do 
                Items.Label = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Label;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    RichText = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")
                
                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Label;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Library:Create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = Items.Components;
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                        
            end 

            function Cfg.Set(Text)
                Items.Title.Text = Text
            end 

            return setmetatable(Cfg, Library)
        end
        
        function Library:Colorpicker(properties) 
            local Cfg = {
                Name = properties.Name or properties.name or "Color", 
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '' or "Colorpicker",
                Callback = properties.callback or properties.Callback or function() end,

                Color = properties.Color or properties.color or color(1, 1, 1), -- Default to white color if not provided
                Alpha = properties.Alpha or properties.Transparency or properties.alpha or properties.transparency or 0,
                
                -- Other
                Open = false;
                Items = {};
            }
            
            local Picker = self:Keypicker(Cfg)

            local Items = Picker.Items; do
                Cfg.Items = Items
                Cfg.Set = Picker.Set
            end;
            
            Cfg.Set(Cfg.Color, Cfg.Alpha)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

function Library:Textbox(properties) 
    local Cfg = {
        Name = properties.Name or "TextBox",
        PlaceHolder = properties.PlaceHolder or properties.PlaceHolderText or properties.Holder or properties.HolderText or "Type here...",
        Default = properties.Default or "",
        Flag = properties.Flag or properties.Name or "TextBox",
        Callback = properties.Callback or function() end,
        
        Items = {};
    }


            Flags[Cfg.Flag] = Cfg.default

            local Items = Cfg.Items; do 
                Items.Textbox = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    RichText = true;
                    Text = Cfg.Name;
                    Parent = Items.Textbox;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")
                
                Items.Outline = Library:Create( "Frame" , {
                    Parent = Items.Textbox;
                    Name = "\0";
                    Position = dim2(0, 0, 0, 21);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(26, 28, 28)
                });
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(31, 31, 31)
                });
                
Items.Input = Library:Create("TextBox", {
    Parent = Items.Inline;
    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    Name = "\0";
    -- TextBoxes must be active/selectable for touch input and the mobile keyboard.
    Active = true;
    Selectable = true;
    ClearTextOnFocus = false;
    TextEditable = true;
    MultiLine = false;
    BorderColor3 = rgb(0, 0, 0);
    Text = tostring(Cfg.Default or "");
    PlaceholderText = tostring(Cfg.PlaceHolder or "Type here...");
    Size = dim2(1, -6, 1, 0);
    Selectable = true;
    Position = dim2(0, 3, 0, 0);
    BorderSizePixel = 0;
    TextTruncate = Enum.TextTruncate.AtEnd;
    BackgroundTransparency = 1;
    TextXAlignment = Enum.TextXAlignment.Left;
    AutomaticSize = Enum.AutomaticSize.XY;
    TextColor3 = rgb(239, 239, 239);
    TextSize = 14;
    BackgroundColor3 = rgb(255, 255, 255);
});
                  
            end 
            
            function Cfg.Set(text) 
                Flags[Cfg.Flag] = text

                Items.Input.Text = text

                Cfg.Callback(text)
            end 
            
            -- Explicitly focus on tap/click so mobile devices open the native keyboard.
            Items.Input.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                    or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    task.defer(function()
                        if Items.Input and Items.Input.Parent then
                            Items.Input:CaptureFocus()
                        end
                    end)
                end
            end)

            Items.Input:GetPropertyChangedSignal("Text"):Connect(function()
                Cfg.Set(Items.Input.Text) 
            end) 

            if Cfg.default then 
                Cfg.Set(Cfg.default) 
            end

            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end

        function Library:Keybind(properties) 
            local Cfg = {
                Flag = properties.Flag or properties.flag or properties.Name or properties.name or '';
                Callback = properties.callback or properties.Callback or function() end;
                Name = properties.Name or properties.name or nil; 

                Key = properties.Key or nil;
                Mode = properties.Mode or "Toggle";
                Active = properties.Default or properties.default or false; 
                
                Open = false;
                Binding;
                Ignore = false;

                Items = {}
            }

            Flags[Cfg.Flag] = {
                Mode = Cfg.Mode,
                mode = Cfg.Mode,
                Key = Cfg.Key, 
                key = Cfg.Key, 
                Active = Cfg.Active,
                active = Cfg.Active
            }

            local Items = Cfg.Items; do 
                -- Component
                    Items.KeybindOutline = Library:Create( "TextButton" , {
                        Active = false;
                        LayoutOrder = -1;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = self.Items.Components;
                        Name = "\0";
                        Size = dim2(0, 28, 0, 14);
                        Selectable = false;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(26, 28, 28)
                    });
                    
                    Items.ButtonColor = Library:Create( "Frame" , {
                        Parent = Items.KeybindOutline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(31, 31, 31)
                    });
                    
                    Library:Create( "UICorner" , {
                        Parent = Items.ButtonColor;
                        CornerRadius = dim(0, 4)
                    });
                    
                    Items.Key = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.text_color;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = Items.ButtonColor;
                        Name = "\0";
                        TextXAlignment = Enum.TextXAlignment.Center;
                        BackgroundTransparency = 1;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Key, "text_color", "BackgroundColor3")
                    
                    Library:Create( "UIPadding" , {
                        Parent = Items.Key;
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 5);
                        PaddingBottom = dim(0, 2);
                    });
                    
                    Library:Create( "UICorner" , {
                        Parent = Items.KeybindOutline;
                        CornerRadius = dim(0, 4)
                    }); 
                -- 
                
                -- Mode Holder
                    Items.ModeHolder = Library:Create( "TextButton" , {
                        Name = "\0";
                        Text = "";
                        AutoButtonColor = false;
                        Position = dim2(0.5217983722686768, 0, 0.47139304876327515, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 160, 0, 58);
                        Visible = false;
                        Parent = Library.Items;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.visible_backgrounds
                    });	Library:Themify(Items.ModeHolder, "visible_backgrounds", "BackgroundColor3")
                    
                    Items.Elements = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.ModeHolder;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 7, 0, 7);
                        Size = dim2(1, -14, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    Library:Create( "UIListLayout" , {
                        Parent = Items.Elements;
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 15);
                        Parent = Items.Elements
                    });
                    
                    Items.Dropdown = setmetatable(Cfg, Library):Dropdown({Name = "Mode", Options = {"Hold", "Toggle", "Always"}, Flag = Cfg.Flag .. "OPTION_SETTINGS", Callback = function(options)
                        if Cfg.Set then 
                            Cfg.Set(options)
                        end
                    end})
                --
            end 

            function Cfg.SetMode(mode) 
                Cfg.Mode = mode 

                if mode == "Always" then
                    Cfg.Set(true)
                elseif mode == "Hold" then
                    Cfg.Set(false)
                end

                Flags[Cfg.Flag].Mode = mode
            end

            function Cfg.Set(input)
                if type(input) == "boolean" then 
                    Cfg.Active = input

                    if Cfg.Mode == "Always" then 
                        Cfg.Active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    Cfg.Key = input or "NONE"	
                elseif table.find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        Cfg.Active = true 
                    end 

                    Cfg.Mode = input
                    Cfg.SetMode(Cfg.Mode) 
                elseif type(input) == "table" then
                    input.Key = type(input.Key) == "string" and input.Key ~= "NONE" and Library:ConvertEnum(input.key) or input.Key
                    input.Key = input.Key == Enum.KeyCode.Escape and "NONE" or input.Key

                    Cfg.Key = input.Key or "NONE"
                    Cfg.Mode = input.Mode or "Toggle"

                    if input.Active then
                        Cfg.Active = input.Active
                    end

                    Cfg.SetMode(Cfg.Mode) 
                end 

                Cfg.Callback(Cfg.Active)

                local text = (tostring(Cfg.Key) ~= "Enums" and (Keys[Cfg.Key] or tostring(Cfg.Key):gsub("Enum.", "")) or nil)
                local __text = text and tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "")

                Items.Key.Text = " " .. __text .. " "

                if Items.Keybinds then
                    Items.Keybinds.TextTransparency = 1
                    Library:Tween(Items.Keybinds, {TextTransparency = 0})

                    Items.KeybindsStroke.Transparency = 1
                    Library:Tween(Items.KeybindsStroke, {Transparency = 0})

                    Items.Keybinds.Visible = Cfg.Active
                    Items.Keybinds.Text = string.format("[%s]: %s", __text, Cfg.Name or Cfg.Flag or "Key")
                end 

                Flags[Cfg.Flag] = {
                    mode = Cfg.Mode,
                    Mode = Cfg.Mode,
                    key = Cfg.Key, 
                    Key = Cfg.Key,
                    active = Cfg.Active,
                    Active = Cfg.Active
                }
            end

            function Cfg.SetVisible(bool)
                -- Items.Fade.BackgroundTransparency = 0
                -- Library:Tween(Items.Fade, {BackgroundTransparency = 1})

                Items.ModeHolder.Visible = bool 
                Items.ModeHolder.Position = dim2(0, Items.KeybindOutline.AbsolutePosition.X + 2, 0, Items.KeybindOutline.AbsolutePosition.Y + 74)
            end

            Items.KeybindOutline.MouseButton1Down:Connect(function()
                task.wait()
                Items.Key.Text = " ... "	

                Cfg.Binding = Library:Connection(InputService.InputBegan, function(keycode, game_event)  
                    Cfg.Set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    Cfg.Binding:Disconnect() 
                    Cfg.Binding = nil
                end)
            end)

            Items.KeybindOutline.MouseButton2Down:Connect(function()
                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)

            Library:Connection(InputService.InputBegan, function(input, game_event) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Library:Hovering({Items.ModeHolder, Items.Dropdown.Items.DropdownElements}) then 
                        Items.Dropdown.SetVisible(false)
                        Items.Dropdown.Visible = false

                        Cfg.SetVisible(false)
                        Cfg.Open = false;
                    end 
                end 

                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == Cfg.Key then 
                        if Cfg.Mode == "Toggle" then 
                            Cfg.Active = not Cfg.Active
                            Cfg.Set(Cfg.Active)
                        elseif Cfg.Mode == "Hold" then 
                            Cfg.Set(true)
                        end
                    end
                end
            end)    

            Library:Connection(InputService.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == Cfg.Key then
                    if Cfg.Mode == "Hold" then 
                        Cfg.Set(false)
                    end
                end
            end)
            
            Cfg.Set({Mode = Cfg.Mode, Active = Cfg.Active, Key = Cfg.Key})           
            ConfigFlags[Cfg.Flag] = Cfg.Set
            Items.Dropdown.Set(Cfg.Mode)

            return setmetatable(Cfg, Library)
        end
        
        function Library:Button(properties) 
            local Cfg = {
                Name = properties.Name or properties.name or "TextBox",
                Callback = properties.callback or properties.Callback or function() end,
                 
                -- Other
                Items = {};
            }
            
            local Items = Cfg.Items; do 
                Items.Button = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Items.Outline = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Name = "\0";
                    Parent = Items.Button;
                    Size = dim2(1, 0, 0, 20);
                    Selectable = false;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(26, 28, 28)
                });
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(31, 31, 31)
                });
                
                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    RichText = true;
                    Text = Cfg.Name;
                    Parent = Items.Inline;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")                                          
            end 

            Items.Outline.MouseButton1Click:Connect(function()
                Items.Title.TextColor3 = rgb(255, 255, 255)
                Library:Tween(Items.Title, {TextColor3 = themes.preset.text_color})
                
                Cfg.Callback()
            end)
            
            return setmetatable(Cfg, Library)
        end

        function Library:Configs(window) 
            local Text;
            local Tab = window:Tab({
                name = "Settings",
                icon = "http://www.roblox.com/asset/?id=6031280882"
            })

            local Section = Tab:Section({Name = "Main", Side = "Left"})
            ConfigHolder = Section:Dropdown({Name = "Configs", Options = {}, Callback = function(option) if Text then Text.Set(option) end end, Flag = "config_Name_list"}); Library:UpdateConfigList()
            Section:Textbox({Name = "Config Name:", Flag = "config_Name_text", default = ""})
            Section:Button({Name = "Save", Callback = function() if Flags["config_Name_text"] == "" then return end writefile(Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg", Library:GetConfig()) Library:UpdateConfigList() Notifications:Create({Name = "Saved Config (" ..  Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg" .. ")"}) end})
            Section:Button({Name = "Load", Callback = function() if Flags["config_Name_text"] == "" then return end Library:LoadConfig(readfile(Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg")) Library:UpdateConfigList() Notifications:Create({Name = "Loaded Config (" ..  Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg" .. ")"}) end})
            Section:Button({Name = "Delete", Callback = function() if Flags["config_Name_text"] == "" then return end delfile(Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg") Library:UpdateConfigList() Notifications:Create({Name = "Deleted Config (" ..  Library.Directory .. "/configs/" .. Flags["config_Name_text"] .. ".cfg" .. ")"}) end})

            local Section = Tab:Section({Name = "Other", Side = "Right"})
            Section:Label({Name = "Accent Color"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("accent", color) end, Color = themes.preset.accent})
            Section:Label({Name = "Window Outline"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("window_outline", color) end, Color = themes.preset.window_outline})
            Section:Label({Name = "Inline Elements"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("inline", color) end, Color = themes.preset.inline})
            Section:Label({Name = "Main Background"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("background", color) end, Color = themes.preset.background})
            Section:Label({Name = "Visible Backgrounds"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("visible_backgrounds", color) end, Color = themes.preset.visible_backgrounds})
            Section:Label({Name = "Text Color"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("text_color", color) end, Color = themes.preset.text_color})
            Section:Label({Name = "Glow Effect"}):Colorpicker({Callback = function(color, alpha)Library:RefreshTheme("glow", color)end,Color = themes.preset.glow})
            Section:Label({Name = "Deselected Elements"}):Colorpicker({Callback = function(color, alpha) Library:RefreshTheme("deselected", color) end, Color = themes.preset.deselected})

            window.Tweening = true
            Section:Label({Name = "Menu Bind"}):Keybind({Name = "Menu Bind", Callback = function(bool) 
                if window.Tweening then
                    return 
                end 

                window.ToggleMenu(bool) 
            end, Default = true})

            delay(2, function() window.Tweening = false end)
        end
    --

        function Library:ChristmasDecorate(window)
            if Library.Christmas == false then return end

            local ok, err = pcall(function()
                local Items = window.Items
                local Win = Items.Window
                local rng = Random.new()
                local mobile = InputService.TouchEnabled
                local font = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                local GLOW_IMAGE = "rbxassetid://18245826428"

                local RED, GREEN, GOLD, BLUE, PINK = rgb(255, 70, 85), rgb(70, 235, 140), rgb(255, 214, 110), rgb(90, 170, 255), rgb(255, 130, 200)
                local WHITE, ICE, INK = rgb(255, 255, 255), rgb(206, 226, 246), rgb(46, 24, 34)
                local bulbColors = {RED, GOLD, GREEN, BLUE, PINK}
                local PX = 3                      -- screen pixels per art pixel
                local bleed = mobile and 1 or 0   -- hides hairline seams when the menu is scaled down

                -- Pixel art. Each string is one row, each character one art pixel ('.' = empty).
                local ART = {
                    santaBase = {
                        ".......KKKKKK.............",
                        ".....KKRRRRRRKK...........",
                        "....KRRhRRRRRRRK..........",
                        "...KRRhRRRRRRRRRK.........",
                        "...KRRRRRRRRRRRRRK.KKK....",
                        "..KRRRRRRRRRRRRRRrKWWWK...",
                        "..KRRRRRRRRRRRRRrrKWWWK...",
                        ".KWWWWWWWWWWWWWWWWKwwwK...",
                        "KWWWWWWWWWWWWWWWWWWKKK....",
                        "KWwwwwwwwwwwwwwwwwwK......",
                        ".KKSSSSSSSSSSSSSSKK.......",
                        "..KSSSSSSSSSSSSSSsK.......",
                        "..KSSEESSSSSSEESSsK.......",
                        "..KSSEESSSSSSEESSsK.......",
                        ".KWPPSSSSNNSSSSPPWK.......",
                        ".KWWPSSSNNNNSSSPWWK.......",
                        "KWWWWWWWSNNSWWWWWWWK......",
                        "KWWWWWWWWWWWWWWWWWwK......",
                        "KWWWWWWWKKKKWWWWWWwK......",
                        ".KWWWWWWWWWWWWWWWwK.......",
                        ".KwWWWWWWWWWWWWWwwK.......",
                        "KRKwWWWWWWWWWWWwwK........",
                        "KRRKwwWWWWWWWWwwKK........",
                        "KRRRKKwwwwwwwwKKK.........",
                        "KMMRRRKKKKKKKKRRRK........",
                        "KMMKBBBBBGGBBBBBK.........",
                        ".KKKRRRRBGGBRRRRK.........",
                        "...KWWWWWWWWWWWWK.........",
                        "..KBBbBBBK.KBBbBBBK.......",
                        "..KKKKKKKK.KKKKKKKK.......",
                    },
                    santaArmDown = {
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..................RK......",
                        ".................RRK......",
                        "................RRRK......",
                        ".................MMK......",
                        ".................MMK......",
                        ".................KK.......",
                        "..........................",
                        "..........................",
                        "..........................",
                    },
                    santaArmUp1 = {
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        ".....................KK...",
                        "....................KMMK..",
                        "....................KMMK..",
                        "....................KRRK..",
                        "....................KRRK..",
                        "...................KRRRK..",
                        "..................RRRRK...",
                        "..................RRRK....",
                        ".................RRK......",
                        ".................K........",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                    },
                    santaArmUp2 = {
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "......................KK..",
                        ".....................KMMK.",
                        ".....................KMMK.",
                        "....................KRRK..",
                        "....................KRRK..",
                        "....................KRRK..",
                        "...................KRRRK..",
                        "..................RRRRK...",
                        "..................RRRK....",
                        ".................RRK......",
                        ".................K........",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                    },
                    santaBlink = {
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        ".....SS......SS...........",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                    },
                    santaMouth = {
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "........KKKK..............",
                        "........KmmK..............",
                        ".........KK...............",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                        "..........................",
                    },
                    tree = {
                        ".................................",
                        ".................................",
                        ".................................",
                        ".................................",
                        "...............KKK...............",
                        "..............KgWdK..............",
                        ".............KlWWWDK.............",
                        "............KlglggddK............",
                        "............KlllgdddK............",
                        "...........KlglgggddDK...........",
                        "...........Kll1gdgdddK...........",
                        "..........KWWllgggoDWWK..........",
                        "..........KlllldolgdddK..........",
                        ".........KWWWWogggdWWWWK.........",
                        ".........Kwwllggggl2dwwK.........",
                        "........KWWlllgggdgdddWWK........",
                        ".........KKllglggggdDdKK.........",
                        ".........Kll3llgdggddddK.........",
                        ".........KWWgllggggDdWWK.........",
                        "........Klolllgdgg4dddDdK........",
                        "........KllgologggddddddK........",
                        ".......KlllllldgogggdDdddK.......",
                        ".......KWWglllgggdogoddWWK.......",
                        "......KllllllgggglggDd1dodK......",
                        "......KWW2WlllggdgggddWWWWK......",
                        ".....KwwllllggggggldgddddwwK.....",
                        ".....KWWglllllgdgggggdDddWWK.....",
                        "......KKlllgllggggdldddddKK......",
                        "......KWWllllld3ggggdDddWWK......",
                        "......KlllglllgggdggddddDdK......",
                        ".....Kg4llllldglggggddddddoK.....",
                        ".....KlllglllgggdggggddD2ddK.....",
                        ".....KWWllllgggglgodododdWWK.....",
                        "....KlllgllllggdoggggdDdddddK....",
                        "....KlllllogogoggldggddddDddK....",
                        "...Klllgollllgdgggg4gDddddddDK...",
                        "...KWWolllg1lggggdlggdddDddWWK...",
                        "..Kll2glllllldggggggdgdddd3DddK..",
                        "..KWWWWllglllgggdgglggdDddWWWWK..",
                        ".KwwlglllllldglggggdggddddDddwwK.",
                        ".KWWKllKglKlgKgdgggKlgKddKddKWWK.",
                        "..KK.KK.KK.KKKTTTttKKK.KK.KK.KK..",
                        ".............KTTTttK.............",
                        ".............KTTTttK.............",
                        ".............KTTTttK.............",
                        ".............KTTTttK.............",
                        "..............KKKKK..............",
                    },
                    star = {
                        ".....g.....",
                        "....gYg....",
                        "....gYg....",
                        ".gggYyYggg.",
                        "gYYYYyYYYYg",
                        ".gYYyyyYYg.",
                        "..gYYyYYg..",
                        "..gYYYYYg..",
                        ".gYYYgYYYg.",
                        ".gYgg.ggYg.",
                        "..g.....g..",
                    },
                    mound = {
                        "..............WiWWWWiWWWWiWWWWi..............",
                        "........WWiWWWWWWWWWWWWWWWWWWWWWWWWiW........",
                        "....WiWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWi....",
                        "..WWWWWWwwwwwwwwwwwwwwwwwwwwwwwwwwwwwWWWWWW..",
                        ".WwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwW.",
                        "iwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwW",
                    },
                    moundSmall = {
                        "..........iWWWWiWWWWiWWWWiWWWW..........",
                        "....WiWWWWWWWWWWWWWWWWWWWWWWWWiWWWWi....",
                        ".WWWwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwWWW.",
                        "iwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwW",
                    },
                    giftA = {
                        "..YY.YY..",
                        ".Y..Y..Y.",
                        "..YYYYY..",
                        "KKKKYKKKK",
                        "KAAAYAAAK",
                        "KYYYYYYYK",
                        "KAAAYAAAK",
                        "KaaaYaaaK",
                        "KKKKKKKKK",
                    },
                    giftB = {
                        "....YY.YY....",
                        "...Y.YYY.Y...",
                        "KKKKKKYKKKKKK",
                        "KAAAAAYAAAAAK",
                        "KAAAAAYAAAAAK",
                        "KaaaaaYaaaaaK",
                        "KKKKKKKKKKKKK",
                    },
                    giftC = {
                        "..Y.Y..",
                        "...Y...",
                        "KKKYKKK",
                        "KAAYAAK",
                        "KAAYAAK",
                        "KAAYAAK",
                        "KYYYYYK",
                        "KAAYAAK",
                        "KaaYaaK",
                        "KKKKKKK",
                    },
                    bow = {
                        "KK.....KK",
                        "KRK...KRK",
                        "KRRKKKRRK",
                        "KRRRrRRRK",
                        "KRRKrKRRK",
                        "KRK.r.KRK",
                        "KK.KrK.KK",
                        "..KrKrK..",
                        "..KK.KK..",
                    },
                    deerBody = {
                        "..............a.a..a.a..",
                        "..............aaa..aaa..",
                        "...............a....a...",
                        "...............aKKKKa...",
                        "..............KKBBBBKK..",
                        "..............bBBBBEBBK.",
                        "..............KBBBBBBcNN",
                        "...............KBBBccNN.",
                        "...............KBBBKKK..",
                        "..KKKKKKKKKKKKKRRRRK....",
                        ".KBBBBBBBBBBBBBRGGRK....",
                        "WKBBBBBBBBBBBBBBRRBK....",
                        "WKBBBBBBBBBBBBBBBBBK....",
                        ".KbBBBBBBBBBBBBBBBBK....",
                        ".KbbccccccccccccBBK.....",
                        "..KKKKKKKKKKKKKKKK......",
                    },
                    deerLegsA = {
                        ".KbK.KbK.....KbKKbK.....",
                        "KbK.KbK.......KbKKbK....",
                        "KbK.KbK........KbKKbK...",
                        "KHK.KHK.........KHKKHK..",
                        "KKK.KKK.........KKKKKK..",
                        "........................",
                    },
                    deerLegsB = {
                        "...KbKKbK...KbKKbK......",
                        "....KbKKbK.KbKKbK.......",
                        ".....KbKKHKHKKbK........",
                        ".....KHKKKKKKKHK........",
                        ".....KKK.....KKK........",
                        "........................",
                    },
                    sleigh = {
                        "....KKKK......................",
                        "...KOOOOK.....KKKK............",
                        "..KOOoOOOK..KKRRRRK...........",
                        "..KOOOOOOK.KWKRRRRRK..........",
                        "..KOOOOOOK.KKWWWWWWWK.........",
                        "..KOOOOOOK...KSSSESK..........",
                        "..KOoOOOOK...KWWSSNK..........",
                        "KK.KOOOOOK...KWWWWWK.....KKK..",
                        "KRKKOOOOOKKKKRWWWWRKK...KRRRK.",
                        "KRRKKKKKKKRRRRRWWRRMMK.KRRKRK.",
                        "KRRRRRRRRRRRRRRRRRKKKKKRRKKKK.",
                        "KRRRRRRRRRRRRRRRRRRRRRRRRK....",
                        "KGGGGGGGGGGGGGGGGGGGGGGGGK....",
                        "KRRRRRRRRRRRRRRRRRRRRRRRK.....",
                        ".KrrrrrrrrrrrrrrrrrrrrrK......",
                        "..KKKKKKKKKKKKKKKKKKKKK.......",
                        "....KgK.........KgK...........",
                        "....KgK.........KgK.......KKK.",
                        ".KKKKgKKKKKKKKKKKgKKKKKKKKKGGK",
                        "KGGGGGGGGGGGGGGGGGGGGGGGGGGKKG",
                        ".KKKKKKKKKKKKKKKKKKKKKKKKKK.K.",
                    },
                }

                local PAL = {
                    santa = {["K"] = rgb(46, 24, 34), ["R"] = rgb(214, 44, 58), ["r"] = rgb(158, 26, 46), ["h"] = rgb(246, 110, 110), ["W"] = rgb(255, 255, 255), ["w"] = rgb(204, 216, 234), ["S"] = rgb(255, 208, 172), ["s"] = rgb(232, 170, 138), ["P"] = rgb(246, 150, 150), ["N"] = rgb(228, 108, 100), ["E"] = rgb(44, 32, 44), ["G"] = rgb(255, 210, 92), ["B"] = rgb(48, 44, 58), ["b"] = rgb(98, 92, 112), ["M"] = rgb(60, 176, 104), ["m"] = rgb(128, 30, 44)},
                    tree = {["K"] = rgb(10, 44, 30), ["l"] = rgb(64, 190, 106), ["g"] = rgb(38, 152, 84), ["d"] = rgb(26, 116, 66), ["D"] = rgb(18, 86, 52), ["W"] = rgb(255, 255, 255), ["w"] = rgb(206, 224, 244), ["T"] = rgb(132, 86, 52), ["t"] = rgb(98, 62, 40), ["o"] = rgb(255, 214, 110), ["1"] = rgb(255, 70, 85), ["2"] = rgb(255, 214, 110), ["3"] = rgb(90, 170, 255), ["4"] = rgb(255, 130, 200)},
                    star = {["Y"] = rgb(255, 214, 96), ["y"] = rgb(255, 246, 190), ["g"] = rgb(196, 136, 36)},
                    mound = {["W"] = rgb(255, 255, 255), ["w"] = rgb(208, 226, 246), ["i"] = rgb(232, 242, 255)},
                    giftR = {["K"] = rgb(60, 14, 24), ["A"] = rgb(222, 52, 66), ["a"] = rgb(170, 30, 48), ["Y"] = rgb(255, 214, 96)},
                    giftG = {["K"] = rgb(10, 50, 32), ["A"] = rgb(48, 170, 96), ["a"] = rgb(30, 126, 72), ["Y"] = rgb(255, 80, 92)},
                    giftB = {["K"] = rgb(16, 36, 80), ["A"] = rgb(78, 150, 240), ["a"] = rgb(52, 108, 196), ["Y"] = rgb(255, 255, 255)},
                    giftY = {["K"] = rgb(96, 60, 10), ["A"] = rgb(255, 206, 90), ["a"] = rgb(220, 160, 50), ["Y"] = rgb(222, 52, 66)},
                    bow = {["K"] = rgb(70, 12, 24), ["R"] = rgb(226, 50, 64), ["r"] = rgb(150, 24, 42)},
                    deer = {["K"] = rgb(52, 30, 22), ["B"] = rgb(160, 106, 64), ["b"] = rgb(116, 76, 46), ["c"] = rgb(222, 188, 146), ["a"] = rgb(206, 170, 120), ["E"] = rgb(30, 22, 26), ["N"] = rgb(60, 40, 36), ["W"] = rgb(255, 255, 255), ["R"] = rgb(214, 44, 58), ["G"] = rgb(255, 210, 92), ["H"] = rgb(40, 32, 36)},
                    sleigh = {["K"] = rgb(46, 24, 34), ["R"] = rgb(214, 44, 58), ["r"] = rgb(158, 26, 46), ["G"] = rgb(255, 210, 92), ["g"] = rgb(200, 144, 44), ["O"] = rgb(150, 100, 62), ["o"] = rgb(190, 138, 90), ["W"] = rgb(255, 255, 255), ["S"] = rgb(255, 208, 172), ["E"] = rgb(44, 32, 44), ["N"] = rgb(228, 108, 100), ["M"] = rgb(60, 176, 104)},
                }

                local giftPals = {PAL.giftR, PAL.giftG, PAL.giftB, PAL.giftY}

                local state = {
                    snow = true, snowAmount = 0.7,
                    lights = true, lightMode = "Twinkle", lightSpeed = 1,
                    trees = true, santa = true,
                    autoFly = true, flyInterval = 14,
                }

                -- Every decoration lives under an "XmasDecor" layer so the menu fade can skip it.
                local roots, shown = {}, true

                local function applyVisibility()
                    for _, r in ipairs(roots) do
                        r.obj.Visible = shown and (r.key == nil or state[r.key] == true)
                    end
                end

                local function layer(parent, props, key)
                    local f = Library:Create("Frame", {
                        Parent = parent; Name = "XmasDecor"; BackgroundTransparency = 1; BorderSizePixel = 0;
                    })
                    for k, v in pairs(props) do
                        f[k] = v
                    end
                    roots[#roots + 1] = {obj = f, key = key}
                    return f
                end

                Library.XmasSetShown = function(bool)
                    shown = bool
                    applyVisibility()
                end

                local function box(parent, pos, size, col, z)
                    return Library:Create("Frame", {
                        Parent = parent; Name = "\0"; BackgroundColor3 = col; BorderSizePixel = 0;
                        Position = pos; Size = size; ZIndex = z or 1;
                    })
                end

                -- Soft round glow made of stacked translucent discs (no image, so no box around the art).
                local GLOW_K = {0.16, 0.22, 0.3}
                local function setGlow(g, transp)
                    local a = 1 - transp
                    for i, ring in ipairs(g.rings) do
                        ring.BackgroundTransparency = 1 - a * GLOW_K[i]
                    end
                end

                local function glow(parent, cx, cy, size, col, transp, z, height)
                    local root = Library:Create("Frame", {
                        Parent = parent; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                        AnchorPoint = vec2(0.5, 0.5); Position = dim_offset(cx, cy); Size = dim_offset(size, height or size); ZIndex = z or 1;
                    })
                    local g = {root = root, rings = {}}
                    for i, s in ipairs({1, 0.66, 0.36}) do
                        local ring = box(root, dim2(0.5, 0, 0.5, 0), dim2(s, 0, s, 0), col, z or 1)
                        ring.AnchorPoint = vec2(0.5, 0.5)
                        Library:Create("UICorner", {Parent = ring; CornerRadius = dim(1, 0)})
                        g.rings[i] = ring
                    end
                    setGlow(g, transp)
                    return g
                end

                -- Draws a sprite, merging equal neighbouring pixels into as few frames as possible.
                local function sprite(parent, rows, pal, opts)
                    opts = opts or {}
                    local px = opts.px or PX
                    local h, w = #rows, #rows[1]
                    local z = opts.z or 1
                    local single = opts.single
                    local holder = Library:Create("Frame", {
                        Parent = parent; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                        Position = dim_offset((opts.x or 0) * px, (opts.y or 0) * px);
                        Size = dim_offset(w * px, h * px); ZIndex = z;
                    })
                    local used, marks = {}, {}

                    for y = 1, h do
                        local row = rows[y]
                        local x = 1
                        while x <= w do
                            local ch = string.sub(row, x, x)
                            local col = pal[ch]
                            if col == nil or used[(y - 1) * w + x] then
                                x = x + 1
                            else
                                local run, tall = 1, 1
                                local solo = single ~= nil and single[ch] == true
                                if not solo then
                                    while x + run <= w and string.sub(row, x + run, x + run) == ch and not used[(y - 1) * w + x + run] do
                                        run = run + 1
                                    end
                                    local grow = true
                                    while grow and y + tall <= h do
                                        local nrow = rows[y + tall]
                                        for k = 0, run - 1 do
                                            if string.sub(nrow, x + k, x + k) ~= ch or used[(y + tall - 1) * w + x + k] then
                                                grow = false
                                                break
                                            end
                                        end
                                        if grow then
                                            tall = tall + 1
                                        end
                                    end
                                    for dy = 0, tall - 1 do
                                        for k = 0, run - 1 do
                                            used[(y + dy - 1) * w + x + k] = true
                                        end
                                    end
                                end
                                local dx = opts.flip and (w - (x - 1) - run) or (x - 1)
                                local f = box(holder, dim_offset(dx * px, (y - 1) * px), dim_offset(run * px + bleed, tall * px + bleed), col, z)
                                if solo then
                                    marks[#marks + 1] = {obj = f, ch = ch, cx = dx * px + px / 2, cy = (y - 1) * px + px / 2}
                                end
                                x = x + run
                            end
                        end
                    end

                    return holder, marks
                end

                -- Shared light registry: garland bulbs and tree ornaments all follow the same pattern.
                local lights = {}
                local function addLight(obj, halo, col)
                    local i = #lights + 1
                    lights[i] = {
                        obj = obj, halo = halo, col = col, dark = col:Lerp(rgb(8, 14, 11), 0.74), i = i,
                        phase = rng:NextNumber(0, 6.28), rate = rng:NextNumber(1.6, 3.4),
                    }
                end

                ---------------------------------------------------------------- title bar
                if Items.SectionTitle and window.Prefix == "inferno." then
                    Items.SectionTitle.Text = '<font color="rgb(255,255,255)">christmas.</font>update'
                end

                local caneRows = {}
                if Items.TitleHolder then
                    -- Candy-cane rule under the title: two offset rows of blocks read as a diagonal stripe.
                    local cane = layer(Items.TitleHolder, {
                        Position = dim2(0, 0, 1, -6); Size = dim2(1, 0, 0, 6); ClipsDescendants = true;
                        BackgroundTransparency = 0; BackgroundColor3 = WHITE; ZIndex = 5;
                    })
                    for r = 0, 1 do
                        local strip = Library:Create("Frame", {
                            Parent = cane; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                            Position = dim_offset(0, r * 3); Size = dim_offset(2040, 3); ZIndex = 5;
                        })
                        for i = 0, 84 do
                            box(strip, dim_offset(i * 24, 0), dim_offset(12, 3), rgb(226, 50, 64), 5)
                        end
                        caneRows[#caneRows + 1] = {obj = strip, shift = r * 3}
                    end

                    local countdown = Library:Create("TextLabel", {
                        Parent = Items.TitleHolder; Name = "\0"; BackgroundTransparency = 1;
                        AnchorPoint = vec2(1, 0.5); Position = dim2(1, -12, 0.5, -1);
                        AutomaticSize = Enum.AutomaticSize.XY; TextSize = 13; ZIndex = 2;
                        TextColor3 = themes.preset.text_color; FontFace = font; Text = "";
                    }); Library:Themify(countdown, "text_color", "TextColor3")

                    local function refresh()
                        local now = os.time()
                        local d = os.date("*t", now)
                        if d.month == 12 and d.day == 25 then
                            countdown.Text = "Merry Christmas!"
                            return
                        end
                        local target = os.time({year = d.year, month = 12, day = 25, hour = 0})
                        if target <= now then
                            target = os.time({year = d.year + 1, month = 12, day = 25, hour = 0})
                        end
                        local left = target - now
                        countdown.Text = string.format("%dd %02dh until Christmas", math.floor(left / 86400), math.floor((left % 86400) / 3600))
                    end

                    task.spawn(function()
                        while Win.Parent do
                            refresh()
                            task.wait(30)
                        end
                    end)
                end

                ---------------------------------------------------------------- window glow + border
                if Items.Glow then
                    Items.Glow.Size = dim2(1, 60, 1, 60)
                    Items.Glow.Position = dim2(0, -30, 0, -30)
                end

                local outer = Library:Create("ImageLabel", {
                    Parent = Win; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                    Position = dim2(0, -60, 0, -60); Size = dim2(1, 120, 1, 120);
                    Image = GLOW_IMAGE; ImageColor3 = GOLD; ImageTransparency = 0.84;
                    ScaleType = Enum.ScaleType.Slice; SliceCenter = rect(vec2(21, 21), vec2(79, 79)); ZIndex = 0;
                })

                local border = Library:Create("UIStroke", {Parent = Win; Color = RED; Thickness = 2; Transparency = 0.15})
                local cycle = {RED, GOLD, GREEN}

                ---------------------------------------------------------------- snow resting on the window
                local glints = {}
                do
                    local cap = layer(Win, {Position = dim2(0, -4, 0, 0); Size = dim2(1, 8, 0, 0); ZIndex = 24})
                    local N = 72
                    for i = 0, N - 1 do
                        local fromEdge = math.min(i, N - 1 - i)
                        local h = 7 + 3 * math.sin(i * 0.55) + 2 * math.sin(i * 1.37 + 1.3) + 1.5 * math.sin(i * 0.21 + 4)
                        h = math.min(h, 2 + fromEdge * 2.2)
                        h = math.max(2, math.floor(h / 2 + 0.5) * 2)
                        local drip = math.floor((1.5 + 2 * math.sin(i * 0.9 + 2) + 1.2 * math.sin(i * 2.3)) / 2 + 0.5) * 2
                        drip = math.clamp(drip, 0, 4)

                        local col = box(cap, dim2(i / N, 0, 0, -h), dim2(1 / N, 1, 0, h + drip), WHITE, 24)
                        box(col, dim2(0, 0, 1, -2), dim2(1, 0, 0, 2), ICE, 25)
                        if h >= 8 then
                            box(col, dim2(0, 0, 0, 2), dim2(1, 0, 0, 2), rgb(238, 246, 255), 25)
                        end

                        if i % 7 == 3 and fromEdge > 2 then
                            local len = rng:NextInteger(2, 3) * 2
                            local ice = box(cap, dim2((i + 0.5) / N, 0, 0, drip), dim_offset(4, len), rgb(186, 222, 250), 23)
                            ice.AnchorPoint = vec2(0.5, 0)
                            ice.BackgroundTransparency = 0.1
                            local tip = box(ice, dim2(0.5, 0, 1, 0), dim_offset(2, 3), rgb(214, 238, 255), 23)
                            tip.AnchorPoint = vec2(0.5, 0)
                            tip.BackgroundTransparency = 0.1
                        end
                    end

                    for i = 1, 4 do
                        local g = box(cap, dim2(0.5, 0, 0, -4), dim_offset(0, 0), WHITE, 27)
                        g.AnchorPoint = vec2(0.5, 0.5)
                        g.Rotation = 45
                        g.Visible = false
                        glints[i] = {obj = g, t0 = i * 0.7, dur = 0.7}
                    end
                end

                ---------------------------------------------------------------- string lights under the window
                do
                    local garland = layer(Win, {Position = dim2(0, 0, 1, 0); Size = dim2(1, 0, 0, 0); ZIndex = 22}, "lights")
                    local SWAGS, SEG = 6, 24
                    local n = 0
                    for s = 0, SWAGS - 1 do
                        for k = 0, SEG - 1 do
                            local u = (k + 0.5) / SEG
                            local sag = math.floor(4 * u * (1 - u) * 16 / 2 + 0.5) * 2
                            box(garland, dim2((s + k / SEG) / SWAGS, 0, 0, sag), dim2(1 / (SWAGS * SEG), 1, 0, 2), rgb(22, 74, 46), 22)

                            if k % 4 == 2 then
                                n = n + 1
                                local col = bulbColors[(n - 1) % #bulbColors + 1]
                                local fx = (s + u) / SWAGS
                                local halo = glow(garland, 0, 0, 30, col, 0.5, 21)
                                halo.root.Position = dim2(fx, 0, 0, sag + 10)
                                local socket = box(garland, dim2(fx, 0, 0, sag + 2), dim_offset(4, 3), rgb(58, 70, 62), 23)
                                socket.AnchorPoint = vec2(0.5, 0)
                                local bulb = box(garland, dim2(fx, 0, 0, sag + 5), dim_offset(8, 10), col, 23)
                                bulb.AnchorPoint = vec2(0.5, 0)
                                Library:Create("UICorner", {Parent = bulb; CornerRadius = dim(0, 4)})
                                local shine = box(bulb, dim_offset(2, 2), dim_offset(2, 2), WHITE, 24)
                                shine.BackgroundTransparency = 0.3
                                addLight(bulb, halo, col)
                            end
                        end
                    end

                    for s = 0, SWAGS do
                        local bow = sprite(garland, ART.bow, PAL.bow, {px = 2, z = 25})
                        bow.AnchorPoint = vec2(0.5, 0)
                        bow.Position = dim2(s / SWAGS, 0, 0, -6)
                    end

                    -- strands down both sides, stopping above the trees
                    local SIDE_SWAGS, SIDE_SEG, SPAN, TOP = 3, 16, 0.6, 0.03
                    for _, side in ipairs({-1, 1}) do
                        local strand = layer(Win, {Position = dim2(side < 0 and 0 or 1, 0, 0, 0); Size = dim2(0, 0, 1, 0); ZIndex = 22}, "lights")
                        for s = 0, SIDE_SWAGS - 1 do
                            for k = 0, SIDE_SEG - 1 do
                                local u = (k + 0.5) / SIDE_SEG
                                local sag = math.floor(4 * u * (1 - u) * 12 / 2 + 0.5) * 2
                                local fy = TOP + (s + k / SIDE_SEG) / SIDE_SWAGS * SPAN
                                box(strand, dim2(0, side < 0 and (-sag - 2) or sag, fy, 0), dim2(0, 2, SPAN / (SIDE_SWAGS * SIDE_SEG), 1), rgb(22, 74, 46), 22)

                                if k % 4 == 2 then
                                    n = n + 1
                                    local col = bulbColors[(n - 1) % #bulbColors + 1]
                                    local by = TOP + (s + u) / SIDE_SWAGS * SPAN
                                    local anchor = vec2(side < 0 and 1 or 0, 0.5)
                                    local halo = glow(strand, 0, 0, 30, col, 0.5, 21)
                                    halo.root.Position = dim2(0, side * (sag + 10), by, 0)
                                    local socket = box(strand, dim2(0, side * (sag + 2), by, 0), dim_offset(3, 4), rgb(58, 70, 62), 23)
                                    socket.AnchorPoint = anchor
                                    local bulb = box(strand, dim2(0, side * (sag + 5), by, 0), dim_offset(10, 8), col, 23)
                                    bulb.AnchorPoint = anchor
                                    Library:Create("UICorner", {Parent = bulb; CornerRadius = dim(0, 4)})
                                    local shine = box(bulb, dim_offset(side < 0 and 2 or 6, 2), dim_offset(2, 2), WHITE, 24)
                                    shine.BackgroundTransparency = 0.3
                                    addLight(bulb, halo, col)
                                end
                            end
                        end
                        for s = 0, SIDE_SWAGS do
                            local bow = sprite(strand, ART.bow, PAL.bow, {px = 2, z = 25})
                            bow.AnchorPoint = vec2(0.5, 0.5)
                            bow.Position = dim2(0, 0, TOP + s / SIDE_SWAGS * SPAN, 0)
                        end
                    end
                end

                ---------------------------------------------------------------- trees
                local stars = {}
                local function buildTree(side)
                    local t = layer(Win, {
                        AnchorPoint = vec2(side < 0 and 1 or 0, 1);
                        Position = dim2(side < 0 and 0 or 1, side * 8, 1, 10);
                        Size = dim_offset(45 * PX, 54 * PX); ZIndex = 26;
                    }, "trees")
                    local ox = 6 * PX

                    glow(t, 22.5 * PX, 30 * PX, 250, GREEN, 0.9, 1)

                    local pine, marks = sprite(t, ART.tree, PAL.tree, {z = 2, single = {["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true}})
                    pine.Position = dim_offset(ox, 5 * PX)
                    for _, m in ipairs(marks) do
                        local col = PAL.tree[m.ch]
                        local halo = glow(pine, m.cx, m.cy, 24, col, 0.5, 3)
                        addLight(m.obj, halo, col)
                    end

                    local sx, sy = ox + 16.5 * PX, 5.5 * PX
                    local starGlow = glow(t, sx, sy, 80, GOLD, 0.5, 3)
                    local star = sprite(t, ART.star, PAL.star, {z = 4})
                    star.Position = dim_offset(ox + 11 * PX, 0)
                    local rayH = box(t, dim_offset(sx, sy), dim_offset(20, 2), WHITE, 5)
                    local rayV = box(t, dim_offset(sx, sy), dim_offset(2, 20), WHITE, 5)
                    rayH.AnchorPoint = vec2(0.5, 0.5)
                    rayV.AnchorPoint = vec2(0.5, 0.5)
                    stars[#stars + 1] = {glow = starGlow, h = rayH, v = rayV, phase = side}

                    local mound = sprite(t, ART.mound, PAL.mound, {z = 6})
                    mound.Position = dim_offset(0, 48 * PX)

                    local a = sprite(t, ART.giftA, side < 0 and PAL.giftR or PAL.giftY, {z = 7})
                    a.Position = dim_offset(2 * PX, 43 * PX)
                    local c = sprite(t, ART.giftC, side < 0 and PAL.giftB or PAL.giftG, {z = 7})
                    c.Position = dim_offset(33 * PX, 42 * PX)
                    local b = sprite(t, ART.giftB, side < 0 and PAL.giftG or PAL.giftR, {z = 8})
                    b.Position = dim_offset(side < 0 and 22 * PX or 9 * PX, 46 * PX)
                    return t
                end

                buildTree(-1)
                buildTree(1)

                ---------------------------------------------------------------- snowfall
                local flakeSets = {}

                local function makeFlakes(parent, count, maxSize, crystals)
                    local list = {}
                    for i = 1, count do
                        local depth = rng:NextNumber(0.3, 1)
                        local size = math.max(2, math.floor(depth * maxSize + 0.5))
                        local alpha = 1 - depth * 0.85
                        local obj
                        local spin = 0
                        if crystals and depth > 0.72 and i % 3 == 0 then
                            local len = size + 5
                            obj = box(parent, dim2(0, 0, 0, 0), dim_offset(len, 2), WHITE, 1)
                            for _, rot in ipairs({90, 45, 135}) do
                                local arm = box(obj, dim2(0.5, 0, 0.5, 0), rot == 90 and dim2(1, 0, 1, 0) or dim2(0.7, 0, 1, 0), WHITE, 1)
                                arm.AnchorPoint = vec2(0.5, 0.5)
                                arm.Rotation = rot
                                arm.BackgroundTransparency = alpha
                            end
                            spin = rng:NextNumber(-70, 70)
                        else
                            obj = box(parent, dim2(0, 0, 0, 0), dim_offset(size, size), WHITE, 1)
                        end
                        obj.AnchorPoint = vec2(0.5, 0.5)
                        obj.BackgroundTransparency = alpha
                        list[i] = {
                            obj = obj, x = rng:NextNumber(), y = rng:NextNumber(),
                            speed = 0.035 + 0.085 * depth, sway = rng:NextNumber(0.003, 0.014),
                            t = rng:NextNumber(0, 6.28), spin = spin, drift = depth,
                        }
                    end
                    flakeSets[#flakeSets + 1] = {list = list, n = count}
                end

                local function refreshFlakes()
                    for _, set in ipairs(flakeSets) do
                        set.n = math.floor(#set.list * state.snowAmount + 0.5)
                        for i, fl in ipairs(set.list) do
                            fl.obj.Visible = i <= set.n
                        end
                    end
                end

                local sky = layer(Library.Items, {Size = dim2(1, 0, 1, 0); ZIndex = 0}, "snow")
                makeFlakes(sky, mobile and 60 or 110, 6, true)

                if Items.PageHolder then
                    local pageSnow = layer(Items.PageHolder, {Size = dim2(1, 0, 1, 0); ClipsDescendants = true; ZIndex = 3}, "snow")
                    makeFlakes(pageSnow, 34, 3, false)
                end

                local comet = box(sky, dim2(0, 0, 0, 0), dim_offset(110, 2), WHITE, 1)
                comet.AnchorPoint = vec2(1, 0.5)
                comet.Rotation = 24
                comet.Visible = false
                Library:Create("UIGradient", {Parent = comet; Transparency = numseq{numkey(0, 1), numkey(1, 0)}})

                refreshFlakes()

                ---------------------------------------------------------------- Santa in the sidebar
                local santa = {hop = -10, blinkAt = 3, blinkEnd = 0, waveEnd = 0, talkEnd = 0, bubbleEnd = 0, bubbleOn = false}
                local phrases = {"Ho ho ho!", "Merry Christmas!", "Jingle bells!", "Happy holidays!", "Naughty or nice?", "Cookies, please!"}
                local say, wave, fly = function() end, function() end, function() end
                local flying = false

                if Items.TabHolderFrame then
                    local root = layer(Items.TabHolderFrame, {
                        AnchorPoint = vec2(0.5, 1); Position = dim2(0.5, 0, 1, -5);
                        Size = dim_offset(132, 112); ZIndex = 6;
                    }, "santa")

                    santa.glow = glow(root, 66, 62, 170, GOLD, 0.86, 1)

                    local ground = sprite(root, ART.moundSmall, PAL.mound, {z = 2})
                    ground.Position = dim_offset(6, 100)
                    local g1 = sprite(root, ART.giftB, PAL.giftG, {z = 3})
                    g1.Position = dim_offset(0, 86)
                    local g2 = sprite(root, ART.giftC, PAL.giftB, {z = 3})
                    g2.Position = dim_offset(104, 78)
                    local g3 = sprite(root, ART.giftA, PAL.giftY, {px = 2, z = 4})
                    g3.Position = dim_offset(92, 90)

                    local rig = Library:Create("Frame", {
                        Parent = root; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                        Position = dim_offset(36, 14); Size = dim_offset(26 * PX, 30 * PX); ZIndex = 5;
                    })
                    santa.rig = rig
                    sprite(rig, ART.santaBase, PAL.santa, {z = 1})
                    santa.armDown = sprite(rig, ART.santaArmDown, PAL.santa, {z = 2})
                    santa.armUp1 = sprite(rig, ART.santaArmUp1, PAL.santa, {z = 2})
                    santa.armUp2 = sprite(rig, ART.santaArmUp2, PAL.santa, {z = 2})
                    santa.blink = sprite(rig, ART.santaBlink, PAL.santa, {z = 3})
                    santa.mouth = sprite(rig, ART.santaMouth, PAL.santa, {z = 3})
                    santa.armUp1.Visible = false
                    santa.armUp2.Visible = false
                    santa.blink.Visible = false
                    santa.mouth.Visible = false

                    local bubble = Library:Create("Frame", {
                        Parent = root; Name = "\0"; BackgroundColor3 = WHITE; BackgroundTransparency = 1; BorderSizePixel = 0;
                        AnchorPoint = vec2(0.5, 1); Position = dim2(0.5, 0, 0, 12); Size = dim_offset(112, 22); ZIndex = 20;
                    })
                    Library:Create("UICorner", {Parent = bubble; CornerRadius = dim(0, 5)})
                    local bubbleStroke = Library:Create("UIStroke", {Parent = bubble; Color = INK; Thickness = 1; Transparency = 1})
                    local tail = box(bubble, dim2(0.5, -8, 1, 0), dim_offset(7, 7), WHITE, 20)
                    tail.AnchorPoint = vec2(0.5, 0.5)
                    tail.Rotation = 45
                    tail.BackgroundTransparency = 1
                    local bubbleText = Library:Create("TextLabel", {
                        Parent = bubble; Name = "\0"; BackgroundTransparency = 1; Size = dim2(1, 0, 1, 0);
                        Text = ""; TextSize = 12; TextColor3 = rgb(158, 26, 46); TextTransparency = 1;
                        FontFace = font; ZIndex = 22;
                    })

                    local function setBubble(on)
                        santa.bubbleOn = on
                        local info = TweenInfo.new(0.25, Enum.EasingStyle.Sine)
                        Library:Tween(bubble, {BackgroundTransparency = on and 0.02 or 1}, info)
                        Library:Tween(tail, {BackgroundTransparency = on and 0.02 or 1}, info)
                        Library:Tween(bubbleStroke, {Transparency = on and 0.2 or 1}, info)
                        Library:Tween(bubbleText, {TextTransparency = on and 0 or 1}, info)
                    end
                    santa.setBubble = setBubble

                    local clicker = Library:Create("TextButton", {
                        Parent = root; Name = "\0"; BackgroundTransparency = 1; Text = ""; AutoButtonColor = false;
                        Position = dim_offset(30, 10); Size = dim_offset(76, 98); ZIndex = 30; BorderSizePixel = 0;
                    })
                    clicker.MouseButton1Click:Connect(function()
                        santa.hop = santa.clock or 0
                        if not flying then
                            task.spawn(fly)
                        end
                    end)

                    say = function(text, hold)
                        hold = hold or 2.2
                        bubbleText.Text = text
                        santa.talkEnd = (santa.clock or 0) + hold
                        santa.bubbleEnd = (santa.clock or 0) + hold + 0.3
                        setBubble(true)
                    end

                    wave = function(seconds)
                        santa.waveEnd = (santa.clock or 0) + (seconds or 2.2)
                    end
                end

                ---------------------------------------------------------------- sleigh fly-by
                local function spark(px, py)
                    local size = rng:NextInteger(1, 3) * 2
                    local col = (rng:NextNumber() < 0.6) and GOLD or WHITE
                    local f = box(Library.Items, dim_offset(px + rng:NextNumber(-6, 6), py + rng:NextNumber(-8, 8)), dim_offset(size, size), col, 499)
                    f.AnchorPoint = vec2(0.5, 0.5)
                    f.Rotation = 45
                    local info = TweenInfo.new(0.9, Enum.EasingStyle.Sine)
                    Library:Tween(f, {
                        Position = dim_offset(px + rng:NextNumber(-24, 24), py + rng:NextNumber(24, 60));
                        BackgroundTransparency = 1; Rotation = 45 + rng:NextNumber(-120, 120);
                    }, info)
                    task.delay(1, function() f:Destroy() end)
                end

                local function dropGift(px, py)
                    local arts = {ART.giftA, ART.giftC}
                    local g = sprite(Library.Items, arts[rng:NextInteger(1, 2)], giftPals[rng:NextInteger(1, #giftPals)], {px = 2, z = 499})
                    g.AnchorPoint = vec2(0.5, 0.5)
                    g.Position = dim_offset(px, py)
                    local shrink = Library:Create("UIScale", {Parent = g; Scale = 1})
                    Library:Tween(g, {
                        Position = dim_offset(px + rng:NextNumber(-30, 30), py + 150);
                        Rotation = rng:NextNumber(-160, 160);
                    }, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                    task.delay(1.05, function()
                        if shrink.Parent then
                            Library:Tween(shrink, {Scale = 0}, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                        end
                    end)
                    task.delay(1.5, function() g:Destroy() end)
                end

                local function buildFlyer(dir)
                    local UW, UH = 110, 26
                    local scale = mobile and 0.7 or 1
                    local flip = dir == -1
                    local flyer = Library:Create("Frame", {
                        Parent = Library.Items; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                        AnchorPoint = vec2(0.5, 0.5); Size = dim_offset(UW * PX, UH * PX); ZIndex = 500;
                    })
                    Library:Create("UIScale", {Parent = flyer; Scale = scale})

                    local function ux(x, w)
                        return flip and (UW - x - w) or x
                    end

                    local rig = {flyer = flyer, scale = scale, deer = {}, half = UW * PX / 2}
                    rig.aura = glow(flyer, UW * PX / 2, UH * PX / 2, UW * PX + 130, GOLD, 0.82, 1, UH * PX + 110)

                    -- reins
                    box(flyer, dim_offset(ux(21, 82) * PX, 13 * PX), dim_offset(82 * PX, 2), rgb(236, 206, 120), 2)

                    local leadPal = {}
                    for k, v in pairs(PAL.deer) do
                        leadPal[k] = v
                    end
                    leadPal.N = rgb(255, 60, 72)

                    for i = 0, 2 do
                        local lead = i == 2
                        local pal = lead and leadPal or PAL.deer
                        local holder = Library:Create("Frame", {
                            Parent = flyer; Name = "\0"; BackgroundTransparency = 1; BorderSizePixel = 0;
                            Position = dim_offset(ux(36 + i * 25, 24) * PX, 0); Size = dim_offset(24 * PX, 21 * PX); ZIndex = 3;
                        })
                        sprite(holder, ART.deerBody, pal, {z = 2, flip = flip})
                        local legsA = sprite(holder, ART.deerLegsA, pal, {y = 15, z = 1, flip = flip})
                        local legsB = sprite(holder, ART.deerLegsB, pal, {y = 15, z = 1, flip = flip})
                        legsB.Visible = false
                        if lead then
                            rig.nose = glow(holder, (flip and 1.5 or 22.5) * PX, 7 * PX, 34, RED, 0.45, 3)
                        end
                        rig.deer[#rig.deer + 1] = {holder = holder, a = legsA, b = legsB, x = holder.Position.X.Offset, phase = i * 1.3}
                    end

                    sprite(flyer, ART.sleigh, PAL.sleigh, {x = ux(0, 30), y = 4, z = 4, flip = flip})

                    rig.ho = Library:Create("TextLabel", {
                        Parent = flyer; Name = "\0"; BackgroundTransparency = 1;
                        Position = dim_offset(ux(0, 34) * PX, -16); Size = dim_offset(34 * PX, 16);
                        Text = "Ho ho ho!"; TextSize = 16; TextColor3 = WHITE; TextTransparency = 1;
                        FontFace = font; ZIndex = 520;
                    })
                    Library:Create("UIStroke", {Parent = rig.ho; Color = INK; Thickness = 1; Transparency = 0.3})

                    return rig
                end

                fly = function()
                    if flying then return end
                    flying = true

                    local vp = Camera.ViewportSize
                    local dir = (rng:NextNumber() < 0.5) and 1 or -1
                    local rig = buildFlyer(dir)
                    local flyer, scale = rig.flyer, rig.scale
                    local baseY = rng:NextNumber(0.14, 0.7) * vp.Y
                    local amp = rng:NextNumber(30, 70)
                    local waves = rng:NextInteger(1, 2)
                    local margin = rig.half * scale + 70
                    local span = vp.X + margin * 2
                    local duration = rng:NextNumber(5.5, 7.5)
                    local loop = rng:NextNumber() < 0.35
                    local elapsed, nextSpark, nextGift, hoShown = 0, 0, 0.7, false

                    say("Look up!", 2.2)
                    wave(2.4)

                    while elapsed < duration and Win.Parent do
                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                        local t = math.min(elapsed / duration, 1)
                        local x = (dir == 1) and (-margin + span * t) or (vp.X + margin - span * t)
                        local phase = t * math.pi * 2 * waves
                        local y = baseY + math.sin(phase) * amp
                        local slope = amp * math.pi * 2 * waves * math.cos(phase) / span
                        local rot = math.deg(math.atan(slope)) * dir

                        if loop and t > 0.42 and t < 0.62 then
                            local u = (t - 0.42) / 0.2
                            rot = rot + dir * 360 * (u * u * (3 - 2 * u))
                        elseif loop and t >= 0.62 then
                            rot = rot + dir * 360
                        end

                        flyer.Position = dim_offset(x, y)
                        flyer.Rotation = rot

                        for _, d in ipairs(rig.deer) do
                            local stride = math.floor(elapsed * 9 + d.phase) % 2 == 0
                            d.a.Visible = stride
                            d.b.Visible = not stride
                            d.holder.Position = dim_offset(d.x, math.sin(elapsed * 9 + d.phase) * 2.5)
                        end

                        setGlow(rig.nose, 0.4 + 0.25 * math.sin(elapsed * 9))
                        setGlow(rig.aura, 0.78 + 0.07 * math.sin(elapsed * 5))

                        if not hoShown and t > 0.15 then
                            hoShown = true
                            Library:Tween(rig.ho, {TextTransparency = 0}, TweenInfo.new(0.3))
                            task.delay(1.6, function()
                                if rig.ho.Parent then
                                    Library:Tween(rig.ho, {TextTransparency = 1}, TweenInfo.new(0.3))
                                end
                            end)
                        end

                        if elapsed >= nextSpark then
                            nextSpark = elapsed + 0.04
                            spark(x - dir * (rig.half - 10) * scale, y + rng:NextNumber(4, 26) * scale)
                        end

                        if elapsed >= nextGift then
                            nextGift = elapsed + rng:NextNumber(0.7, 1.1)
                            dropGift(x - dir * (rig.half - 30) * scale, y + 10 * scale)
                        end
                    end

                    flyer:Destroy()
                    flying = false
                end

                ---------------------------------------------------------------- one loop drives everything
                local clock = 0
                local nextChat, nextFly, nextComet = 8, rng:NextNumber(5, 8), rng:NextNumber(10, 20)

                local function lightLevel(l)
                    local mode, sp = state.lightMode, state.lightSpeed
                    if mode == "Steady" then
                        return 1
                    elseif mode == "Chase" then
                        local k = (clock * 5 * sp - l.i) % 5
                        if k < 1 then
                            return 1
                        elseif k < 2 then
                            return 0.5
                        end
                        return 0.1
                    elseif mode == "Wave" then
                        return 0.5 + 0.5 * math.sin(clock * 2.6 * sp - l.i * 0.5)
                    end
                    local v = 0.5 + 0.5 * math.sin(clock * l.rate * sp + l.phase)
                    return 0.12 + 0.88 * v * v
                end

                Library:Connection(RunService.Heartbeat, function(dt)
                    clock = clock + dt
                    santa.clock = clock
                    if not Win.Visible then return end

                    -- snow
                    if state.snow then
                        local wind = math.sin(clock * 0.23) * 0.012
                        for _, set in ipairs(flakeSets) do
                            local list = set.list
                            for i = 1, set.n do
                                local fl = list[i]
                                fl.t = fl.t + dt
                                fl.y = fl.y + fl.speed * dt
                                fl.x = fl.x + wind * fl.drift * dt
                                if fl.y > 1.03 then
                                    fl.y = -0.03
                                    fl.x = rng:NextNumber()
                                end
                                if fl.x > 1.03 then
                                    fl.x = -0.03
                                elseif fl.x < -0.03 then
                                    fl.x = 1.03
                                end
                                fl.obj.Position = dim2(fl.x + math.sin(fl.t) * fl.sway, 0, fl.y, 0)
                                if fl.spin ~= 0 then
                                    fl.obj.Rotation = fl.t * fl.spin
                                end
                            end
                        end

                        if clock >= nextComet then
                            nextComet = clock + rng:NextNumber(14, 30)
                            local sx, sy = rng:NextNumber(0.05, 0.6), rng:NextNumber(0.03, 0.3)
                            comet.Position = dim2(sx, 0, sy, 0)
                            comet.BackgroundTransparency = 0.1
                            comet.Visible = true
                            Library:Tween(comet, {Position = dim2(sx, 330, sy, 147)}, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
                            task.delay(0.5, function()
                                Library:Tween(comet, {BackgroundTransparency = 1}, TweenInfo.new(0.3))
                            end)
                        end
                    end

                    -- lights
                    for _, l in ipairs(lights) do
                        local v = state.lights and lightLevel(l) or 0.1
                        l.obj.BackgroundColor3 = l.dark:Lerp(l.col, v)
                        setGlow(l.halo, 1 - 0.62 * v)
                    end

                    for _, s in ipairs(stars) do
                        local v = 0.5 + 0.5 * math.sin(clock * 2.4 + s.phase)
                        local len = 14 + 24 * v
                        setGlow(s.glow, 0.72 - 0.4 * v)
                        s.h.Size = dim_offset(len, 2)
                        s.v.Size = dim_offset(2, len)
                        s.h.BackgroundTransparency = 0.85 - 0.6 * v
                        s.v.BackgroundTransparency = 0.85 - 0.6 * v
                    end

                    for _, g in ipairs(glints) do
                        local p = (clock - g.t0) / g.dur
                        if p >= 1 then
                            g.t0 = clock + rng:NextNumber(0.3, 2.6)
                            g.obj.Position = dim2(rng:NextNumber(0.03, 0.97), 0, 0, -rng:NextInteger(1, 7))
                            g.obj.Visible = false
                        elseif p > 0 then
                            local s = math.sin(math.pi * p) * 7
                            g.obj.Size = dim_offset(s, s)
                            g.obj.Visible = true
                        end
                    end

                    for _, row in ipairs(caneRows) do
                        row.obj.Position = dim_offset(row.shift - 24 + (clock * 14) % 24, row.obj.Position.Y.Offset)
                    end

                    -- Santa
                    if santa.rig then
                        local bob = math.floor(math.sin(clock * 2.2) * 1.5 + 0.5)
                        local hopT = (clock - santa.hop) / 0.38
                        local hop = (hopT > 0 and hopT < 1) and math.sin(math.pi * hopT) * 16 or 0
                        santa.rig.Position = dim_offset(36, 14 + bob - hop)

                        if clock >= santa.blinkAt then
                            santa.blinkEnd = clock + 0.13
                            santa.blinkAt = clock + rng:NextNumber(2.4, 6)
                        end
                        santa.blink.Visible = clock < santa.blinkEnd

                        local waving = clock < santa.waveEnd
                        local beat = math.floor(clock * 6) % 2 == 0
                        santa.armDown.Visible = not waving
                        santa.armUp1.Visible = waving and beat
                        santa.armUp2.Visible = waving and not beat

                        santa.mouth.Visible = clock < santa.talkEnd and math.floor(clock * 7) % 2 == 0
                        if santa.bubbleOn and clock >= santa.bubbleEnd then
                            santa.setBubble(false)
                        end
                        setGlow(santa.glow, 0.84 + 0.06 * math.sin(clock * 1.6))

                        if clock >= nextChat then
                            nextChat = clock + rng:NextNumber(7, 12)
                            if state.santa and not flying then
                                say(phrases[rng:NextInteger(1, #phrases)], 2.2)
                                if rng:NextNumber() < 0.6 then
                                    wave(2)
                                end
                            end
                        end
                    end

                    if window.Tweening then return end

                    -- these belong to the window itself, so they wait for the menu fade to finish
                    if Items.Glow then
                        Items.Glow.ImageColor3 = RED:Lerp(GREEN, 0.5 + 0.5 * math.sin(clock * 0.9))
                        Items.Glow.ImageTransparency = 0.4 + 0.13 * math.sin(clock * 1.8)
                    end
                    outer.ImageTransparency = 0.8 + 0.1 * math.sin(clock * 2.2)

                    local u = (clock * 0.3) % 3
                    local i = math.floor(u)
                    border.Color = cycle[i + 1]:Lerp(cycle[(i + 1) % 3 + 1], u - i)

                    if state.autoFly and not flying and clock >= nextFly then
                        nextFly = clock + state.flyInterval * rng:NextNumber(0.8, 1.2)
                        task.spawn(fly)
                    end
                end)

                ---------------------------------------------------------------- controls for the menu
                Library.Xmas = {
                    State = state,
                    SetSnow = function(on) state.snow = on == true; applyVisibility() end,
                    SetSnowAmount = function(percent) state.snowAmount = math.clamp((tonumber(percent) or 70) / 100, 0, 1); refreshFlakes() end,
                    SetLights = function(on) state.lights = on == true; applyVisibility() end,
                    SetLightMode = function(mode) if type(mode) == "string" then state.lightMode = mode end end,
                    SetLightSpeed = function(percent) state.lightSpeed = math.clamp((tonumber(percent) or 100) / 100, 0.1, 4) end,
                    SetTrees = function(on) state.trees = on == true; applyVisibility() end,
                    SetSanta = function(on) state.santa = on == true; applyVisibility() end,
                    SetAutoFly = function(on) state.autoFly = on == true; nextFly = clock + 3 end,
                    SetFlyInterval = function(seconds) state.flyInterval = math.max(4, tonumber(seconds) or 14) end,
                    Fly = function() if not flying then task.spawn(fly) end end,
                    Say = function(text) say(text or phrases[rng:NextInteger(1, #phrases)], 2.4); wave(2) end,
                }

                applyVisibility()
                Notifications:Create({Name = "Merry Christmas! Festive theme loaded"})
            end)

            if not ok then
                warn("[Christmas theme] decoration skipped: " .. tostring(err))
            end
        end
    --

    -- Notification Library
        function Notifications:RefreshNotifications() 
            local offset = 50
            
            for i, v in Notifications.Notifs do
                local Position = vec2(20, offset)
                Library:Tween(v, {Position = dim_offset(Position.X, Position.Y)}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                offset += (v.AbsoluteSize.Y + 10)
            end

            return offset
        end
        
        function Notifications:FadeNotifs(path, is_fading)
            local fading = is_fading and 1 or 0 
            
            Library:Tween(path, {BackgroundTransparency = fading}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        Library:Tween(instance, {Transparency = fading}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    Library:Tween(instance, {TextTransparency = fading}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                elseif instance:IsA("Frame") then
                    Library:Tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                end
            end
        end 
        
        function Notifications:Create(properties)
            local Cfg = {
                Name = properties.Name or properties.name or "This is a title!";
                Lifetime = properties.LifeTime or 3;
                
                Items = {};
                outline;
            }

            local Items = Cfg.Items; do 
                Items.Outline = Library:Create( "Frame" , {
                    Parent = Library.Items;
                    Name = "\0";
                    Position = dim2(0, 100, 0, 10);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = themes.preset.inline
                });	Library:Themify(Items.Outline, "inline", "BackgroundColor3")
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.visible_backgrounds
                });	Library:Themify(Items.Inline, "visible_backgrounds", "BackgroundColor3")
                
                Library:Create( "UICorner" , {
                    Parent = Items.Inline
                });
                
                Items.Name = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Inline;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Name, "text_color", "BackgroundColor3")
                
                Library:Create( "UIPadding" , {
                    PaddingTop = dim(0, 5);
                    PaddingBottom = dim(0, 5);
                    Parent = Items.Name;
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.Outline
                });                       
            end 
            
            local index = #Notifications.Notifs + 1
            Notifications.Notifs[index] = Items.Outline
            
            local offset = Notifications:RefreshNotifications()

            Items.Outline.Position = dim_offset(20, offset)

            Library:Tween(Items.Outline, {AnchorPoint = vec2(0, 0)}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))

            task.spawn(function()
                task.wait(Cfg.Lifetime)
                Notifications.Notifs[index] = nil
                Notifications:FadeNotifs(Items.Outline, true)
                Library:Tween(Items.Outline, {AnchorPoint = vec2(1, 0)}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                task.wait(1)
                Items.Outline:Destroy() 
            end)
        end

function Library:FestiveTab(Window)
    -- Festive tab: every control here drives the decorations live.
    local Xmas = Library.Xmas or {}
    local function festive(name, ...)
        local fn = Xmas[name]
        if fn then
            fn(...)
        end
    end

    local Festive = Window:Tab({Name = "Festive"})

    local Scene = Festive:Section({Name = "Scene", Side = "Left"})
    Scene:Toggle({Name = "Snowfall", Flag = "xmas_snow", Default = true, Callback = function(on) festive("SetSnow", on) end})
    Scene:Slider({Name = "Snow amount", Flag = "xmas_snow_amount", Min = 10, Max = 100, Default = 70, Suffix = "%", Callback = function(value) festive("SetSnowAmount", value) end})
    Scene:Toggle({Name = "Christmas trees", Flag = "xmas_trees", Default = true, Callback = function(on) festive("SetTrees", on) end})
    Scene:Toggle({Name = "Santa", Flag = "xmas_santa", Default = true, Callback = function(on) festive("SetSanta", on) end})

    local Lights = Festive:Section({Name = "Lights", Side = "Left"})
    Lights:Toggle({Name = "String lights", Flag = "xmas_lights", Default = true, Callback = function(on) festive("SetLights", on) end})
    Lights:Dropdown({Name = "Pattern", Flag = "xmas_light_mode", Options = {"Twinkle", "Chase", "Wave", "Steady"}, Default = "Twinkle", Callback = function(mode) festive("SetLightMode", mode) end})
    Lights:Slider({Name = "Speed", Flag = "xmas_light_speed", Min = 25, Max = 300, Default = 100, Suffix = "%", Callback = function(value) festive("SetLightSpeed", value) end})

    local Sleigh = Festive:Section({Name = "Sleigh", Side = "Right"})
    Sleigh:Button({Name = "Call the sleigh", Callback = function() festive("Fly") end})
    Sleigh:Button({Name = "Make Santa talk", Callback = function() festive("Say") end})
    Sleigh:Toggle({Name = "Automatic fly-bys", Flag = "xmas_auto_fly", Default = true, Callback = function(on) festive("SetAutoFly", on) end})
    Sleigh:Slider({Name = "Time between fly-bys", Flag = "xmas_fly_interval", Min = 6, Max = 60, Default = 14, Suffix = "s", Callback = function(value) festive("SetFlyInterval", value) end})
    Sleigh:Label({Name = "Tip: click Santa to call the sleigh"})
end

if getgenv().ChristmasAutoWindow ~= false then
    local Window = Library:Window({
        Prefix = "christmas.",
        Suffix = "update",
    })

    Library:FestiveTab(Window)
    Library:Configs(Window)
end

return Library, Flags

end

local Library = LoadChristmasUI()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ExecutorSupport = {
    Mobile = false,
    Executor = "Unknown"
}
pcall(function()
    if identifyexecutor then
        ExecutorSupport.Executor = identifyexecutor()
    elseif KRNL_LOADED then
        ExecutorSupport.Executor = "KRNL"
    elseif syn then
        ExecutorSupport.Executor = "Synapse X"
    elseif SENTINEL_LOADED then
        ExecutorSupport.Executor = "Sentinel"
    elseif getexecutorname then
        ExecutorSupport.Executor = getexecutorname()
    end
end)
pcall(function()
    ExecutorSupport.Mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end)
getgenv().SwimMethod = false
getgenv().TeleportSettings = { Speed = 0.25 }
getgenv().auraenabled = false
getgenv().killaurahigh = false
getgenv().rainbowbeam = false
getgenv().hitpart = "Head"
getgenv().damage = 100
getgenv().cooldown = 0
getgenv().beamcolor = Color3.fromRGB(0, 200, 80)
Config = Config or {}
Config.TheBronx = { carfly = false, carflyspeed = 120 }
_G.respawn = false
local staminaEnabled = false
local hungerEnabled = false
local sleepEnabled = false
local AntiLoseEnabled = false
local Noclipping = nil
local flyEnabled = false
local guiEnabled = true
local enhancedWalk = false
local speed = 16
local hitboxextender = false
local Size = 4
local Transparency = 0.85
local HitboxColor = Color3.fromRGB(255, 0, 0)
local SelectedPlayer = nil
local rainbowHitbox = false
local nametagEnabled = true
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://78828590676720"
local bodyGyro, movementConnection, freezeConnection, animationTrack
local hum, seat, car, root, bv, bg, lastCar
local target1 = nil
task.spawn(function()
    while task.wait() do
        if getgenv().SwimMethod then
            local p = Players.LocalPlayer
            if p and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            end
        end
    end
end)
local locations = {
    ["🏦 Bank"] = Vector3.new(-1216.5316162109375, 253.8797607421875, -3636.446044921875),
    ["💵 Money Wash"] = Vector3.new(-977.1771, 253.6838, -692.5855),
    ["💰 Pawn Shop"] = Vector3.new(-1049.6431, 253.5367, -814.2697),
    ["🔐 Bank Vault"] = Vector3.new(-217.568359375, 373.7984924316406, -1216.20947265625),
    ["🔫 GunShop 1"] = Vector3.new(92994.6640625, 122098.5078125, 17225.943359375),
    ["🔫 GunShop 2"] = Vector3.new(66195.4453125, 123615.7109375, 5750.28271484375),
    ["🔫 GunShop Lobby"] = Vector3.new(-224.3818359375, 283.8034362792969, -794.7174072265625),
    ["🔫 GunShop 3"] = Vector3.new(60820.3086, 87609.1484, -351.4746),
    ["🏢 Pent House"] = Vector3.new(-1482.804443359375, 463.39385986328125, -3690.70751953125),
    ["🏠 Mini Mansion"] = Vector3.new(-791.5180053710938, 256.7944641113281, 1414.4248046875),
    ["🎒 Backpack Shop"] = Vector3.new(-692.4142456054688, 253.78091430664062, -681.0672607421875),
    ["💎 Frozen Shop"] = Vector3.new(-216.31436157226562, 284.031494140625, -1169.032470703125),
    ["👕 Drip Store"] = Vector3.new(67462, 10489.21484375, 546.1941528320312),
    ["🍗 Chicken Wings"] = Vector3.new(-957.9142, 253.5367, -815.9442),
    ["🚗 Car Dealer"] = Vector3.new(-401.99371337890625, 253.4141082763672, -1248.8380126953125),
    ["🐍 Exotic Dealer"] = Vector3.new(-1523.5654296875, 273.9729919433594, -990.6575317382812),
    ["🚧 Construction"] = Vector3.new(-1731.8307, 370.8123, -1176.8387),
    ["🚔 Prison"] = Vector3.new(-1135.0464, 254.7160, -3330.9954),
    ["🏥 Hospital"] = Vector3.new(-1589.504150390625, 254.27223205566406, 17.6555233001709),
    ["🏧 ATM 1"] = Vector3.new(-1011.9066162109375, 253.7509002685547, -1153.7340087890734),
    ["🏧 ATM 2"] = Vector3.new(-739.9456176757812, 287.12518310546875, -793.5716552734375),
    ["🏕️ TrailerPark"] = Vector3.new(-1522.76904296875, 253.16094970703125, 2344.95947265625),
    ["🍳 Cook Spot"] = Vector3.new(-741.1889038085938, 262.9556579589844, -955.7835083007812),
    ["🎨 Tattoo Shop"] = Vector3.new(-659.76806640625, 254.13262939453125, -461.2218322753906),
    ["⛽ Gas Station"] = Vector3.new(-1412.353759765625, 254.7757110595703, 2892.250048828125),
    ["💵 Dollar General"] = Vector3.new(-388.8291931152344, 253.8165283203125, -1036.4705810546875),
    ["🛒 Bronx Market"] = Vector3.new(-428.1142578125, 334.32501220703125, -581.2235107421875),
    ["🍟 McDonalds"] = Vector3.new(-1011.2984619140625, 253.9326629638672, -1147.4130859375),
    ["⚔️ Striker Man"] = Vector3.new(-1427.686767578125, 254.2161865234375, 2777.208740234375),
    ["🌸 Sell Seeds"] = Vector3.new(-1419.4013671875, 253.28067016601562, 2034.50341796875),
    ["🌿 Grow Seeds"] = Vector3.new(-935.8598022460938, 267.469482421875, -1132.88818359375),
    ["🌱 Buy Seeds"] = Vector3.new(51371.56640625, 21680.416015625, 21681.03759765625),
    ["🏚️ Basement"] = Vector3.new(-194.34603881835938, 239.5054168701172, 1238.91845703125),
    ["🏀 Court"] = Vector3.new(-1722.821533203125, 236.94708251953125, -589.066650390625),
}
local outfits = {
    ["Blue Spider"] = {
        Hats = {"MRHoodieBRR"},
        Shirts = {"Blue Sp5der Hoodie"},
        Pants = {"Blue Sp5der Sweats"},
        Shiestys = {"Shiesty"},
        Masks = {}
    },
    ["Spider Man"] = {
        Hats = {},
        Shirts = {"Spiderman"},
        Pants = {"Spiderman"},
        Shiestys = {"RedShiesty"},
        Masks = {}
    },
    ["Blood Clown"] = {
        Hats = {},
        Shirts = {"Red B Jacket"},
        Pants = {"Red B Shorts"},
        Shiestys = {},
        Masks = {"MRCLOWN MAN"}
    },
    ["Crip Clown"] = {
        Hats = {},
        Shirts = {"Blu C Amiri Hoodie"},
        Pants = {"Blu B Shorts"},
        Shiestys = {},
        Masks = {"MRCLOWN MAN"}
    },
    ["Red Spider"] = {
        Hats = {"MRHoodieBRR"},
        Shirts = {"Red Sp5der Sweats"},
        Pants = {"Red Sp5der Sweats"},
        Shiestys = {"Shiesty"},
        Masks = {}
    },
}
local ExemptItems = {"Phone", "Fist", "Shiesty", "Bandage", "Lemonade", "Car keys"}
local function Notify(title, text, duration)
    pcall(function()
        local msg = (tostring(title) .. ": " .. tostring(text)):gsub("[\128-\255]+", "")
        Library.Notifications:Create({ Name = msg, LifeTime = duration or 3 })
    end)
end
local function enableSwimMethod()
    getgenv().SwimMethod = true
end
local function disableSwimMethod()
    getgenv().SwimMethod = false
end
local function findProximityPromptRecursive(obj)
    if not obj then return nil end
    if obj:IsA("ProximityPrompt") then return obj end
    for _, child in ipairs(obj:GetChildren()) do
        local p = findProximityPromptRecursive(child)
        if p then return p end
    end
    return nil
end
local function BypassTp(destinationCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    enableSwimMethod()
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.FallingDown) end) end
    task.wait(0.7)
    local n = 0
    repeat task.wait(0.05); n = n + 1 until not LocalPlayer:GetAttribute("LastACPos") or n > 10
    pcall(function()
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    local off = Vector3.new(math.random(-1,1), 0, math.random(-1,1))
    if typeof(destinationCFrame) == "CFrame" then hrp.CFrame = destinationCFrame + off
    elseif typeof(destinationCFrame) == "Vector3" then hrp.CFrame = CFrame.new(destinationCFrame) + off end
    task.delay(0.3, disableSwimMethod)
end

getgenv().antiFling = false
getgenv()._antiFlingLastSafePos = nil
task.spawn(function()
    while true do task.wait(0.06)
        if getgenv().antiFling then
            local c = LocalPlayer.Character; if not c then continue end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then continue end
            if hum.FloorMaterial ~= Enum.Material.Air then
                getgenv()._antiFlingLastSafePos = hrp.CFrame
            end
            local vel = hrp.AssemblyLinearVelocity
            if vel.Magnitude > 120 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                for _,v in pairs(c:GetDescendants()) do
                    if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("VectorForce") or v:IsA("BodyForce") then
                        pcall(function() v:Destroy() end)
                    end
                end
                task.wait(0.1)
                local dest = getgenv()._antiFlingLastSafePos
                if dest then
                    task.spawn(function() pcall(function() BypassTp(dest) end) end)
                else
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end
end)

local function applyEffects()
    local char = LocalPlayer.Character
    if not char then return end
    if staminaEnabled then
        pcall(function()
            local staminaScript = LocalPlayer.PlayerGui:FindFirstChild("Run", true)
            if staminaScript then
                local scriptObj = staminaScript:FindFirstChild("StaminaBarScript", true)
                if scriptObj then scriptObj:Destroy() end
            end
        end)
    end
    if hungerEnabled then
        pcall(function()
            local hungerScript = LocalPlayer.PlayerGui:FindFirstChild("Hunger", true)
            if hungerScript then
                local scriptObj = hungerScript:FindFirstChild("HungerBarScript", true)
                if scriptObj then scriptObj:Destroy() end
            end
        end)
    end
    if sleepEnabled then
        pcall(function()
            local s = LocalPlayer.PlayerGui.SleepGui.Frame.sleep.SleepBar.sleepScript
            s.Disabled = true
            s.Disabled = false
            s.Disabled = true
        end)
    end
end
local function setCollide(state)
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = state end
        end
    end
end
local function equipOutfitItem(category, itemName)
    pcall(function() ReplicatedStorage.ClothShopRemote:FireServer("Buy", category, itemName) end)
    task.wait(0.3)
    pcall(function() ReplicatedStorage.ClothShopRemote:FireServer("Wear", category, itemName) end)
    task.wait(0.2)
end
local function equipOutfit(outfitName)
    local outfit = outfits[outfitName]
    if not outfit then Notify("Outfit","Outfit not found!",3) return end
    pcall(function() ReplicatedStorage.ClothShopRemote:FireServer("Reset Data") end)
    task.wait(0.3)
    Notify("Outfit","Changing to "..outfitName.."...",2)
    for _, hatName in ipairs(outfit.Hats or {}) do equipOutfitItem("Hats", hatName) end
    for _, shirtName in ipairs(outfit.Shirts or {}) do equipOutfitItem("Shirts", shirtName) end
    for _, pantsName in ipairs(outfit.Pants or {}) do equipOutfitItem("Pants", pantsName) end
    for _, shiesty in ipairs(outfit.Shiestys or {}) do equipOutfitItem("Shiestys", shiesty) end
    for _, mask in ipairs(outfit.Masks or {}) do equipOutfitItem("Masks", mask) end
    Notify("Outfit","Equipped: "..outfitName,3)
end
function dmg(target, hpart, damage)
    pcall(function()
        local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if not tool then return end
        local targetPart = target.Character[hpart]
        local hitpos = targetPart.Position
        ReplicatedStorage.InflictTarget:FireServer(
            tool,
            LocalPlayer,
            target.Character.Humanoid,
            targetPart,
            damage,
            {0, 0, false, false,
                tool.GunScript_Server.IgniteScript,
                tool.GunScript_Server.IcifyScript,
                100, 100},
            {false, 5, 3},
            targetPart,
            {false, {1930359546}, 1, 1.5, 1},
            hitpos,
            Vector3.new(0.07, -0.1, -0.99),
            true
        )
    end)
end

function KillGunMod(target,hpart,damage)
    local tool=checkgun(); if not tool then return end
    local tc=target and target.Character; if not tc then return end
    local hum=tc:FindFirstChildWhichIsA("Humanoid"); if not hum then return end
    local head=tc:FindFirstChild(hpart or "Head") or tc:FindFirstChild("HumanoidRootPart"); if not head then return end
    if not damage or damage==math.huge then
        local sd; pcall(function() local st=tool:FindFirstChild("Setting"); if st then local s=require(st); if s then sd=tonumber(s.Damage) or tonumber(s.BaseDamage) end end end)
        damage = sd or 200
    end
    local handle=tool:FindFirstChild("Handle"); if not handle then return end
    local gsl=tool:FindFirstChild("GunScript_Local")
    local gss=tool:FindFirstChild("GunScript_Server")
    local fp=handle:FindFirstChild("GunFirePoint") or handle
    local origin=fp.Position
    local dir=(head.Position-origin); dir=dir.Magnitude>0 and dir.Unit or Vector3.new(0,0,-1)
    local infOrigin=head.Position - dir*3
    local ig=gss and gss:FindFirstChild("IgniteScript")
    local ic=gss and gss:FindFirstChild("IcifyScript")
    pcall(function()
        local setting=tool:FindFirstChild("Setting")
        if setting then local s=require(setting); if s then s.LimitedAmmoEnabled=false; s.Ammo=10000; s.AmmoPerMag=10000; s.MagCount=10000; s.StoredAmmo=10000; s.MaxAmmo=10000 end end
    end)
    pcall(function() ReplicatedStorage.VisualizeMuzzle:FireServer(handle,true,{false,7,Color3.new(1,1.1098,0),15,true,0.02}, gsl and gsl:FindFirstChild("MuzzleEffect")) end)
    pcall(function() ReplicatedStorage.VisualizeBullet:FireServer(
        tool, handle, dir, fp,
        {true,{112139677907598,92977228204408,112139677907598,92977228204408},1,1,3.5, gsl and gsl:FindFirstChild("HitEffect"), true},
        {true,{0,0,0,0,0,0},1,1,1, gsl and gsl:FindFirstChild("BloodEffect")},
        {true,0.2,{3696144972},true,7,1},
        {false,8,true,{163064102},1,1.5,1,false, gsl and gsl:FindFirstChild("ExplosionEffect")},
        {false,Vector3.new(0.1,0,0),Vector3.new(-0.1,0,0), gsl and gsl:FindFirstChild("TracerEffect"), nil, gsl and gsl:FindFirstChild("ParticleEffect"),300,500,0,Vector3.zero,Vector3.new(0.4,0.4,0.4),Color3.new(0.639,0.635,0.611),1,Enum.Material.Neon,Enum.PartType.Cylinder,false,6696543809,0,Vector3.new(0.007,0.007,0.007)},
        {true,{269514869,269514887,269514807,269514817},0.5,1,1.5,100},
        {false,3,Color3.new(1,0.647,0.6),6,true}
    ) end)
    pcall(function() ReplicatedStorage.InflictTarget:FireServer(
        tool, LocalPlayer, hum, head, damage,
        {0,0,false,false,ig,ic,100,100},
        {false,5,3}, head,
        {false,{1930359546},1,1.5,1},
        infOrigin, dir
    ) end)
end

function wsSlimeKill(p)
    if not p or not p.Character then return end
    local th = p.Character:FindFirstChild("HumanoidRootPart")
    local myChar = LocalPlayer.Character
    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not th or not hrp then return end
    checkgun()
    local original = hrp.CFrame
    pcall(function() hrp.CFrame = th.CFrame end)
    pcall(function() hrp.Anchored = true end)
    task.wait(0.07)
    pcall(function() KillGunMod(p, "Head", math.huge) end)
    task.wait(0.07)
    pcall(function() KillGunMod(p, "Head", math.huge) end)
    task.wait(0.18)
    pcall(function() KillGunMod(p, "Head", math.huge) end)
    task.wait(0.1)
    pcall(function() hrp.Anchored = false end)
    local h2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if h2 and original then pcall(function() h2.CFrame = original end) end
end

function hasGunInHand()
    local char=LocalPlayer.Character; if not char then return false end
    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Tool") and (v:FindFirstChild("GunScript_Local") or v:FindFirstChild("GunScript_Server")) then return true end
    end
    return false
end

function BigGunNotify(mode)
    pcall(function()
        local blocked  = (mode ~= "ammo")
        local WAL_BLUE = Color3.fromRGB(0,113,220)
        local SPARK    = Color3.fromRGB(255,194,32)
        local headCol  = blocked and Color3.fromRGB(255,99,99) or Color3.fromRGB(244,246,255)
        local headTxt, bodyTxt
        if mode == "ammo" then
            headTxt = "No ammo? Just shoot the gun"
            bodyTxt = "If it says no ammo left, just shoot the gun once and it'll work again."
        elseif mode == "noknife" then
            headTxt = "Needs a knife -- go grab one!"
            bodyTxt = "Equip a knife first (Kitchen Knife, Cleaver, Axe, Machete...)."
        else
            headTxt = "Needs a gun -- go get ur pipe dumbass"
            bodyTxt = "This won't do anything until you've got a gun in your hand."
        end
        local parent = (gethui and gethui()) or game:GetService("CoreGui")
        local old = parent:FindFirstChild("_GunWarnGui"); if old then old:Destroy() end
        local TS = game:GetService("TweenService")
        local gui = Instance.new("ScreenGui")
        gui.Name = "_GunWarnGui"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 99999
        gui.Parent = parent
        local card = Instance.new("Frame")
        card.AnchorPoint = Vector2.new(0.5,0)
        card.Position = UDim2.new(0.5,0,0,-150)
        card.Size = UDim2.new(0,470,0,104)
        card.BackgroundColor3 = Color3.fromRGB(16,20,30); card.BackgroundTransparency = 0.03
        card.BorderSizePixel = 0; card.Parent = gui
        Instance.new("UICorner",card).CornerRadius = UDim.new(0,18)
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,28,42)),ColorSequenceKeypoint.new(1,Color3.fromRGB(13,16,24))}); grad.Rotation = 90; grad.Parent = card
        local stroke = Instance.new("UIStroke"); stroke.Color = WAL_BLUE; stroke.Thickness = 1; stroke.Transparency = 0.45; stroke.Parent = card
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0,4,1,-26); accent.Position = UDim2.fromOffset(0,13)
        accent.BackgroundColor3 = blocked and Color3.fromRGB(232,66,66) or WAL_BLUE; accent.BorderSizePixel = 0; accent.Parent = card
        Instance.new("UICorner",accent).CornerRadius = UDim.new(1,0)
        local badge = Instance.new("Frame")
        badge.Position = UDim2.fromOffset(16,16); badge.Size = UDim2.fromOffset(40,40)
        badge.BackgroundColor3 = WAL_BLUE; badge.BorderSizePixel = 0; badge.Parent = card
        Instance.new("UICorner",badge).CornerRadius = UDim.new(0,11)
        local bgrad = Instance.new("UIGradient")
        bgrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,200,80)),ColorSequenceKeypoint.new(1,WAL_BLUE)}); bgrad.Rotation = 130; bgrad.Parent = badge
        local bl = Instance.new("TextLabel"); bl.Size = UDim2.fromScale(1,1); bl.BackgroundTransparency = 1
        bl.Font = Enum.Font.GothamBlack; bl.TextSize = 19; bl.TextColor3 = SPARK; bl.Text = "S"; bl.Parent = badge
        local title = Instance.new("TextLabel")
        title.Position = UDim2.fromOffset(66,16); title.Size = UDim2.new(1,-130,0,15)
        title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(228,234,246); title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = "Skid Hub"; title.Parent = card
        local tm = Instance.new("TextLabel")
        tm.Position = UDim2.new(1,-58,0,16); tm.Size = UDim2.fromOffset(46,15)
        tm.BackgroundTransparency = 1; tm.Font = Enum.Font.Gotham; tm.TextSize = 10.5
        tm.TextColor3 = Color3.fromRGB(120,134,160); tm.TextXAlignment = Enum.TextXAlignment.Right
        tm.Text = "now"; tm.Parent = card
        local l1 = Instance.new("TextLabel")
        l1.Position = UDim2.fromOffset(66,35); l1.Size = UDim2.new(1,-82,0,20)
        l1.BackgroundTransparency = 1; l1.Font = Enum.Font.GothamBold; l1.TextSize = 14.5
        l1.TextColor3 = headCol; l1.TextXAlignment = Enum.TextXAlignment.Left
        l1.TextTruncate = Enum.TextTruncate.AtEnd; l1.Text = headTxt; l1.Parent = card
        local l2 = Instance.new("TextLabel")
        l2.Position = UDim2.fromOffset(66,56); l2.Size = UDim2.new(1,-82,0,40)
        l2.BackgroundTransparency = 1; l2.Font = Enum.Font.Gotham; l2.TextSize = 12.5
        l2.TextColor3 = Color3.fromRGB(140,152,176); l2.TextXAlignment = Enum.TextXAlignment.Left
        l2.TextYAlignment = Enum.TextYAlignment.Top; l2.TextWrapped = true; l2.Text = bodyTxt; l2.Parent = card
        local TI_IN = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local TI_OUT = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TS:Create(card, TI_IN, {Position = UDim2.new(0.5,0,0,18)}):Play()
        task.delay(5, function()
            pcall(function() TS:Create(card, TI_OUT, {Position = UDim2.new(0.5,0,0,-150)}):Play() end)
            task.delay(0.4, function() pcall(function() gui:Destroy() end) end)
        end)
    end)
end
function checkgun()
    local player = game.Players.LocalPlayer
    local gunTool = nil
    for _, v in pairs(player.Backpack:GetDescendants()) do
        if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
            gunTool = v.Parent
            break
        end
    end
    if not gunTool and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
                gunTool = v.Parent
                break
            end
        end
    end
    if gunTool and gunTool:IsA("Tool") then
        player.Character:WaitForChild("Humanoid"):EquipTool(gunTool)
    end
    return gunTool
end
function GetGunSettings()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("Setting") then return nil, nil end
    return require(tool.Setting), tool
end
local _nativeFPP = fireproximityprompt
local function fireproximityprompt(prompt)
    if not (prompt and prompt:IsA("ProximityPrompt")) then return end

    if _nativeFPP then
        if pcall(_nativeFPP, prompt, 1) then return end
        if pcall(_nativeFPP, prompt) then return end
    end

    pcall(function()
        local oldHold, oldDist, oldLoS = prompt.HoldDuration, prompt.MaxActivationDistance, prompt.RequiresLineOfSight
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.max(oldDist, 1000)
        prompt.RequiresLineOfSight = false
        prompt:InputHoldBegin()
        task.wait()
        prompt:InputHoldEnd()
        prompt.MaxActivationDistance = oldDist
        prompt.HoldDuration = oldHold
        prompt.RequiresLineOfSight = oldLoS
    end)
end
local allowedKnifeTools = {
    ["Kitchen Knife"] = true,
    ["ButterflyKnife"] = true,
    ["Melee"] = true,
    Cleaver = true,
    Axe = true,
    Blade = true,
    Machete = true
}
local function GetAttackEvent(tool)
    if tool and tool:FindFirstChild("MeleeSystem") then
        return tool.MeleeSystem:FindFirstChild("AttackEvent")
    end
    return nil
end
local function getcp()
    local mouse = LocalPlayer:GetMouse()
    local closest, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if d < dist then dist = d; closest = v end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    target1 = getcp()
end)
local function MarketHasItem(toolName)
    local market = ReplicatedStorage:FindFirstChild("MarketItems")
    if not market then return false end
    for _, item in ipairs(market:GetChildren()) do
        if item.Name == toolName and item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then
            return true
        end
    end
    return false
end
local function BackpackHasItem(toolName)
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then return true end
    end
    return false
end
local function ForcePutToMarket(toolName)
    local endTime = os.clock() + 12
    while os.clock() < endTime do
        if MarketHasItem(toolName) then return true end
        pcall(function() ReplicatedStorage.ListWeaponRemote:FireServer(toolName, 999999) end)
        task.wait(0.15)
    end
    return false
end
local function ForceRetrieveFromMarket(toolName)
    local market = ReplicatedStorage:WaitForChild("MarketItems", 10)
    if not market then return false end
    local endTime = os.clock() + 12
    while os.clock() < endTime do
        for _, item in ipairs(market:GetChildren()) do
            if item.Name == toolName and item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name and item:GetAttribute("SpecialId") then
                local special = item:GetAttribute("SpecialId")
                pcall(function() ReplicatedStorage.BuyItemRemote:FireServer(toolName, "Remove", special) end)
                task.wait(0.2)
                pcall(function() ReplicatedStorage.BackpackRemote:InvokeServer("Grab", toolName) end)
                task.wait(0.2)
                if BackpackHasItem(toolName) then return true end
            end
        end
        task.wait(0.3)
    end
    return false
end
local function CreateNametag(char)
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local old = head:FindFirstChild("SkidHubTag")
    if old then old:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SkidHubTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local tag = Instance.new("TextLabel")
    tag.Size = UDim2.new(1, 0, 1, 0)
    tag.BackgroundTransparency = 1
    tag.Text = "Skid Hub"
    tag.TextColor3 = Color3.fromRGB(255, 255, 0)
    tag.TextStrokeTransparency = 0.5
    tag.TextStrokeColor3 = Color3.new(0, 0, 0)
    tag.Font = Enum.Font.GothamBold
    tag.TextSize = 14
    tag.Parent = billboard
    task.spawn(function()
        while billboard and billboard.Parent do
            TweenService:Create(tag, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(0, 200, 80)}):Play()
            task.wait(1)
            TweenService:Create(tag, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(255, 255, 0)}):Play()
            task.wait(1)
        end
    end)
end
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "SkidHubLoading"
LoadingScreen.IgnoreGuiInset = true
LoadingScreen.DisplayOrder = 9999
LoadingScreen.Parent = CoreGui
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
LoadingFrame.BackgroundTransparency = 1
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = LoadingScreen
TweenService:Create(LoadingFrame, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
task.wait(0.8)
for i = 0, 30 do
    local stripe = Instance.new("Frame", LoadingFrame)
    stripe.Size = UDim2.new(1, 0, 0, 1)
    stripe.Position = UDim2.new(0, 0, 0, i * 25)
    stripe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    stripe.BackgroundTransparency = 0.96
    stripe.BorderSizePixel = 0
end
local CenterBox = Instance.new("Frame", LoadingFrame)
CenterBox.Size = UDim2.new(0, 0, 0, 0)
CenterBox.AnchorPoint = Vector2.new(0.5, 0.5)
CenterBox.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterBox.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
CenterBox.BorderSizePixel = 0
CenterBox.ClipsDescendants = true
Instance.new("UICorner", CenterBox).CornerRadius = UDim.new(0, 10)
local cStroke = Instance.new("UIStroke", CenterBox)
cStroke.Color = Color3.fromRGB(0, 200, 80)
cStroke.Thickness = 1.5
cStroke.Transparency = 1
task.delay(0.1, function()
    TweenService:Create(CenterBox, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 140)}):Play()
    TweenService:Create(cStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.3}):Play()
end)
task.spawn(function()
    task.wait(1)
    while CenterBox and CenterBox.Parent do
        TweenService:Create(cStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.2)
        TweenService:Create(cStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
        task.wait(1.2)
    end
end)
local Title = Instance.new("TextLabel", CenterBox)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "SKID HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextTransparency = 1
Title.TextSize = 28
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Center
local TitleStroke = Instance.new("UIStroke", Title)
TitleStroke.Color = Color3.fromRGB(0, 140, 56)
TitleStroke.Thickness = 1
TitleStroke.Transparency = 1
task.delay(0.6, function()
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(TitleStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 0}):Play()
end)
local DotHolder = Instance.new("Frame", CenterBox)
DotHolder.Size = UDim2.new(0, 60, 0, 12)
DotHolder.AnchorPoint = Vector2.new(0.5, 0)
DotHolder.Position = UDim2.new(0.5, 0, 0, 68)
DotHolder.BackgroundTransparency = 1
local ldots = {}
for i = 1, 3 do
    local dot = Instance.new("Frame", DotHolder)
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, (i - 1) * 22 + 4, 0, 2)
    dot.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    dot.BackgroundTransparency = 1
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    ldots[i] = dot
end
task.delay(0.8, function()
    for _, d in ipairs(ldots) do TweenService:Create(d, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play() end
end)
task.spawn(function()
    task.wait(0.9)
    while CenterBox and CenterBox.Parent do
        for i, dot in ipairs(ldots) do
            TweenService:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, (i - 1) * 22 + 4, 0, -5),
                BackgroundColor3 = Color3.fromRGB(120, 255, 170)
            }):Play()
            task.wait(0.12)
            TweenService:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(0, (i - 1) * 22 + 4, 0, 2),
                BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            }):Play()
        end
        task.wait(0.4)
    end
end)
local StatusText = Instance.new("TextLabel", CenterBox)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 90)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Starting up..."
StatusText.TextColor3 = Color3.fromRGB(120, 120, 140)
StatusText.TextTransparency = 1
StatusText.TextSize = 11
StatusText.Font = Enum.Font.Gotham
task.delay(0.7, function()
    TweenService:Create(StatusText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
end)
local VerTag = Instance.new("TextLabel", CenterBox)
VerTag.Size = UDim2.new(1, 0, 0, 14)
VerTag.Position = UDim2.new(0, 0, 1, -16)
VerTag.BackgroundTransparency = 1
VerTag.Text = "v3.0"
VerTag.TextColor3 = Color3.fromRGB(60, 60, 80)
VerTag.TextTransparency = 1
VerTag.TextSize = 9
VerTag.Font = Enum.Font.Gotham
task.delay(0.8, function() TweenService:Create(VerTag, TweenInfo.new(0.4), {TextTransparency = 0}):Play() end)
local loadingSteps = {
    {text = "Starting up...", wait = 0.5},
    {text = "Hooking remotes...", wait = 0.5},
    {text = "Building UI...", wait = 0.5},
    {text = "Ready", wait = 0.4},
}
task.spawn(function()
    task.wait(0.8)
    for _, step in ipairs(loadingSteps) do
        TweenService:Create(StatusText, TweenInfo.new(0.15), {TextTransparency = 0.6}):Play()
        task.wait(0.15)
        StatusText.Text = step.text
        TweenService:Create(StatusText, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        task.wait(step.wait)
    end
    task.wait(0.3)
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    TweenService:Create(TitleStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
    TweenService:Create(StatusText, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    TweenService:Create(VerTag, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    for _, d in ipairs(ldots) do TweenService:Create(d, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play() end
    task.wait(0.5)
    TweenService:Create(CenterBox, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    TweenService:Create(cStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
    task.wait(0.5)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.9)
    LoadingScreen:Destroy()
end)
-- ===== Skid Hub GUI adapter: old UI:Add* calls -> Skid Hub library elements =====
local uiReady = false
local Window = Library:Window({ Prefix = "skid.", Suffix = "hub" })
local UI = {}
local function clean(s)
    s = tostring(s):gsub("[\128-\255]+", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s%s+", " ")
    return s
end
local function wrapCb(cb)
    return function(...)
        if not uiReady or typeof(cb) ~= "function" then return end
        local ok, e = pcall(cb, ...)
        if not ok then warn("[Skid Hub]", e) end
    end
end
local TabOrder = { "Main", "Money/Bank", "Exploits", "Visuals", "Car Mods", "Farm", "Combat", "Trolling", "Quick Buys", "Misc", "Credits" }
local Pages = {}
local function makePage(name)
    local p = { name = name, tab = Window:Tab({ Name = name }), count = 0, sec = nil }
    Pages[name] = p
    return p
end
for _, n in ipairs(TabOrder) do makePage(n) end
local Registry = {}
function UI:AddTab(name) name = tostring(name) return Pages[name] or makePage(name) end
function UI:AddSection(page, text)
    page.count += 1
    page.sec = page.tab:Section({ Name = clean(text), Side = (page.count % 2 == 1) and "Left" or "Right" })
end
local function sec(page)
    if not page.sec then UI:AddSection(page, page.name) end
    return page.sec
end
local function flagOf(page, text) return page.name .. ":" .. clean(text) end
function UI:AddButton(page, text, cb)
    sec(page):Button({ Name = clean(text), Callback = wrapCb(cb) })
    Registry[clean(text)] = { type = "button", cb = cb }
end
function UI:AddToggle(page, text, default, cb)
    local t = sec(page):Toggle({ Name = clean(text), Flag = flagOf(page, text), Default = default and true or false, Callback = wrapCb(cb) })
    Registry[clean(text)] = { type = "toggle", obj = t }
    return t
end
function UI:AddSlider(page, text, min, max, default, cb)
    return sec(page):Slider({ Name = clean(text), Flag = flagOf(page, text), Min = min, Max = max, Default = default, Callback = wrapCb(cb) })
end
function UI:AddDropdown(page, text, options, default, cb)
    local map = {}
    local function build(opts)
        local disp = {}
        map = {}
        for _, o in ipairs(opts or {}) do
            local d = clean(o)
            if d == "" then d = tostring(o) end
            disp[#disp + 1] = d
            map[d] = o
        end
        return disp
    end
    local disp = build(options)
    local startVal = disp[1] or "None"
    for _, o in ipairs(options or {}) do if o == default then startVal = clean(o) end end
    local dd = sec(page):Dropdown({ Name = clean(text), Flag = flagOf(page, text), Options = disp, Default = startVal,
        Callback = wrapCb(function(v) if cb then cb(map[v] ~= nil and map[v] or v) end end) })
    local function update(newOpts)
        local d2 = build(newOpts)
        pcall(function() dd.RefreshOptions(d2) end)
        if d2[1] then pcall(function() dd.Set(d2[1]) end) end
    end
    return dd, update
end
function UI:AddTextBox(page, text, placeholder, cb)
    local tb = sec(page):Textbox({ Name = clean(text), Flag = flagOf(page, text), PlaceHolder = placeholder or "Type here...", Callback = wrapCb(cb) })
    return tb, function() return Flags and Flags[flagOf(page, text)] or "" end
end
function UI:AddKeybind(page, text, default, cb)
    sec(page):Label({ Name = clean(text) }):Keybind({ Name = clean(text), Flag = flagOf(page, text), Key = default, Mode = "Hold", Callback = wrapCb(cb) })
end
function UI:Fire(label)
    local it = Registry[clean(label)]
    if not it then return end
    if it.type == "toggle" then
        local new = not it.obj.Enabled
        it.obj.Set(new)
        return new
    elseif it.type == "button" then
        pcall(it.cb)
        return true
    end
end

local function SkidServerHop()
    task.spawn(function()
        local ok, err = pcall(function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local body = game:HttpGet(url)
            local data = HttpService:JSONDecode(body)
            local pick = {}
            for _, s in ipairs(data.data or {}) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then table.insert(pick, s.id) end
            end
            if #pick == 0 then Notify("Server", "No other server found", 3) return end
            Notify("Server", "Hopping...", 2)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, pick[math.random(1, #pick)], LocalPlayer)
        end)
        if not ok then Notify("Server", "Hop failed", 3) end
    end)
end

;(function()
local MainTab = UI:AddTab("Main", "🏠", 1)
local MoneyTab = UI:AddTab("Money/Bank", "💰", 2)
local ExploitsTab = UI:AddTab("Exploits", "💀", 3)
local FarmTab = UI:AddTab("Farm", "🌾", 4)
local CombatTab = UI:AddTab("Combat", "⚔️", 5)
local TrollingTab = UI:AddTab("Trolling", "😈", 6)
local QuickBuysTab = UI:AddTab("Quick Buys", "🛒", 7)
local SettingsTab = UI:AddTab("Misc", "⚙️", 9)
local CreditsTab = UI:AddTab("Credits", "ℹ️", 10)
local playerNames = {}
local function refreshPlayerList()
    playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playerNames, p.Name) end
    end
    table.sort(playerNames)
    return playerNames
end
refreshPlayerList()
SelectedPlayer = playerNames[1]
UI:AddSection(MainTab, "Player Select")
local playerDropdown, updatePlayerDropdown = UI:AddDropdown(MainTab, "Select Player", playerNames, playerNames[1], function(opt)
    SelectedPlayer = opt
end)
UI:AddButton(MainTab, "🔄 Refresh Players", function()
    local newList = refreshPlayerList()
    updatePlayerDropdown(newList)
    SelectedPlayer = newList[1] or nil
    Notify("Players", "Refreshed! " .. #newList .. " players", 2)
end)
UI:AddButton(MainTab, "TP to Player", function()
    if not SelectedPlayer then return end
    local p = Players:FindFirstChild(SelectedPlayer)
    if not p or not p.Character then Notify("TP","Player not found!",2) return end
    local tgtHRP = p.Character:FindFirstChild("HumanoidRootPart"); if not tgtHRP then return end
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
    enableSwimMethod()
    task.wait(1)
    myHRP.CFrame = tgtHRP.CFrame * CFrame.new(3, 0, 0)
    task.delay(0.2, disableSwimMethod)
    Notify("TP", SelectedPlayer, 2)
end)
UI:AddButton(MainTab, "View Inventory", function()
    if SelectedPlayer then
        local p = Players:FindFirstChild(SelectedPlayer)
        if p then
            local items = {}
            for _, tool in pairs(p.Backpack:GetChildren()) do
                if tool:IsA("Tool") then table.insert(items, tool.Name) end
            end
            if p.Character then
                for _, tool in pairs(p.Character:GetChildren()) do
                    if tool:IsA("Tool") then table.insert(items, tool.Name .. " [E]") end
                end
            end
            Notify("Inv", #items > 0 and table.concat(items, ", ") or "Empty", 5)
        end
    end
end)
UI:AddButton(MainTab, "Clone Player", function()
    if SelectedPlayer then
        local p = Players:FindFirstChild(SelectedPlayer)
        if p and p.Character then
            local char = LocalPlayer.Character
            if char then
                pcall(function()
                    for _, item in pairs(p.Character:GetChildren()) do
                        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                            local existing = char:FindFirstChildOfClass(item.ClassName)
                            if existing then existing:Destroy() end
                            item:Clone().Parent = char
                        end
                    end
                end)
                Notify("Clone", "Cloned " .. SelectedPlayer, 3)
            end
        end
    end
end)
local spectateEnabled = false
UI:AddToggle(MainTab, "Spectate Player", false, function(state)
    spectateEnabled = state
    if state then
        if SelectedPlayer then
            local p = Players:FindFirstChild(SelectedPlayer)
            if p and p.Character and p.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
                Notify("Spectate", "Watching " .. SelectedPlayer, 2)
            end
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
        Notify("Spectate", "Off", 2)
    end
end)
local bringPlayerEnabled = false
UI:AddToggle(MainTab, "Bring Player", false, function(state)
    bringPlayerEnabled = state
    if state and SelectedPlayer then
        local targetPlayer = Players:FindFirstChild(SelectedPlayer)
        task.spawn(function()
            while bringPlayerEnabled do
                local tCharacter = targetPlayer and targetPlayer.Character
                local tRoot = tCharacter and tCharacter:FindFirstChild("HumanoidRootPart")
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not tRoot or not myHRP then break end
                local tHumanoid = tCharacter:FindFirstChildOfClass("Humanoid")
                if tHumanoid then tHumanoid.Sit = false end
                tRoot.CFrame = myHRP.CFrame + Vector3.new(3, 1, 0)
                task.wait(0.1)
            end
        end)
        Notify("Bring", "Bringing " .. SelectedPlayer, 2)
    end
end)
UI:AddButton(MainTab, "Kill Player", function()
    if not SelectedPlayer then Notify("Kill","Select a player first!",2) return end
    local p = Players:FindFirstChild(SelectedPlayer)
    if not p or not p.Character then Notify("Kill","Player not found!",2) return end
    if not hasGunInHand() then BigGunNotify("nogun"); return end
    BigGunNotify("ammo")
    task.spawn(function() wsSlimeKill(p) end)
    Notify("Kill","Killed "..SelectedPlayer,2)
end)
local killLoopEnabled = false
UI:AddToggle(MainTab, "Kill Loop (FAST)", false, function(state)
    killLoopEnabled = state
    getgenv().killSelectedRunning = state
    if state then
        if not SelectedPlayer then Notify("Kill Loop","Select player first!",2); killLoopEnabled=false; getgenv().killSelectedRunning=false; return end
        if not hasGunInHand() then BigGunNotify("nogun"); killLoopEnabled=false; getgenv().killSelectedRunning=false; return end
        BigGunNotify("ammo")
        Notify("Kill Loop","Started on "..SelectedPlayer,2)
        task.spawn(function()
            local hrp0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local origin = hrp0 and hrp0.CFrame
            while getgenv().killSelectedRunning do
                local p = Players:FindFirstChild(SelectedPlayer)
                local th = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if p and p ~= LocalPlayer and th and hum and hum.Health > 0 and h then
                    checkgun()
                    pcall(function() local s = GetGunSettings(); if s then s.LimitedAmmoEnabled=false; s.Ammo=80000; s.AmmoPerMag=80000; s.MagCount=80000; s.StoredAmmo=80000; s.MaxAmmo=80000 end end)
                    pcall(function() h.CFrame = th.CFrame end)
                    pcall(function() h.Anchored = true end)
                    task.wait(0.1)
                    pcall(function() KillGunMod(p, "Head", math.huge) end)
                    task.wait(0.1)
                    pcall(function() KillGunMod(p, "Head", math.huge) end)
                    pcall(function() h.Anchored = false end)
                    local h2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if h2 and origin then pcall(function() h2.CFrame = origin end) end
                else

                    if h and origin then pcall(function() h.CFrame = origin end) end
                    while getgenv().killSelectedRunning do
                        local tt = Players:FindFirstChild(SelectedPlayer); if not tt then break end
                        local hh = tt.Character and tt.Character:FindFirstChildOfClass("Humanoid")
                        if hh and hh.Health > 0 then break end
                        task.wait(0.3)
                    end
                    if getgenv().killSelectedRunning then task.wait(10) end
                end
            end
            local hf = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hf and origin then pcall(function() hf.CFrame = origin end) end
        end)
    else
        Notify("Kill Loop","Stopped",2)
    end
end)
local knifeKillEnabled = false
UI:AddToggle(MainTab, "🔪 Knife Kill Selected", false, function(state)
    knifeKillEnabled = state
    getgenv()._wsKnifeRunning = state
    if not state then getgenv()._wsKnifeRunning=false; Notify("Knife","Stopped",2); return end
    if not SelectedPlayer then Notify("Knife","Select a player first!",2); knifeKillEnabled=false; getgenv()._wsKnifeRunning=false; return end
    Notify("Knife","Knife killing "..SelectedPlayer,2)
    task.spawn(function()

        local function equipKnife()
            local char=LocalPlayer.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return false end
            local cur=char:FindFirstChildWhichIsA("Tool"); if cur and allowedKnifeTools[cur.Name] then return true end
            local bp=LocalPlayer:FindFirstChild("Backpack")
            for _,t in pairs((bp and bp:GetChildren()) or {}) do if t:IsA("Tool") and allowedKnifeTools[t.Name] then pcall(function() hum:EquipTool(t) end); return true end end
            for _,t in pairs(char:GetChildren()) do if t:IsA("Tool") and allowedKnifeTools[t.Name] then pcall(function() hum:EquipTool(t) end); return true end end
            return false
        end
        if not equipKnife() then

            pcall(function() ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("Blade") end)
            local t0=tick(); repeat task.wait(0.2) until equipKnife() or (tick()-t0>6) or not getgenv()._wsKnifeRunning
            if not equipKnife() then BigGunNotify("noknife"); getgenv()._wsKnifeRunning=false; knifeKillEnabled=false; return end
        end
        getgenv().SwimMethod = true
        local hrp0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local origin = hrp0 and hrp0.CFrame
        while getgenv()._wsKnifeRunning do
            local me = LocalPlayer.Character
            local myhrp = me and me:FindFirstChild("HumanoidRootPart")
            local tool = me and me:FindFirstChildWhichIsA("Tool")
            local atk = GetAttackEvent(tool)
            local t = Players:FindFirstChild(SelectedPlayer)
            local tHRP = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            local tHum = t and t.Character and t.Character:FindFirstChildOfClass("Humanoid")
            if myhrp and atk and tHRP and tHum and tHum.Health > 0 then
                pcall(function() myhrp.CFrame = tHRP.CFrame * CFrame.new(0,0,1.2) end)
                pcall(function() atk:FireServer() end)
            end
            task.wait(0.05)
        end
        task.delay(0.3, function() getgenv().SwimMethod=false end)
        local hf = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hf and origin then pcall(function() hf.CFrame = origin end) end
    end)
end)
UI:AddSection(MainTab, "🎮 Player Cheats")
local flyConnections = {}
local flyVelocity = nil
local flyGyro = nil
local flySeat = nil
local flySpeed = 80
local flyMobile = {fwd=false,back=false,left=false,right=false}
local flyMobileGui = nil
local function destroyFlyMobileGui()
    if flyMobileGui then pcall(function() flyMobileGui:Destroy() end); flyMobileGui=nil end
    for k in pairs(flyMobile) do flyMobile[k]=false end
end
local function buildFlyMobileGui()
    destroyFlyMobileGui()
    if not UserInputService.TouchEnabled then return end
    flyMobileGui=Instance.new("ScreenGui"); flyMobileGui.Name="WalFlyMobile"; flyMobileGui.ResetOnSpawn=false
    flyMobileGui.DisplayOrder=9997; flyMobileGui.IgnoreGuiInset=true; flyMobileGui.Parent=CoreGui
    local function Btn(label,xScale,yOffset,color)
        local b=Instance.new("TextButton",flyMobileGui); b.AnchorPoint=Vector2.new(0.5,1)
        b.Size=UDim2.new(0,65,0,65); b.Position=UDim2.new(xScale,0,1,yOffset)
        b.BackgroundColor3=color or Color3.fromRGB(0,100,200); b.BackgroundTransparency=0.2
        b.Text=label; b.TextColor3=Color3.fromRGB(255,255,255); b.TextSize=28
        b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.ZIndex=10; b.AutoButtonColor=false
        Instance.new("UICorner",b).CornerRadius=UDim.new(0.3,0); return b
    end
    local fwdBtn=Btn("▲",0.15,-240); local backBtn=Btn("▼",0.15,-100)
    local leftBtn=Btn("◄",0.08,-170); local rightBtn=Btn("►",0.22,-170)
    local upBtn=Btn("🔼",0.88,-175,Color3.fromRGB(0,160,80)); local downBtn=Btn("🔽",0.88,-95,Color3.fromRGB(180,40,40))
    local function wire(btn,key)
        btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then flyMobile[key]=true; btn.BackgroundTransparency=0.05 end end)
        btn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then flyMobile[key]=false; btn.BackgroundTransparency=0.2 end end)
    end
    wire(fwdBtn,"fwd"); wire(backBtn,"back"); wire(leftBtn,"left"); wire(rightBtn,"right")
end
local function cleanupFly()
    destroyFlyMobileGui()
    for _, conn in ipairs(flyConnections) do
        if conn and conn.Disconnect then
            pcall(function() conn:Disconnect() end)
        end
    end
    flyConnections = {}
    if flyVelocity and flyVelocity.Parent then flyVelocity:Destroy(); flyVelocity = nil end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy(); flyGyro = nil end
    if flySeat and flySeat.Parent then flySeat:Destroy(); flySeat = nil end
    getgenv().SwimMethod = false
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp then
            pcall(function()
                humanoid:ChangeState(0); task.wait(0.1); humanoid:ChangeState(2)
                humanoid.PlatformStand = false; humanoid.Jump = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end
local function setupFly()
    cleanupFly()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    getgenv().SwimMethod = true
    local seat = Instance.new("VehicleSeat")
    seat.Name = "FlySeat"; seat.Anchored = false; seat.CanCollide = false
    seat.Transparency = 1; seat.TopSurface = Enum.SurfaceType.Smooth
    seat.BottomSurface = Enum.SurfaceType.Smooth; seat.Parent = workspace
    seat.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
    local weld = Instance.new("Weld")
    weld.Part0 = seat; weld.Part1 = hrp; weld.C0 = CFrame.new(0, 3, 0); weld.Parent = seat
    seat:Sit(humanoid)
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9); flyVelocity.Velocity = Vector3.zero; flyVelocity.Parent = hrp
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9); flyGyro.P = 50000; flyGyro.D = 1000
    flyGyro.CFrame = hrp.CFrame; flyGyro.Parent = hrp
    flySeat = seat
    buildFlyMobileGui()
    local move = {W=false,A=false,S=false,D=false,Space=false,Shift=false}
    local inputBegan = UserInputService.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.W then move.W = true end
        if i.KeyCode == Enum.KeyCode.A then move.A = true end
        if i.KeyCode == Enum.KeyCode.S then move.S = true end
        if i.KeyCode == Enum.KeyCode.D then move.D = true end
        if i.KeyCode == Enum.KeyCode.Space then move.Space = true end
        if i.KeyCode == Enum.KeyCode.LeftShift then move.Shift = true end
        if i.KeyCode == Enum.KeyCode.E then flySpeed = math.clamp(flySpeed + 10, 20, 300) end
        if i.KeyCode == Enum.KeyCode.Q then flySpeed = math.clamp(flySpeed - 10, 20, 300) end
    end)
    table.insert(flyConnections, inputBegan)
    local inputEnded = UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.W then move.W = false end
        if i.KeyCode == Enum.KeyCode.A then move.A = false end
        if i.KeyCode == Enum.KeyCode.S then move.S = false end
        if i.KeyCode == Enum.KeyCode.D then move.D = false end
        if i.KeyCode == Enum.KeyCode.Space then move.Space = false end
        if i.KeyCode == Enum.KeyCode.LeftShift then move.Shift = false end
    end)
    table.insert(flyConnections, inputEnded)
    local renderStepped = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not flyVelocity or not flyGyro then return end
        if not getgenv().SwimMethod then getgenv().SwimMethod = true end
        local cam = workspace.CurrentCamera
        flyGyro.CFrame = cam.CFrame
        local dir = Vector3.zero
        if not UserInputService.TouchEnabled then
            if move.W then dir = dir + cam.CFrame.LookVector end
            if move.S then dir = dir - cam.CFrame.LookVector end
            if move.A then dir = dir - cam.CFrame.RightVector end
            if move.D then dir = dir + cam.CFrame.RightVector end
            if move.Space then dir = dir + Vector3.new(0,1,0) end
            if move.Shift then dir = dir - Vector3.new(0,1,0) end
        else
            if flyMobile.fwd   then dir = dir + cam.CFrame.LookVector end
            if flyMobile.back  then dir = dir - cam.CFrame.LookVector end
            if flyMobile.left  then dir = dir - cam.CFrame.RightVector end
            if flyMobile.right then dir = dir + cam.CFrame.RightVector end
            if dir.Magnitude < 0.01 then
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if h then
                    local md = h.MoveDirection
                    if md.Magnitude > 0.1 then
                        dir = (cam.CFrame.RightVector * md.X) + (cam.CFrame.LookVector * -md.Z)
                    end
                end
            end
        end
        flyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end)
    table.insert(flyConnections, renderStepped)
    Notify("Fly", "Active! WASD to move, E/Q for speed", 3)
end
UI:AddToggle(MainTab, "Player Fly", false, function(state)
    flyEnabled = state
    if state then task.spawn(setupFly) else cleanupFly(); Notify("Fly", "Disabled", 2) end
end)
UI:AddSlider(MainTab, "Fly Speed", 20, 300, 80, function(val) flySpeed = val end)
UI:AddButton(MainTab, "Bring Nearest Car", function()
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 3)
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not hum then return end
        local nearestCar, nearestDist = nil, math.huge
        local CivCars = workspace:FindFirstChild("CivCars")
        if CivCars then
            for _, car in ipairs(CivCars:GetChildren()) do
                if car:IsA("Model") then
                    local seat = car:FindFirstChild("DriveSeat")
                    if seat and not seat.Occupant then
                        if not car.PrimaryPart then
                            local body = car:FindFirstChild("Body")
                            car.PrimaryPart = (body and body:FindFirstChild("#Weight")) or seat
                        end
                        if car.PrimaryPart then
                            local dist = (car.PrimaryPart.Position - hrp.Position).Magnitude
                            if dist < nearestDist then nearestDist = dist; nearestCar = car end
                        end
                    end
                end
            end
        end
        if not nearestCar then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") and not v.Occupant then
                    local model = v:FindFirstAncestorOfClass("Model")
                    if model then
                        local dist = (v.Position - hrp.Position).Magnitude
                        if dist < nearestDist then nearestDist = dist; nearestCar = model end
                    end
                end
            end
        end
        if not nearestCar then Notify("Car","No free car found!",2) return end
        local seat = nearestCar:FindFirstChild("DriveSeat") or nearestCar:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then Notify("Car","No seat!",2) return end
        if not nearestCar.PrimaryPart then nearestCar.PrimaryPart = nearestCar:FindFirstChildWhichIsA("BasePart") or seat end
        nearestCar:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0,0,-6) * CFrame.Angles(0,math.rad(180),0))
        seat:Sit(hum)
        Notify("Car","Car brought!",2)
    end)
end)
do
local cfHum, cfSeat, cfCar, cfRoot
local cfBV, cfBG, cfLastCar
local function cfCleanup()
    if cfBV then cfBV:Destroy(); cfBV=nil end
    if cfBG then cfBG:Destroy(); cfBG=nil end
end
local function cfSetup()
    cfCleanup()
    if not Config.TheBronx.carfly then return end
    local char=LocalPlayer.Character; if not char then return end
    cfHum=char:FindFirstChildWhichIsA("Humanoid"); if not cfHum then return end
    cfSeat=cfHum.SeatPart; if not cfSeat or not cfSeat:IsA("VehicleSeat") then return end
    cfCar=cfSeat.Parent; if not cfCar then return end
    cfRoot=cfCar.PrimaryPart; if not cfRoot then return end
    cfLastCar=cfCar
    for _,v in ipairs(cfCar:GetChildren()) do
        if v:IsA("BasePart") and not v.Name:lower():find("wheel") then v.CanCollide=false end
    end
    cfBV=Instance.new("BodyVelocity"); cfBV.MaxForce=Vector3.new(1e9,1e9,1e9); cfBV.Velocity=Vector3.zero; cfBV.Parent=cfRoot
    cfBG=Instance.new("BodyGyro"); cfBG.MaxTorque=Vector3.new(1e9,1e9,1e9); cfBG.P=25000; cfBG.D=1500; cfBG.CFrame=cfRoot.CFrame; cfBG.Parent=cfRoot
end
task.spawn(function()
    while true do task.wait(0.2)
        local char=LocalPlayer.Character
        if char then
            local h=char:FindFirstChildWhichIsA("Humanoid")
            if h then
                local seat=h.SeatPart
                if seat and seat:IsA("VehicleSeat") then
                    if seat.Parent~=cfLastCar then cfSetup() end
                else if cfLastCar then cfCleanup(); cfLastCar=nil end end
            end
        end
    end
end)
local cfMGui=nil
local cfMUp,cfMDown,cfMFwd,cfMBack,cfMLeft,cfMRight=false,false,false,false,false,false
local function destroyCFMobile()
    if cfMGui then pcall(function() cfMGui:Destroy() end); cfMGui=nil end
    cfMUp=false;cfMDown=false;cfMFwd=false;cfMBack=false;cfMLeft=false;cfMRight=false
end
local function buildCFMobile()
    destroyCFMobile(); if not UserInputService.TouchEnabled then return end
    cfMGui=Instance.new("ScreenGui"); cfMGui.Name="WalCFMobile"; cfMGui.ResetOnSpawn=false
    cfMGui.DisplayOrder=9998; cfMGui.IgnoreGuiInset=true
    pcall(function() cfMGui.Parent=LocalPlayer:WaitForChild("PlayerGui") end)
    local function Btn(lbl,xs,yo)
        local b=Instance.new("TextButton",cfMGui); b.AnchorPoint=Vector2.new(0.5,1); b.Size=UDim2.new(0,65,0,65)
        b.Position=UDim2.new(xs,0,1,yo); b.BackgroundColor3=Color3.fromRGB(0,100,200); b.BackgroundTransparency=0.2
        b.Text=lbl; b.TextColor3=Color3.fromRGB(255,255,255); b.TextSize=28; b.Font=Enum.Font.GothamBold
        b.BorderSizePixel=0; b.ZIndex=10; b.AutoButtonColor=false; Instance.new("UICorner",b).CornerRadius=UDim.new(0.3,0); return b
    end
    local T=Enum.UserInputType.Touch
    local fB=Btn("▲",0.15,-240); local bB=Btn("▼",0.15,-100); local lB=Btn("◀",0.08,-170)
    local rB=Btn("▶",0.22,-170); local uB=Btn("🔼",0.88,-175); local dB=Btn("🔽",0.88,-95)
    fB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMFwd=true end end); fB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMFwd=false end end)
    bB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMBack=true end end); bB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMBack=false end end)
    lB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMLeft=true end end); lB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMLeft=false end end)
    rB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMRight=true end end); rB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMRight=false end end)
    uB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMUp=true end end); uB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMUp=false end end)
    dB.InputBegan:Connect(function(i) if i.UserInputType==T then cfMDown=true end end); dB.InputEnded:Connect(function(i) if i.UserInputType==T then cfMDown=false end end)
end
RunService.RenderStepped:Connect(function()
    if not Config.TheBronx.carfly then cfCleanup(); return end
    if not cfHum or cfHum.SeatPart~=cfSeat then return end
    if not cfRoot or not cfBV or not cfBG then cfSetup(); return end
    local speed=Config.TheBronx.carflyspeed or 120
    local cam=workspace.CurrentCamera; local camCF=cam.CFrame; local camLook=camCF.LookVector; local camRight=camCF.RightVector
    if not UserInputService.TouchEnabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then cfBG.CFrame=CFrame.lookAt(cfRoot.Position,cfRoot.Position+camLook) end
        local move=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move=move+camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move=move-camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move=move-camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move=move+camRight end
        cfBV.Velocity=move.Magnitude>0 and move.Unit*speed or Vector3.zero
    else
        cfBG.CFrame=CFrame.lookAt(cfRoot.Position,cfRoot.Position+camLook)
        local flatFwd=Vector3.new(camLook.X,0,camLook.Z); if flatFwd.Magnitude>0.001 then flatFwd=flatFwd.Unit end
        local move=Vector3.zero
        local usingDpad = cfMFwd or cfMBack or cfMLeft or cfMRight or cfMUp or cfMDown
        if usingDpad then
            if cfMFwd then move=move+flatFwd end
            if cfMBack then move=move-flatFwd end
            if cfMLeft then move=move-camRight end
            if cfMRight then move=move+camRight end
            if cfMUp then move=move+Vector3.new(0,1,0) end
            if cfMDown then move=move-Vector3.new(0,1,0) end
        else
            local h2=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if h2 then
                local md=h2.MoveDirection
                if md.Magnitude>0 then local cl=Vector3.new(camLook.X,0,camLook.Z).Unit; move=(camRight*md.X)+(cl*-md.Z) end
                if h2:GetState()==Enum.HumanoidStateType.Jumping then move=move+Vector3.new(0,0.8,0) end
            end
        end
        cfBV.Velocity=move.Magnitude>0 and move.Unit*speed or Vector3.zero
    end
end)
task.spawn(function()
    while true do task.wait(0.5)
        if Config.TheBronx.carfly and cfSeat then buildCFMobile() else destroyCFMobile() end
    end
end)
LocalPlayer.CharacterAdded:Connect(cfCleanup)
UI:AddToggle(MainTab, "Car Fly", false, function(state)
    Config.TheBronx.carfly = state
    if state then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
                cfSetup()
                Notify("Car Fly","Active! WASD to fly",3)
            else
                Notify("Car Fly","Get in a car then enable!",3)
            end
        end
    else
        cfCleanup(); Notify("Car Fly","Disabled",2)
    end
end)
UI:AddSlider(MainTab, "Car Fly Speed", 20, 300, 120, function(val)
    Config.TheBronx.carflyspeed = val
end)
UI:AddToggle(MainTab, "WalkSpeed (3s delay)", false, function(state)
    enhancedWalk = state
    if state then
        local character = LocalPlayer.Character; if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        hrp.AssemblyLinearVelocity = Vector3.zero; getgenv().SwimMethod = true
        Notify("WalkSpeed", "Bypassing anti-cheat (3s)...", 3)
        local freezeConn
        freezeConn = RunService.RenderStepped:Connect(function()
            if enhancedWalk and hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
        end)
        task.delay(3, function()
            if freezeConn then freezeConn:Disconnect() end
            if not enhancedWalk then return end
            local bodyGyro2 = Instance.new("BodyGyro")
            bodyGyro2.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro2.P = 50000; bodyGyro2.D = 1000; bodyGyro2.CFrame = hrp.CFrame; bodyGyro2.Parent = hrp
            local moveConn
            moveConn = RunService.RenderStepped:Connect(function()
                if not enhancedWalk then
                    if bodyGyro2 then bodyGyro2:Destroy() end
                    if moveConn then moveConn:Disconnect() end
                    return
                end
                local camera = workspace.CurrentCamera; local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
                if dir.Magnitude == 0 and humanoid then local md = humanoid.MoveDirection; dir = Vector3.new(md.X, 0, md.Z) end
                if dir.Magnitude > 0 then dir = dir.Unit * speed end
                local currentY = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X, math.clamp(currentY, -100, -2), dir.Z)
                if dir.Magnitude > 0 then local look = dir.Unit; bodyGyro2.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z)) end
                hrp.RotVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero
            end)
            Notify("WalkSpeed", "Enabled! Move now", 2)
        end)
    else getgenv().SwimMethod = false; Notify("WalkSpeed", "Disabled", 2) end
end)
UI:AddSlider(MainTab, "Walk Speed", 16, 500, 16, function(val) speed = val end)
UI:AddSection(MainTab, "🔫 Gun Mods (Toggles)")
UI:AddButton(MainTab, "Infinite Ammo", function()
    local char = LocalPlayer.Character
    if not char then Notify("Ammo","No character!",2) return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then Notify("Ammo","Equip a gun first!",2) return end
    local settings, _ = GetGunSettings()
    if settings then
        settings.LimitedAmmoEnabled = false
        settings.MaxAmmo = 80000
        settings.AmmoPerMag = 80000
        settings.Ammo = 80000
        settings.StoredAmmo = 80000
        settings.MagCount = 80000
    end
    local gunScript = tool:FindFirstChild("GunScript_Local")
    if gunScript then
        pcall(function() debug.setupvalue(getsenv(gunScript).Reload, 3, 80000) end)
        pcall(function() debug.setupvalue(getsenv(gunScript).Reload, 5, 80000) end)
        Notify("Ammo","✅ Infinite Ammo (80000) — press R to reload for max",2)
    else
        Notify("Ammo","✅ Ammo values set to 80000",2)
    end
end)
local noRecoilEnabled = false
UI:AddToggle(MainTab, "No Recoil", false, function(state)
    noRecoilEnabled = state
    if state then task.spawn(function() while noRecoilEnabled do local s=GetGunSettings(); if s then s.Recoil=0 end; task.wait(0.5) end end) end
end)
local autoGunEnabled = false
UI:AddToggle(MainTab, "Auto Gun", false, function(state)
    autoGunEnabled = state
    if state then task.spawn(function() while autoGunEnabled do local s=GetGunSettings(); if s then s.Auto=true end; task.wait(0.5) end end) end
end)
local noFireRateEnabled = false
UI:AddToggle(MainTab, "No Fire Rate", false, function(state)
    noFireRateEnabled = state
    if state then task.spawn(function() while noFireRateEnabled do local s=GetGunSettings(); if s then s.FireRate=0.1 end; task.wait(0.5) end end) end
end)
local infDamageEnabled = false
UI:AddToggle(MainTab, "Inf Damage", false, function(state)
    infDamageEnabled = state
    if state then task.spawn(function() while infDamageEnabled do local s=GetGunSettings(); if s then s.BaseDamage=9e9 end; task.wait(0.5) end end) end
end)
local noSpreadEnabled = false
UI:AddToggle(MainTab, "No Spread", false, function(state)
    noSpreadEnabled = state
    if state then task.spawn(function() while noSpreadEnabled do local s=GetGunSettings(); if s then pcall(function() s.SpreadXY=0; s.SpreadYX=0; s.Spread=0; s.SpreadX=0; s.SpreadY=0 end) end; task.wait(0.5) end end) end
end)
local noJamEnabled = false
UI:AddToggle(MainTab, "No Jam", false, function(state)
    noJamEnabled = state
    if state then task.spawn(function() while noJamEnabled do local s=GetGunSettings(); if s then pcall(function() s.JamChance=0 end) end; task.wait(0.5) end end) end
end)
local gunColors = {"💖 Neon Pink", "💙 Neon Blue", "❤️ Neon Red", "💚 Neon Green", "💜 Neon Purple", "🤍 Neon White"}
UI:AddDropdown(MainTab, "Gun Color (NEON)", gunColors, gunColors[1], function(opt)
    local colorMap = {["💖 Neon Pink"]=Color3.fromRGB(255,105,180),["💙 Neon Blue"]=Color3.fromRGB(0,170,255),["❤️ Neon Red"]=Color3.fromRGB(255,0,0),["💚 Neon Green"]=Color3.fromRGB(0,255,0),["💜 Neon Purple"]=Color3.fromRGB(170,0,255),["🤍 Neon White"]=Color3.fromRGB(255,255,255)}
    local char = LocalPlayer.Character; local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and colorMap[opt] then
        for _, part in pairs(tool:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "Handle" then part.Color = colorMap[opt]; part.Material = Enum.Material.Neon end end
        Notify("Gun Color", opt .. " applied!", 2)
    end
end)
local rainbowGunEnabled = false
UI:AddToggle(MainTab, "Rainbow Gun (NEON)", false, function(state)
    rainbowGunEnabled = state
    if state then task.spawn(function() while rainbowGunEnabled do local char=LocalPlayer.Character; local tool=char and char:FindFirstChildOfClass("Tool"); if tool then local color=Color3.fromHSV(tick()%1,1,1); for _,part in pairs(tool:GetDescendants()) do if part:IsA("BasePart") and part.Name~="Handle" then part.Color=color; part.Material=Enum.Material.Neon end end end; task.wait(0.05) end end) end
end)
GunSkins = {
    "rbxassetid://83922435917330",
    "rbxassetid://75965794858060",
    "rbxassetid://104925026556009",
    "rbxassetid://113000073171004",
    "rbxassetid://139546409781319"
}
function ApplySkin(tool, imageId)
    if not tool then return end
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("MeshPart") then
            -- mesh gun bodies are skinned via TextureID (decals don't show on meshes)
            pcall(function() obj.TextureID = imageId end)
            pcall(function() obj.Color = Color3.fromRGB(255,255,255) end)
        elseif obj:IsA("BasePart") then
            for _, child in ipairs(obj:GetChildren()) do
                if child.Name == "ScorpioSkin" then child:Destroy() end
            end
            for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                local decal = Instance.new("Decal")
                decal.Name = "ScorpioSkin"
                decal.Texture = imageId
                decal.Face = face
                decal.Parent = obj
            end
        end
        if obj:IsA("SpecialMesh") then
            -- legacy meshes inside Parts
            pcall(function() obj.TextureId = imageId end)
        end
    end
end
UI:AddToggle(MainTab, "Galaxy Skins", false, function(Value)
    getgenv()._galaxySkins = Value
    if Value then
        task.spawn(function()
            local index = 1
            while getgenv()._galaxySkins do
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then ApplySkin(tool, GunSkins[index]) end
                index = index + 1
                if index > #GunSkins then index = 1 end
                task.wait(2)
            end
        end)
    end
end)
UI:AddSection(MoneyTab, "💰 Dirty Money")
local function GetGoodCleaner()
    local CounterInstance = nil
    local mapFolder = workspace:FindFirstChild("1# Map")
    if mapFolder then
        for _,v in mapFolder:GetChildren() do
            if v:FindFirstChild("CounterM") then CounterInstance = v break end
        end
    end
    local searchTables = {workspace:FindFirstChild("CounterBag") and workspace.CounterBag:GetChildren() or {}}
    if CounterInstance then table.insert(searchTables, CounterInstance:GetChildren()) end
    for _,tbl in pairs(searchTables) do
        for _,v in pairs(tbl) do
            local cp = v:FindFirstChild("CashPrompt", true)
            local gp = v:FindFirstChild("GrabPrompt", true)
            if cp and cp.Enabled and cp.ObjectText == "Count Bread" and gp and not gp.Enabled then return v end
        end
    end
    return nil
end
UI:AddButton(MoneyTab, "Count Dirty Money", function() task.spawn(function() pcall(function()
    local fs = 0; pcall(function() fs = LocalPlayer.stored.FilthyStack.Value end)
    if fs == 0 then Notify("Auto Clean","You have no dirty money!",3) return end
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health == 0 then return end
    local Cleaner = GetGoodCleaner()
    if not Cleaner then Notify("Auto Clean","Could not find a valid cleaner!",3) return end
    local OldCF = character.HumanoidRootPart.CFrame
    Notify("Auto Clean","Cleaning money...",3)
    BypassTp(Cleaner.WorldPivot)
    task.wait(0.4)
    pcall(function() fireproximityprompt(Cleaner:FindFirstChild("CashPrompt", true)) end)
    local onLight = Cleaner:FindFirstChild("On", true)
    if onLight then repeat task.wait() until onLight.Color == Color3.fromRGB(74,156,69) end
    task.wait(0.5)
    pcall(function() fireproximityprompt(Cleaner:FindFirstChild("CashPrompt", true)) end)
    task.wait(0.25)
    BypassTp(Cleaner.WorldPivot)
    task.wait(0.4)
    repeat task.wait() until LocalPlayer.Backpack:FindFirstChild("MoneyReady")
    humanoid:EquipTool(LocalPlayer.Backpack["MoneyReady"])
    repeat
        pcall(function() fireproximityprompt(Cleaner:FindFirstChild("GrabPrompt", true)) end)
        task.wait(3)
    until not character:FindFirstChild("MoneyReady")
    repeat task.wait(1) until LocalPlayer.Backpack:FindFirstChild("BagOfMoney")
    BypassTp(CFrame.new(-1216.5113525390625, 253.8797607421875, -3635.7958984375))
    task.wait(0.3)
    pcall(function() ReplicatedStorage:WaitForChild("SetLookAngles"):FireServer(0.4, -0.1, false) end)
    humanoid:EquipTool(LocalPlayer.Backpack["BagOfMoney"])
    task.wait(2)
    local atmP = workspace:FindFirstChild("ATMMoney") and workspace.ATMMoney:FindFirstChildOfClass("ProximityPrompt")
    if atmP then pcall(function() fireproximityprompt(atmP) end) end
    BypassTp(OldCF)
    Notify("Auto Clean","Done! Money cleaned and deposited",3)
end) end) end)
UI:AddSection(MoneyTab, "🛒 Buy Items")
local buyItemsOptions = {"🍉 FijiWater", "💧 FreshWater", "🍎 Ice-Fruit Bag", "🥤 Ice-Fruit Cupz"}
UI:AddDropdown(MoneyTab, "Buy Items", buyItemsOptions, buyItemsOptions[1], function(opt)
    pcall(function()
        if opt == "🍉 FijiWater" then ReplicatedStorage.ExoticShopRemote:InvokeServer("FijiWater")
        elseif opt == "💧 FreshWater" then ReplicatedStorage.ExoticShopRemote:InvokeServer("FreshWater")
        elseif opt == "🍎 Ice-Fruit Bag" then ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Bag")
        elseif opt == "🥤 Ice-Fruit Cupz" then ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Cupz") end
    end)
    Notify("Bought", opt, 2)
end)
UI:AddButton(MoneyTab, "Buy All Cooking Items", function()
    pcall(function()
        ReplicatedStorage.ExoticShopRemote:InvokeServer("FijiWater"); task.wait(0.1)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("FreshWater"); task.wait(0.1)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Bag"); task.wait(0.1)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Cupz")
    end)
    Notify("Buy", "All cooking items bought!", 3)
end)
UI:AddSection(MoneyTab, "🍳 Cooking & Selling")
UI:AddButton(MoneyTab, "🍳 Go to Cook Spot", function()
    BypassTp(CFrame.new(-741.19, 262.96, -955.78)); Notify("TP", "Cook Spot", 2)
end)
UI:AddButton(MoneyTab, "💸 Generate Dirty Money", function()
    local player = LocalPlayer
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
    local camera = workspace.CurrentCamera
    local originalCameraType = camera.CameraType
    local originalFOV = camera.FieldOfView
    local tool = player.Backpack:FindFirstChild("Ice-Fruit Cupz")
    if tool then
        humanoid:EquipTool(tool)
        task.wait(1.0)
    else
        if not char:FindFirstChild("Ice-Fruit Cupz") then
            Notify("Error","Need Ice-Fruit Cupz in backpack!",3) return
        end
    end
    local blackScreen = Instance.new("ScreenGui")
    blackScreen.IgnoreGuiInset = true; blackScreen.Parent = CoreGui
    local frame = Instance.new("Frame", blackScreen)
    frame.BackgroundColor3 = Color3.new(0,0,0); frame.Size = UDim2.new(1,0,1,0); frame.BorderSizePixel = 0
    local msg = Instance.new("TextLabel", frame)
    msg.Text = "SKID HUB | GENERATING MONEY..."; msg.TextColor3 = Color3.fromRGB(0,200,80)
    msg.BackgroundTransparency = 1; msg.Size = UDim2.new(1,0,1,0); msg.Font = Enum.Font.GothamBold; msg.TextScaled = true
    local originalCFrame = hrp.CFrame
    local targetCFrame = CFrame.new(-69.82200622558594, 287.0635986328125, -319.79437255859375)
    enableSwimMethod()
    task.wait(1)
    hrp.CFrame = targetCFrame + Vector3.new(2, 0, 0)
    task.delay(0.25, disableSwimMethod)
    task.wait(0.5)
    camera.CameraType = Enum.CameraType.Scriptable
    local cameraOffset = Vector3.new(0, 5, 5)
    local camConn = RunService.Heartbeat:Connect(function()
        if hrp then camera.CFrame = CFrame.new(hrp.Position+cameraOffset, hrp.Position+Vector3.new(0,3,0)) end
    end)
    getgenv().instantPrompts = true
    local iceFruitSellPrompt = workspace:WaitForChild("IceFruit Sell"):FindFirstChildOfClass("ProximityPrompt")
    if iceFruitSellPrompt then
        iceFruitSellPrompt.HoldDuration = 0; iceFruitSellPrompt.MaxActivationDistance = 6
        local fireConn = RunService.Heartbeat:Connect(function()
            if getgenv().instantPrompts and iceFruitSellPrompt.Enabled then
                for _ = 1, 100 do
                    iceFruitSellPrompt:InputHoldBegin()
                    iceFruitSellPrompt:InputHoldEnd()
                end
            end
        end)
        task.spawn(function()
            task.wait(1)
            getgenv().instantPrompts = false
            fireConn:Disconnect()
            iceFruitSellPrompt.HoldDuration = 1; iceFruitSellPrompt.MaxActivationDistance = 4
            if camConn then camConn:Disconnect() end
            camera.CameraType = originalCameraType; camera.FieldOfView = originalFOV
            enableSwimMethod(); task.wait(0.5)
            hrp.CFrame = originalCFrame + Vector3.new(2,0,0)
            task.wait(0.5); disableSwimMethod()
            pcall(function() blackScreen:Destroy() end)
            Notify("Money","Done generating money!",3)
        end)
    else
        getgenv().instantPrompts = false
        if camConn then camConn:Disconnect() end
        camera.CameraType = originalCameraType
        hrp.CFrame = originalCFrame
        pcall(function() blackScreen:Destroy() end)
        Notify("Error","IceFruit Sell prompt not found!",3)
    end
end)
UI:AddToggle(MoneyTab, "Auto Deposit $30k", false, function(state)
    autoDeposit30k = state
    if state then task.spawn(function() while autoDeposit30k do pcall(function() ReplicatedStorage.BankAction:FireServer("depo", 30000) end); task.wait(0.5) end end) end
end)
local autoWithdraw90k = false
UI:AddToggle(MoneyTab, "Auto Withdraw $90k", false, function(state)
    autoWithdraw90k = state
    if state then task.spawn(function() while autoWithdraw90k do pcall(function() ReplicatedStorage.BankAction:FireServer("with", 90000) end); task.wait(0.5) end end) end
end)
UI:AddSection(MoneyTab, "💵 Money Tools")
local drop10kEnabled = false
UI:AddToggle(MoneyTab, "Drop $10k (Loop)", false, function(state)
    drop10kEnabled = state
    if state then task.spawn(function() while drop10kEnabled do pcall(function() ReplicatedStorage.BankProcessRemote:InvokeServer("Drop", 10000) end); task.wait(0.5) end end) end
end)
local drop5kEnabled = false
UI:AddToggle(MoneyTab, "Drop $5k (Loop)", false, function(state)
    drop5kEnabled = state
    if state then task.spawn(function() while drop5kEnabled do pcall(function() ReplicatedStorage.BankProcessRemote:InvokeServer("Drop", 5000) end); task.wait(0.5) end end) end
end)
UI:AddButton(MoneyTab, "Show Bank Balance", function()
    local amt = "N/A"; pcall(function() amt = tostring(LocalPlayer.stored.Bank.Value) end); Notify("Bank", "$" .. amt, 5)
end)
UI:AddSection(ExploitsTab, "🗺️ Teleport")
local locationNames = {}
for name, _ in pairs(locations) do table.insert(locationNames, name) end
table.sort(locationNames)
local selectedLocation = locationNames[1]
UI:AddDropdown(ExploitsTab, "📍 Select & Teleport", locationNames, locationNames[1], function(opt)
    if locations[opt] then BypassTp(CFrame.new(locations[opt])); Notify("TP", opt, 2) end
end)
UI:AddSection(ExploitsTab, "🎒 Drop Items")
local dropAllEnabled = false
UI:AddToggle(ExploitsTab, "Drop All Items (Loop)", false, function(state)
    dropAllEnabled = state
    getgenv().dropAllRunning = state
    if not state then Notify("Drop","Stopped dropping",2) return end
    Notify("Drop","Dropping all items...",2)
    task.spawn(function()
        local exempt = {["Fist"]=true, ["Fists"]=true, ["Phone"]=true}
        while getgenv().dropAllRunning do
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            local tools = {}
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and not exempt[tool.Name] then
                        table.insert(tools, tool)
                    end
                end
            end
            if bp then
                for _, tool in pairs(bp:GetChildren()) do
                    if tool:IsA("Tool") and not exempt[tool.Name] then
                        table.insert(tools, tool)
                    end
                end
            end
            if #tools == 0 then task.wait(0.5) end
            for _, tool in ipairs(tools) do
                if not getgenv().dropAllRunning then break end
                if char then
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum then hum:EquipTool(tool) end
                end
                task.wait(0.1)
                pcall(function()
                    ReplicatedStorage:WaitForChild("DropItemRemote"):FireServer(tool)
                end)
                task.wait(0.15)
            end
        end
    end)
end)
local passItemsLoopEnabled = false
UI:AddToggle(ExploitsTab, "Pass Items Loop", false, function(state)
    passItemsLoopEnabled = state
    if state then
        task.spawn(function()
            while passItemsLoopEnabled do
                pcall(function() ReplicatedStorage.DropRemote:FireServer("Drop") end)
                task.wait(0.5)
            end
        end)
        Notify("Items","Pass loop ON",2)
    else
        Notify("Items","Pass loop OFF",2)
    end
end)
UI:AddButton(ExploitsTab, "Pass to Nearest", function()
    pcall(function() ReplicatedStorage.DropRemote:FireServer("Drop") end)
    Notify("Items","Passed!",2)
end)
UI:AddSection(ExploitsTab, "🏷️ Nametag")
UI:AddToggle(ExploitsTab, "Show Nametag", true, function(state)
    nametagEnabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then local tag = char.Head:FindFirstChild("SkidHubTag"); if tag then tag.Enabled = state end end
    if state and char then CreateNametag(char) end
end)
UI:AddSection(ExploitsTab, "💰 Dupes & Exploits")
function GetSafe()
    local safe=nil
    pcall(function() safe=workspace:WaitForChild("HomeDoorSS",3):WaitForChild("HomeDoor",3):WaitForChild("Safe",3) end)
    if not safe then
        pcall(function()
            local safes=workspace:FindFirstChild("1# Map") and workspace["1# Map"]:FindFirstChild("2 Crosswalks") and workspace["1# Map"]["2 Crosswalks"]:FindFirstChild("Safes")
            if safes then
                for _,v in ipairs(safes:GetChildren()) do
                    local u=v:FindFirstChild("Union") or v:FindFirstChildWhichIsA("BasePart")
                    if u then safe=v; break end
                end
            end
        end)
    end
    return safe
end
getgenv().plugzStoreDuped = true
function SafeDupeOnce(toolName)
    local Character=LocalPlayer.Character; if not Character or not toolName then return end
    local InventoryRemote=ReplicatedStorage:WaitForChild("Inventory")
    local BackpackRemote=ReplicatedStorage:WaitForChild("BackpackRemote")
    local Safe=GetSafe()
    if not Safe then Notify("Dupe","Safe not found!",2) return end
    pcall(function() Character.Humanoid:UnequipTools() end)
    task.spawn(function() pcall(function() BackpackRemote:InvokeServer("Store",toolName) end) end)
    task.spawn(function() pcall(function() InventoryRemote:FireServer("Change",toolName,"Backpack",Safe) end) end)
    task.wait(0.5)
    task.wait(1.5)
    pcall(function() BackpackRemote:InvokeServer("Grab",toolName) end)
    if not getgenv().plugzStoreDuped then
        pcall(function() InventoryRemote:FireServer("Change",toolName,"Inv",Safe) end)
    end
    task.wait(0.5)
end
UI:AddButton(ExploitsTab, "Safe Dupe Once", function()
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then Notify("Dupe","Equip a tool first!",3) return end
        Notify("Dupe","Duping "..tool.Name.."...",3)
        SafeDupeOnce(tool.Name)
        Notify("Dupe","Done!",3)
    end)
end)
UI:AddButton(ExploitsTab, "TP to Safe", function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        getgenv()._preDupeSavePos = hrp.CFrame
        local safe = GetSafe()
        if not safe then Notify("TP Safe","Safe not found! Going to market...",2); task.spawn(function() BypassTp(CFrame.new(-450.44, 334.31, -545.12)) end) return end
        local tpTarget = nil
        if safe:IsA("BasePart") then tpTarget = safe.CFrame
        else local part = safe:FindFirstChild("Union") or safe:FindFirstChildWhichIsA("BasePart"); if part then tpTarget = part.CFrame end end
        if tpTarget then task.spawn(function() BypassTp(tpTarget + Vector3.new(2, 0, 0)) end); Notify("TP Safe","Teleported to safe! Position saved.",2)
        else task.spawn(function() BypassTp(CFrame.new(-450.44, 334.31, -545.12)) end); Notify("TP Safe","Teleported to market area.",2) end
    end)
end)
UI:AddSection(ExploitsTab, "🛡️ Bypasses & Anti-Cheat")
UI:AddToggle(ExploitsTab, "Anti Fling", false, function(state)
    getgenv().antiFling = state
    Notify("Bypass", state and "Anti Fling ON" or "Anti Fling OFF", 2)
end)
UI:AddToggle(ExploitsTab, "Anti Fall Damage", false, function(state) if state then pcall(function() local char=LocalPlayer.Character; local fd=char:FindFirstChild("FallDamageRagdoll"); if fd then fd:Destroy() end end); Notify("Bypass","Anti Fall ON",2) end end)
UI:AddToggle(ExploitsTab, "Anti-Knockback", false, function(state) if state then pcall(function() local char=LocalPlayer.Character; for _,v in ipairs(char:GetDescendants()) do if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("VectorForce") then v:Destroy() end end; char.HumanoidRootPart.ChildAdded:Connect(function(v) if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("VectorForce") then v:Destroy() end end) end); Notify("Bypass","Anti-KB ON",2) end end)
UI:AddToggle(ExploitsTab, "Noclip", false, function(state) if state then Noclipping=RunService.Stepped:Connect(function() setCollide(false) end); Notify("Bypass","Noclip ON",2) else if Noclipping then Noclipping:Disconnect(); Noclipping=nil end; setCollide(true) end end)
UI:AddToggle(ExploitsTab, "🚗 Anti Car Knockback", false, function(state)
    getgenv()._antiCarKB = state
    if state then
        if not getgenv()._antiCarKBConn then
            getgenv()._antiCarKBConn = RunService.Heartbeat:Connect(function()
                if not getgenv()._antiCarKB then return end
                pcall(function()
                    local c = LocalPlayer.Character; if not c then return end
                    local hrp = c:FindFirstChild("HumanoidRootPart"); local hum = c:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum then return end
                    hum.PlatformStand = false
                    local st = hum:GetState()
                    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    local v = hrp.AssemblyLinearVelocity
                    if math.sqrt(v.X*v.X + v.Z*v.Z) > 90 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, math.max(v.Y, -10), 0)
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
            end)
        end
        Notify("Bypass","Anti Car Knockback ON",2)
    else
        if getgenv()._antiCarKBConn then getgenv()._antiCarKBConn:Disconnect(); getgenv()._antiCarKBConn=nil end
        Notify("Bypass","Anti Car Knockback OFF",2)
    end
end)
UI:AddToggle(ExploitsTab, "Instant Prompts", false, function(state) if state then for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration=0; v.MaxActivationDistance=6 end end; Notify("Bypass","Instant Prompts ON",2) end end)
UI:AddToggle(ExploitsTab, "Anti Lose Items", false, function(state) AntiLoseEnabled = state; if state then Notify("Bypass", "Anti Lose ON", 2) end end)
UI:AddSection(ExploitsTab, "👤 Player Mods")
UI:AddToggle(ExploitsTab, "Infinite Stamina", false, function(state) staminaEnabled = state; if state then applyEffects() end end)
UI:AddToggle(ExploitsTab, "Infinite Hunger", false, function(state) hungerEnabled = state; if state then applyEffects() end end)
UI:AddToggle(ExploitsTab, "Infinite Sleep", false, function(state) sleepEnabled = state; if state then applyEffects() end end)
UI:AddToggle(ExploitsTab, "Infinite Jump", false, function(state)
    getgenv().InfiniteJumpEnabled = state
    if state and not getgenv().InfiniteJumpConnection then
        getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if getgenv().InfiniteJumpEnabled then local character=LocalPlayer.Character; if character and character:FindFirstChild("Humanoid") then character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end
        end)
        Notify("Infinite Jump", "Enabled!", 2)
    elseif not state and getgenv().InfiniteJumpConnection then
        getgenv().InfiniteJumpConnection:Disconnect(); getgenv().InfiniteJumpConnection = nil; Notify("Infinite Jump", "Disabled", 2)
    end
end)
UI:AddToggle(ExploitsTab, "No Jump Cooldown", false, function(state)
    getgenv().NoJumpCooldownEnabled = state
    if state then
        if getgenv().NoJumpCooldownConnection then pcall(function() getgenv().NoJumpCooldownConnection:Disconnect() end) end
        getgenv().NoJumpCooldownConnection = UserInputService.JumpRequest:Connect(function()
            if not getgenv().NoJumpCooldownEnabled then return end
            local character = LocalPlayer.Character; if not character then return end
            local humanoid = character:FindFirstChildWhichIsA("Humanoid"); if not humanoid then return end
            if humanoid.FloorMaterial == Enum.Material.Air then return end
            if humanoid.Jump or humanoid:GetState() == Enum.HumanoidStateType.Jumping then return end
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        Notify("No Jump Cooldown", "Instant jumps!", 2)
    else if getgenv().NoJumpCooldownConnection then pcall(function() getgenv().NoJumpCooldownConnection:Disconnect() end); getgenv().NoJumpCooldownConnection = nil end end
end)
UI:AddToggle(ExploitsTab, "No Rent Pay", false, function(state)
    getgenv().noRent = state
    if state then task.spawn(function() while getgenv().noRent do pcall(function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") and (v.ActionText:lower():find("rent") or v.ObjectText:lower():find("rent")) then v.Enabled=false end end end); task.wait(5) end end); Notify("No Rent","Rent prompts disabled!",2) end
end)
UI:AddToggle(ExploitsTab, "Anti Ragdoll", false, function(state)
    getgenv().AntiRagdoll = state
    if state then pcall(function() local char=LocalPlayer.Character; if char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BallSocketConstraint") or v:IsA("NoCollisionConstraint") then v:Destroy() end end end end); Notify("Anti Ragdoll","No more ragdoll!",2) end
end)
UI:AddToggle(ExploitsTab, "Spinbot", false, function(state)
    getgenv().SpinbotEnabled = state
    if state then task.spawn(function() while getgenv().SpinbotEnabled do local character=LocalPlayer.Character; if character and character:FindFirstChild("HumanoidRootPart") then character.HumanoidRootPart.CFrame=character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(45),0) end; RunService.RenderStepped:Wait() end end); Notify("Spinbot","Spinning!",2)
    else Notify("Spinbot","Disabled",2) end
end)
UI:AddToggle(ExploitsTab, "Anti Camera Shake", false, function(state)
    getgenv().antiCameraShake = state
    if state then
        task.spawn(function()
            while getgenv().antiCameraShake do
                pcall(function()
                    local camera=workspace.CurrentCamera; if camera then for _,child in pairs(camera:GetChildren()) do if child:IsA("ShakeEffect") or child.Name:lower():find("shake") then child:Destroy() end end end
                    local playerScripts=LocalPlayer:FindFirstChild("PlayerScripts"); if playerScripts then for _,script in pairs(playerScripts:GetDescendants()) do if script.Name:lower():find("shake") and script:IsA("LocalScript") then script.Enabled=false end end end
                end)
                task.wait(0.5)
            end
        end)
        Notify("Anti Shake", "Camera shake disabled!", 2)
    end
end)
getgenv().deathPosition = nil; getgenv().respawnWhereDied = false
local fastRespawnConnection = nil
UI:AddToggle(ExploitsTab, "Faster Respawn", false, function(state)
    _G.respawn = state
    if state then
        if fastRespawnConnection then pcall(function() fastRespawnConnection:Disconnect() end) end
        fastRespawnConnection = RunService.PreRender:Connect(function()
            if not _G.respawn then return end; if not LocalPlayer.Character then return end
            local h = LocalPlayer.Character:FindFirstChild("Humanoid")
            if h and h.Health <= 0 then pcall(function() ReplicatedStorage.LoadCharacter:FireServer() end); StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end
        end)
        Notify("Respawn", "Fast respawn ON!", 2)
    else if fastRespawnConnection then pcall(function() fastRespawnConnection:Disconnect() end); fastRespawnConnection = nil end; Notify("Respawn","Disabled",2) end
end)
UI:AddToggle(ExploitsTab, "Respawn Where Died", false, function(state) getgenv().respawnWhereDied = state; if state then Notify("Respawn","Will respawn at death spot!",2) end end)
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function() local hrp=char:FindFirstChild("HumanoidRootPart"); if hrp then getgenv().deathPosition=hrp.Position end end)
    if getgenv().respawnWhereDied and getgenv().deathPosition then
        task.wait(1); getgenv().SwimMethod = true; task.wait(0.5)
        local newHRP = char:WaitForChild("HumanoidRootPart", 5)
        if newHRP then newHRP.CFrame = CFrame.new(getgenv().deathPosition) end
        getgenv().SwimMethod = false
    end
end)
UI:AddSection(FarmTab, "🎬 Studio")
UI:AddButton(FarmTab, "Studio Rob", function()
    local char = LocalPlayer.Character; if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart"); if not rootPart then return end
    pcall(function() for _,v in pairs(workspace.StudioPay.Money:GetDescendants()) do if v:IsA("ProximityPrompt") and v.Name=="Prompt" then v.HoldDuration=0; v.RequiresLineOfSight=false end end end)
    local prompts = {}
    pcall(function() for _,v in pairs(workspace.StudioPay.Money:GetDescendants()) do if v:IsA("ProximityPrompt") and v.Name=="Prompt" and v.Enabled then table.insert(prompts,v) end end end)
    if #prompts == 0 then Notify("Studio","Already robbed!",3) return end
    local oldCFrame = rootPart.CFrame; local camera = workspace.CurrentCamera
    for _, v in ipairs(prompts) do
        getgenv().SwimMethod = true
        local offset = Vector3.new(math.cos(math.rad(math.random(0,359))),2,math.sin(math.rad(math.random(0,359))))
        rootPart.CFrame = CFrame.new(v.Parent.Position + offset)
        local oldCameraType = camera.CameraType; camera.CameraType = Enum.CameraType.Scriptable
        local promptPos = v.Parent.Position; local conn
        conn = RunService.RenderStepped:Connect(function() camera.CFrame = CFrame.lookAt(camera.CFrame.Position, promptPos) end)
        task.wait(0.3)
        repeat fireproximityprompt(v); task.wait(0.1) until not v.Enabled
        conn:Disconnect(); camera.CameraType = oldCameraType; getgenv().SwimMethod = false
    end
    rootPart.CFrame = oldCFrame; Notify("Studio","Rob complete!",3)
end)
UI:AddButton(FarmTab, "Reset Camera to Player", function()
    pcall(function()
        local camera=workspace.CurrentCamera; local char=LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            camera.CameraType=Enum.CameraType.Custom; camera.CameraSubject=char:FindFirstChild("Humanoid")
            camera.CFrame=CFrame.new(char.HumanoidRootPart.Position+Vector3.new(0,5,10),char.HumanoidRootPart.Position)
            Notify("Camera","Reset to player!",2)
        end
    end)
end)
UI:AddButton(FarmTab, "TP to Studio", function() BypassTp(CFrame.new(93427.51,14484.90,566.67)); Notify("TP","Studio",2) end)
UI:AddSection(FarmTab, "🏗️ Construction")
UI:AddButton(FarmTab, "TP to Construction", function() BypassTp(CFrame.new(-1731.83,370.81,-1176.83)); Notify("TP","Construction Site",2) end)
local constructionRunning = false
UI:AddToggle(FarmTab, "Auto Construction Farm", false, function(Value)
    local speaker = LocalPlayer
    local function getCharacter() return speaker.Character or speaker.CharacterAdded:Wait() end
    local function getBackpack() return speaker:FindFirstChild("Backpack") end
    local function hasPlyWood()
        local bp=getBackpack(); local ch=getCharacter()
        return (bp and bp:FindFirstChild("PlyWood")) or (ch and ch:FindFirstChild("PlyWood"))
    end
    local function equipPlyWood()
        local bp=getBackpack(); if bp then local pw=bp:FindFirstChild("PlyWood"); if pw then pw.Parent=getCharacter() end end
    end
    local function fireInstantPrompt(prompt)
        if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
            prompt.HoldDuration=0; fireproximityprompt(prompt)
        end
    end
    local function grabWood()
        local char=getCharacter()
        char:SetPrimaryPartCFrame(CFrame.new(-1727,371,-1178))
        task.wait(0)
        while constructionRunning and not hasPlyWood() do
            local prompt=workspace.ConstructionStuff["Grab Wood"]:FindFirstChildOfClass("ProximityPrompt")
            fireInstantPrompt(prompt); task.wait(0); equipPlyWood()
        end
    end
    local function buildWall(name, position)
        local ok, prompt = pcall(function()
            return workspace.ConstructionStuff[name]:FindFirstChildOfClass("ProximityPrompt")
        end)
        if not ok or not prompt then return end
        while constructionRunning and prompt and prompt.Enabled do
            getCharacter():SetPrimaryPartCFrame(position)
            task.wait(0)
            fireInstantPrompt(prompt)
            task.wait(0)
            if not hasPlyWood() then grabWood() end
        end
    end
    local function quitJob()
        pcall(function()
            local qp=workspace.ConstructionStuff:FindFirstChild("Quit Job")
            if qp then
                local prompt=qp:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    getCharacter():SetPrimaryPartCFrame(qp.CFrame+Vector3.new(0,2,0))
                    task.wait(0.1); fireInstantPrompt(prompt)
                end
            end
        end)
    end
    if Value then
        constructionRunning=true
        enableSwimMethod()
        task.wait(1)
        local char=getCharacter()
        char:SetPrimaryPartCFrame(CFrame.new(-1728,371,-1172))
        task.wait(0.2)
        pcall(function() fireInstantPrompt(workspace.ConstructionStuff["Start Job"]:FindFirstChildOfClass("ProximityPrompt")) end)
        task.wait(0.2)
        task.spawn(function()
            while constructionRunning do
                if not hasPlyWood() then grabWood() end
                buildWall("Wall2 Prompt",CFrame.new(-1705,368,-1151))
                buildWall("Wall3 Prompt",CFrame.new(-1732,368,-1152))
                buildWall("Wall4 Prompt2",CFrame.new(-1772,368,-1152))
                buildWall("Wall1 Prompt3",CFrame.new(-1674,368,-1166))
                task.wait(0)
            end
        end)
    else
        constructionRunning=false; disableSwimMethod(); quitJob()
        pcall(function()
            local sjp=workspace.ConstructionStuff["Start Job"]:FindFirstChildOfClass("ProximityPrompt")
            if sjp and sjp.Parent then
                local ch=getCharacter()
                if ch and ch.PrimaryPart then
                    ch:SetPrimaryPartCFrame(sjp.Parent.CFrame+Vector3.new(0,2,0))
                    task.wait(0.1); fireInstantPrompt(sjp)
                end
            end
        end)
    end
    Notify("Construction", Value and "Farming..." or "Stopped", 2)
end)
UI:AddSection(FarmTab, "🗑️ Trashbags")
UI:AddButton(FarmTab, "Search Trashbags", function()
    task.spawn(function()
        local char=LocalPlayer.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local originalCFrame=hrp.CFrame; Notify("Farm","Searching trashbags...",2); getgenv().SwimMethod=true; task.wait(0.5)
        local foundCount=0
        pcall(function()
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Name=="ProximityPrompt" and v.Parent and v.Parent.Name=="DumpsterPromt" then
                    v.HoldDuration=0; v.RequiresLineOfSight=false
                    hrp.CFrame=v.Parent.CFrame+Vector3.new(0,0.2,3); task.wait(0.3)
                    for _=1,10 do fireproximityprompt(v); task.wait(0.05) end
                    foundCount=foundCount+1; task.wait(0.1)
                end
            end
        end)
        hrp.CFrame=originalCFrame; task.wait(0.3); getgenv().SwimMethod=false; Notify("Farm","Searched "..foundCount.." trashbags!",2)
    end)
end)
UI:AddButton(FarmTab, "Sell Trashbag Items", function()
    pcall(function() for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") then pcall(function() ReplicatedStorage.PawnRemote:FireServer(tool.Name) end); task.wait(0.1) end end end)
    Notify("Sell","Items sold!",2)
end)
UI:AddSection(FarmTab, "💵 Cash")
UI:AddButton(FarmTab, "Collect Dropped Cash", function()
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local originalCFrame=hrp.CFrame
    pcall(function() for _,v in pairs(workspace.Dollas:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration=0; v.RequiresLineOfSight=false end end end)
    pcall(function() for _,v in pairs(workspace.Dollas:GetDescendants()) do if v:IsA("ProximityPrompt") then hrp.CFrame=v.Parent.CFrame; task.wait(0.25); fireproximityprompt(v); task.wait(0.25) end end end)
    hrp.CFrame=originalCFrame; Notify("Cash","Collected!",2)
end)
UI:AddSection(CombatTab, "💀 Kill Aura")
UI:AddToggle(CombatTab, "Kill Aura", false, function(state)
    if state and not hasGunInHand() then BigGunNotify("nogun"); getgenv().auraenabled=false; return end
    getgenv().auraenabled = state
    if state then
        BigGunNotify("ammo")
        task.spawn(function()
            while getgenv().auraenabled and task.wait(getgenv().cooldown) do
                task.wait()
                pcall(function()
                    local plr=game.Players.LocalPlayer
                    if plr.Character:FindFirstChildWhichIsA("Tool") and plr.Character:FindFirstChildOfClass("Tool"):FindFirstChild("GunScript_Local") then
                        if target1 and target1.Character and target1.Character:FindFirstChild("Head") then
                            local part=Instance.new("Part",workspace); part.Size=Vector3.new(0.2,0.2,(plr.Character.HumanoidRootPart.Position-target1.Character.Head.Position).Magnitude); part.Anchored=true; part.CanCollide=false
                            local color=getgenv().rainbowbeam and Color3.fromHSV(tick()%5/5,1,1) or getgenv().beamcolor
                            part.Color=color; part.Material=Enum.Material.Neon
                            local toolHandle=plr.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Handle")
                            if toolHandle then local midpoint=(toolHandle.Position+target1.Character[getgenv().hitpart].Position)/2; part.Position=midpoint; part.CFrame=CFrame.new(midpoint,target1.Character[getgenv().hitpart].Position) end
                            task.wait(0.1); part:Destroy()
                            local tool=plr.Character:FindFirstChildWhichIsA("Tool"); local handle=tool:FindFirstChild("Handle"); local muzzleEffect=tool:FindFirstChild("GunScript_Local") and tool.GunScript_Local:FindFirstChild("MuzzleEffect")
                            if handle and muzzleEffect and game.ReplicatedStorage:FindFirstChild("VisualizeMuzzle") then game.ReplicatedStorage.VisualizeMuzzle:FireServer(handle,true,{false,7,color,15,true,0.02},muzzleEffect) end

                            local _myH=plr.Character:FindFirstChild("HumanoidRootPart"); local _tH=target1.Character:FindFirstChild("HumanoidRootPart")
                            if _myH and _tH then local _o=_myH.CFrame; pcall(function() _myH.CFrame=_tH.CFrame end); pcall(function() _myH.Anchored=true end); task.wait(0.08); KillGunMod(target1,"Head",math.huge); pcall(function() _myH.Anchored=false end); local _h2=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart"); if _h2 then pcall(function() _h2.CFrame=_o end) end else KillGunMod(target1,"Head",math.huge) end
                        end
                    end
                end)
            end
        end)
        Notify("Kill Aura","ON - Attacking nearest",2)
    end
end)
UI:AddToggle(CombatTab, "Highlight Target", false, function(state) getgenv().killaurahigh = state end)
UI:AddToggle(CombatTab, "Rainbow Beam", false, function(state) getgenv().rainbowbeam = state end)
UI:AddButton(CombatTab, "Kill All (5 sec)", function()
    if not hasGunInHand() then BigGunNotify("nogun"); return end
    BigGunNotify("ammo")
    task.spawn(function()
        local gun=checkgun(); if not gun then Notify("Kill","Gun not found",3) return end
        pcall(function() local s=GetGunSettings(); if s then s.LimitedAmmoEnabled=false; s.Ammo=80000; s.AmmoPerMag=80000; s.MagCount=80000; s.StoredAmmo=80000; s.MaxAmmo=80000 end end)
        local hrp0=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local origin=hrp0 and hrp0.CFrame
        for _,v in pairs(Players:GetPlayers()) do
            if v~=LocalPlayer and v.Character then
                local th=v.Character:FindFirstChild("HumanoidRootPart")
                local hum=v.Character:FindFirstChildOfClass("Humanoid")
                local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if th and hum and hum.Health>0 and h then
                    pcall(function() h.CFrame=th.CFrame end)
                    pcall(function() h.Anchored = true end)
                    task.wait(0.07)
                    pcall(function() KillGunMod(v,"Head",math.huge) end)
                    task.wait(0.07)
                    pcall(function() KillGunMod(v,"Head",math.huge) end)
                    task.wait(0.18)
                    pcall(function() KillGunMod(v,"Head",math.huge) end)
                    task.wait(0.1)
                    pcall(function() h.Anchored = false end)
                end
            end
        end
        local hf=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hf and origin then pcall(function() hf.CFrame=origin end) end
        Notify("Kill All","Done",3)
    end)
end)
UI:AddSection(CombatTab, "🌀 Server Chaos")
local bringAllRotation=0; local bringAllEnabled=false
UI:AddToggle(CombatTab, "Bring All Players (Rotate)", false, function(state)
    bringAllEnabled = state
    if state then
        task.spawn(function()
            while bringAllEnabled do
                local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local players={}; for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(players,p) end end
                    local count=#players
                    if count>0 then
                        bringAllRotation=bringAllRotation+2
                        for i,p in ipairs(players) do local angle=math.rad((360/count)*i+bringAllRotation); local radius=20; pcall(function() p.Character.HumanoidRootPart.CFrame=myHRP.CFrame*CFrame.new(math.cos(angle)*radius,0,math.sin(angle)*radius) end) end
                    end
                end
                task.wait(0.05)
            end
        end)
        Notify("Bring All","Rotating circle ON (bigger)",2)
    end
end)
UI:AddSection(CombatTab, "🎯 Hitbox")
UI:AddToggle(CombatTab, "Hitbox Extender", false, function(state)
    hitboxextender = state
    if state then RunService:BindToRenderStep("Hitbox",0,function() for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then pcall(function() local hrp=v.Character.HumanoidRootPart; hrp.Size=Vector3.new(Size,Size,Size); hrp.Transparency=Transparency; hrp.Color=HitboxColor end) end end end)
    else RunService:UnbindFromRenderStep("Hitbox") end
end)
UI:AddSlider(CombatTab, "Hitbox Size", 1, 15, 4, function(val) Size = val end)
UI:AddSlider(CombatTab, "Hitbox Transparency", 0, 100, 85, function(val) Transparency = val / 100 end)
UI:AddToggle(CombatTab, "Rainbow Hitbox", false, function(state)
    rainbowHitbox = state
    if state then task.spawn(function() while rainbowHitbox do HitboxColor=Color3.fromHSV(tick()%1,1,1); task.wait(0.1) end end) end
end)
UI:AddSection(TrollingTab, "📞 Spam")
local spamPoliceEnabled = false
UI:AddToggle(TrollingTab, "Spam Call Police", false, function(state)
    spamPoliceEnabled = state
    if state then task.spawn(function() while spamPoliceEnabled do pcall(function() ReplicatedStorage.CallPolice:FireServer() end); task.wait(0.5) end end); Notify("Troll","Spamming police!",2) end
end)
UI:AddButton(TrollingTab, "Break All Glass", function()
    for _,v in ipairs(workspace:GetDescendants()) do if v.Name=="Glass" and (v:IsA("BasePart") or v:IsA("MeshPart")) then pcall(function() ReplicatedStorage.BreakGlass:InvokeServer(v) end) end end
    Notify("Troll","Glass broken!",2)
end)
local spamTweetEnabled = false
UI:AddToggle(TrollingTab, "Spam Tweet (Every 4s)", false, function(state)
    spamTweetEnabled = state
    if state then task.spawn(function() while spamTweetEnabled do pcall(function() ReplicatedStorage.Resources["#Phone"].Main:FireServer("Tweet",{"CreateTweet","Skid Hub on top"}) end); task.wait(4) end end); Notify("Tweet","Spamming tweets!",2) end
end)
UI:AddSection(TrollingTab, "📢 Megaphone")
UI:AddButton(TrollingTab, "🚔 PULL OVER NOW!", function() pcall(function() ReplicatedStorage.MegaphoneRemote:FireServer("PULL OVER NOW!") end); Notify("Megaphone","Sent!",2) end)
UI:AddButton(TrollingTab, "🚨 Move it FOLKS!", function() pcall(function() ReplicatedStorage.MegaphoneRemote:FireServer("Move it FOLKS!") end); Notify("Megaphone","Sent!",2) end)
UI:AddButton(TrollingTab, "👮 Driver Pull Over!", function() pcall(function() ReplicatedStorage.MegaphoneRemote:FireServer("Driver Pull Over!") end); Notify("Megaphone","Sent!",2) end)
UI:AddButton(TrollingTab, "✋ Hands UP!", function() pcall(function() ReplicatedStorage.MegaphoneRemote:FireServer("Hands UP!") end); Notify("Megaphone","Sent!",2) end)
UI:AddSection(TrollingTab, "🎭 Animations")
local trollTrack, trollTrack2, trollTrack4
UI:AddToggle(TrollingTab, "🚶 Carrying Animation", false, function(state)
    pcall(function() if state then local anim=ReplicatedStorage:FindFirstChild("BeingCarried"); if anim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then trollTrack=LocalPlayer.Character.Humanoid:LoadAnimation(anim); trollTrack:Play() end elseif trollTrack then trollTrack:Stop() end end)
end)
UI:AddToggle(TrollingTab, "🤕 Low HP Animation", false, function(state)
    pcall(function() if state then local anim=ReplicatedStorage:FindFirstChild("LowHealthAnim"); if anim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then trollTrack2=LocalPlayer.Character.Humanoid:LoadAnimation(anim); trollTrack2:Play() end elseif trollTrack2 then trollTrack2:Stop() end end)
end)
UI:AddToggle(TrollingTab, "🔗 Cuffing Animation", false, function(state)
    pcall(function() if state then local anim=ReplicatedStorage:FindFirstChild("cuffed"); if anim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then trollTrack4=LocalPlayer.Character.Humanoid:LoadAnimation(anim); trollTrack4:Play() end elseif trollTrack4 then trollTrack4:Stop() end end)
end)
do
    local twerkAnim = nil
    local twerkRunning = false
    UI:AddToggle(TrollingTab, "Twerk", false, function(state)
        twerkRunning = state
        if state then
            task.spawn(function()
                local Animation = Instance.new("Animation")
                Animation.AnimationId = "rbxassetid://15693621070"
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Humanoid = Character:WaitForChild("Humanoid")
                local LoadAnimation = Humanoid:WaitForChild("Animator"):LoadAnimation(Animation)
                twerkAnim = LoadAnimation
                LoadAnimation:Play()
                local Speed = 1; local Min = 1.6; local Max = 1.75
                LoadAnimation:AdjustSpeed(Speed); LoadAnimation.TimePosition = Min
                local Type = 1
                while task.wait() do
                    if not twerkRunning or not LoadAnimation.IsPlaying then break end
                    if Type == 1 then
                        if LoadAnimation.TimePosition >= Max then Type = 2; LoadAnimation.TimePosition = Max; LoadAnimation:AdjustSpeed(-Speed) end
                    elseif Type == 2 then
                        if LoadAnimation.TimePosition <= Min then Type = 1; LoadAnimation.TimePosition = Min; LoadAnimation:AdjustSpeed(Speed) end
                    end
                end
                twerkRunning = false
            end)
        else
            if twerkAnim then pcall(function() twerkAnim:Stop() end); twerkAnim = nil end
        end
    end)
end
UI:AddSection(TrollingTab, "👔 Outfits")
local outfitNames = {}
for name, _ in pairs(outfits) do table.insert(outfitNames, name) end
local selectedOutfit = outfitNames[1]
UI:AddDropdown(TrollingTab, "Outfit", outfitNames, outfitNames[1], function(opt) selectedOutfit = opt end)
UI:AddButton(TrollingTab, "Equip Outfit", function() equipOutfit(selectedOutfit); Notify("Outfit", selectedOutfit, 3) end)
UI:AddSection(SettingsTab, "⚙️ GUI Settings")
UI:AddButton(SettingsTab, "Rejoin Server", function() pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer) end) end)
UI:AddButton(SettingsTab, "Leave Game", function() pcall(function() LocalPlayer:Kick("Left via Skid Hub") end) end)
UI:AddButton(SettingsTab, "Server Hop", SkidServerHop)
UI:AddSection(SettingsTab, "⌨️ Keybinds")
do
    local keyNames = {"None","Y","U","I","O","P","G","H","J","K","L","Z","X","C","V","B","N","M","F","T","R","E","Q"}
    local keyMap = {}
    for _,k in ipairs(keyNames) do
        if k ~= "None" then keyMap[k] = Enum.KeyCode[k] end
    end
    getgenv().wsFlyKeybind    = Enum.KeyCode.U
    getgenv().wsWalkKeybind   = Enum.KeyCode.B
    getgenv().wsCarFlyKeybind = Enum.KeyCode.O
    UI:AddDropdown(SettingsTab, "Fly Key", keyNames, "U", function(v)
        getgenv().wsFlyKeybind = keyMap[v] or nil
        Notify("Keybind", "Fly: "..(v == "None" and "cleared" or v), 2)
    end)
    UI:AddDropdown(SettingsTab, "Walk Speed Key", keyNames, "B", function(v)
        getgenv().wsWalkKeybind = keyMap[v] or nil
        Notify("Keybind", "Walk: "..(v == "None" and "cleared" or v), 2)
    end)
    UI:AddDropdown(SettingsTab, "Car Fly Key", keyNames, "O", function(v)
        getgenv().wsCarFlyKeybind = keyMap[v] or nil
        Notify("Keybind", "Car Fly: "..(v == "None" and "cleared" or v), 2)
    end)
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if getgenv().wsFlyKeybind and inp.KeyCode == getgenv().wsFlyKeybind then UI:Fire("Player Fly") end
        if getgenv().wsWalkKeybind and inp.KeyCode == getgenv().wsWalkKeybind then UI:Fire("WalkSpeed (3s delay)") end
        if getgenv().wsCarFlyKeybind and inp.KeyCode == getgenv().wsCarFlyKeybind then UI:Fire("Car Fly") end
    end)
end
UI:AddSection(SettingsTab, "🛡️ Extra Features")
UI:AddToggle(SettingsTab, "🛡️ Anti AFK", false, function(enabled)
    getgenv().AntiAFK = enabled
    if enabled then local vu=game:GetService("VirtualUser"); LocalPlayer.Idled:Connect(function() if getgenv().AntiAFK then vu:CaptureController(); vu:ClickButton2(Vector2.new()); Notify("Anti-AFK","Triggered!",2) end end); Notify("Anti-AFK","Enabled",2) end
end)
UI:AddToggle(SettingsTab, "⚡ FPS Booster", false, function(enabled)
    if enabled then settings().Rendering.QualityLevel=Enum.QualityLevel.Level01; for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Part") or v:IsA("MeshPart") then v.Material=Enum.Material.SmoothPlastic; v.Reflectance=0 elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled=false end end; Notify("FPS","Boost Applied!",2) end
end)
UI:AddToggle(SettingsTab, "☀️ Lock to Day", false, function(enabled) if enabled then game:GetService("Lighting").ClockTime=12; Notify("Time","Locked to day!",2) end end)
UI:AddToggle(SettingsTab, "🌙 Lock to Night", false, function(enabled) if enabled then game:GetService("Lighting").ClockTime=0; Notify("Time","Locked to night!",2) end end)
UI:AddSection(QuickBuysTab, "🔫 Guns & Ammo")
local quickBuyGuns = {"🔫 Draco + 7.62","🔫 Clear Mag Drac + 7.62","🔫 AR Pistol + 5.56","🔫 223 Tan + 5.56","🔫 HP Browning Ext","🔫 Glock 17 Ext","🔫 Glock 22 Ext","🔫 Springfield XD Ext"}
UI:AddDropdown(QuickBuysTab, "Buy Guns", quickBuyGuns, quickBuyGuns[1], function(val)
    pcall(function()
        if val=="🔫 Draco + 7.62" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("Draco"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer("7.62")
        elseif val=="🔫 Clear Mag Drac + 7.62" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("ClearMagDrac"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer("7.62")
        elseif val=="🔫 AR Pistol + 5.56" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("ARPistol"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer("5.56")
        elseif val=="🔫 223 Tan + 5.56" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("223Tan"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer("5.56")
        elseif val=="🔫 HP Browning Ext" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("HPBrowning Ext"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer(".Extended")
        elseif val=="🔫 Glock 17 Ext" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("Glock17"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer(".Extended")
        elseif val=="🔫 Glock 22 Ext" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("Glock22"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer(".Extended")
        elseif val=="🔫 Springfield XD Ext" then ReplicatedStorage:WaitForChild("ShopRemote5"):InvokeServer("SpringField XD"); task.wait(0.1); ReplicatedStorage.ExoticShopRemote:InvokeServer(".Extended")
        end
    end)
    Notify("Bought", val, 2)
end)
local exoticItems = {"FakeCard","Ice-Fruit Bag","Ice-Fruit Cupz","FijiWater","FreshWater","G26","Lemonade","Sledge Hammer","Screw","Bandage"}
UI:AddDropdown(QuickBuysTab, "🐍 Exotic Items", exoticItems, exoticItems[1], function(val) pcall(function() ReplicatedStorage.ExoticShopRemote:InvokeServer(val) end); Notify("Bought",val,2) end)
UI:AddSection(QuickBuysTab, "🛍️ Main Shop")
local quickBuyShop = {"Shiesty","BluGloves","WhiteGloves","BlackGloves","Water","YelloCamoGloves","RedCamoGloves","PurpleCamoGloves","RawChicken","RawSteak","WhiteShiesty"}
UI:AddDropdown(QuickBuysTab, "Shop Items", quickBuyShop, quickBuyShop[1], function(val) pcall(function() ReplicatedStorage:WaitForChild("ShopRemote"):InvokeServer(val) end); Notify("Bought",val,2) end)
UI:AddSection(QuickBuysTab, "📦 Ammo & Mags")
local ammoItems = {"Extended Mag","Drum Mag","10mm Ammo","FN Mag","9mm Ammo","7.62 Ammo","5.56 Ammo"}
UI:AddDropdown(QuickBuysTab, "Ammo/Mags", ammoItems, ammoItems[1], function(val)
    pcall(function()
        if val=="Extended Mag" then ReplicatedStorage.ExoticShopRemote:InvokeServer(".Extended")
        elseif val=="Drum Mag" then ReplicatedStorage.ExoticShopRemote:InvokeServer(".Drum")
        elseif val=="10mm Ammo" then ReplicatedStorage.ExoticShopRemote:InvokeServer(".10mm")
        elseif val=="FN Mag" then ReplicatedStorage.ExoticShopRemote:InvokeServer(".FNMag")
        elseif val=="9mm Ammo" then ReplicatedStorage.ExoticShopRemote:InvokeServer("9mm")
        elseif val=="7.62 Ammo" then ReplicatedStorage.ExoticShopRemote:InvokeServer("7.62")
        elseif val=="5.56 Ammo" then ReplicatedStorage.ExoticShopRemote:InvokeServer("5.56") end
    end)
    Notify("Bought", val, 2)
end)
UI:AddSection(QuickBuysTab, "🎒 Bags")
local bagItems = {}
pcall(function() if ReplicatedStorage:FindFirstChild("BACKPACK_HATS") and ReplicatedStorage.BACKPACK_HATS:FindFirstChild("Accessories") then for _,item in ipairs(ReplicatedStorage.BACKPACK_HATS.Accessories:GetChildren()) do table.insert(bagItems,item.Name) end end end)
if #bagItems == 0 then bagItems = {"SmallBag","MediumBag","LargeBag"} end
UI:AddDropdown(QuickBuysTab, "🎒 Buy Bags", bagItems, bagItems[1], function(val)
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then Notify("Error","No character",2) return end
        local item = workspace:FindFirstChild(val) or workspace:FindFirstChild(val, true)
        if not item then Notify("Error", val.." not found!", 2) return end
        local prompt = findProximityPromptRecursive(item)
        if not prompt then Notify("Error","No prompt on "..val, 2) return end
        local tCF
        if prompt.Parent and prompt.Parent:IsA("BasePart") then tCF = prompt.Parent.CFrame
        elseif item:IsA("Model") and item.PrimaryPart then tCF = item.PrimaryPart.CFrame
        elseif item:IsA("BasePart") then tCF = item.CFrame
        else local p = item:FindFirstChildWhichIsA("BasePart"); tCF = p and p.CFrame or CFrame.new(hrp.Position) end
        local orig = hrp.CFrame
        Notify("Buying", val.."...", 2)
        getgenv().SwimMethod = true
        task.wait(1)
        hrp.CFrame = tCF
        task.wait(0.5)
        prompt.HoldDuration = 0; prompt.MaxActivationDistance = 30
        for _ = 1, 10 do pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end); task.wait(0.1) end
        prompt.MaxActivationDistance = 6
        task.wait(0.3)
        hrp.CFrame = orig
        getgenv().SwimMethod = false
        Notify("✅ Bought", val, 2)
    end)
end)
UI:AddSection(QuickBuysTab, "🔫 Other Items")
local otherItems = {}
pcall(function()
    local seen={}; local gunsFolder=workspace:FindFirstChild("GUNS"); local source=gunsFolder and gunsFolder:GetChildren() or workspace:GetChildren()
    for _,gun in ipairs(source) do if (gun:IsA("Model") or gun:IsA("Tool")) and gun.Name~="Basketball" and gun.Name~="Loader" and not seen[gun.Name] then seen[gun.Name]=true; table.insert(otherItems,gun.Name) end end
    table.sort(otherItems)
end)
if #otherItems == 0 then otherItems = {"Draco","Glock17","ARPistol"} end
UI:AddDropdown(QuickBuysTab, "🔫 Other Items", otherItems, otherItems[1], function(val)
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        local item = (workspace:FindFirstChild("GUNS") and workspace.GUNS:FindFirstChild(val))
            or workspace:FindFirstChild(val) or workspace:FindFirstChild(val, true)
        if not item then Notify("Error", val.." not found!", 2) return end
        local prompt = findProximityPromptRecursive(item)
        if not prompt then Notify("Error","No prompt on "..val, 2) return end
        local tCF
        if prompt.Parent and prompt.Parent:IsA("BasePart") then tCF = prompt.Parent.CFrame
        elseif item:IsA("Model") and item.PrimaryPart then tCF = item.PrimaryPart.CFrame
        elseif item:IsA("BasePart") then tCF = item.CFrame
        else local p = item:FindFirstChildWhichIsA("BasePart"); tCF = p and p.CFrame or CFrame.new(hrp.Position) end
        local orig = hrp.CFrame
        Notify("Buying", val.."...", 2)
        getgenv().SwimMethod = true
        task.wait(1)
        hrp.CFrame = tCF
        task.wait(0.5)
        prompt.HoldDuration = 0; prompt.MaxActivationDistance = 30
        for _ = 1, 5 do pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end); task.wait(0.1) end
        prompt.MaxActivationDistance = 6
        task.wait(0.3)
        hrp.CFrame = orig
        getgenv().SwimMethod = false
        Notify("✅ Bought", val, 2)
    end)
end)
local deviceInfo = ExecutorSupport.Mobile and "Mobile (Touch)" or "Desktop"
UI:AddSection(CreditsTab, "Info")
UI:AddButton(CreditsTab, "Device: " .. deviceInfo, function() end)
UI:AddButton(CreditsTab, "Executor: " .. ExecutorSupport.Executor, function() end)
UI:AddButton(CreditsTab, "RightShift toggles the menu", function() end)
UI:AddButton(CreditsTab, "Remove Name Tag", function()
    pcall(function() local head=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head"); if head then local tag=head:FindFirstChild("SkidHubTag"); if tag then tag:Destroy() end end end)
    Notify("Tag","Removed!",2)
end)
UI:AddSection(CreditsTab, "Server")
UI:AddButton(CreditsTab, "Rejoin Server", function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId) end)
UI:AddButton(CreditsTab, "Server Hop", SkidServerHop)
UI:AddButton(CreditsTab, "Leave Game", function() pcall(function() LocalPlayer:Kick("Left via Skid Hub") end) end)
UI:AddSection(CreditsTab, "Credits")
UI:AddButton(CreditsTab, "Skid Hub", function() end)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        local open = true
        pcall(function() open = Window.Items.Window.Visible end)
        pcall(function() Window.ToggleMenu(not open) end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if nametagEnabled then CreateNametag(char) end
    applyEffects()
    if AntiLoseEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            task.wait(0.25)
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and not table.find(ExemptItems, tool.Name) then ForcePutToMarket(tool.Name) end
            end
        end)
    end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.delay(2.5, function()
        if AntiLoseEnabled then
            local market = ReplicatedStorage:FindFirstChild("MarketItems")
            if market then for _, item in ipairs(market:GetChildren()) do if item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then ForceRetrieveFromMarket(item.Name) end end end
        end
    end)
end)
if LocalPlayer.Character and nametagEnabled then CreateNametag(LocalPlayer.Character) end
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.respawn then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
                pcall(function() ReplicatedStorage.RespawnRE:FireServer() end)
            end
        end
    end
end)
local function CleanupCarFly()
    if bv then bv:Destroy(); bv = nil end
    if bg then bg:Destroy(); bg = nil end
end
local function SetupCarFly()
    CleanupCarFly()
    if not Config.TheBronx.carfly then return end
    local char = LocalPlayer.Character; if not char then return end
    hum = char:FindFirstChildWhichIsA("Humanoid"); if not hum then return end
    seat = hum.SeatPart; if not seat or not seat:IsA("VehicleSeat") then return end
    car = seat.Parent; if not car then return end
    root = car.PrimaryPart; if not root then return end
    lastCar = car
    for _, v in ipairs(car:GetChildren()) do if v:IsA("BasePart") and not v.Name:lower():find("wheel") then v.CanCollide = false end end
    bv = Instance.new("BodyVelocity"); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Velocity=Vector3.zero; bv.Parent=root
    bg = Instance.new("BodyGyro"); bg.MaxTorque=Vector3.new(1e9,1e9,1e9); bg.P=25000; bg.D=1500; bg.CFrame=root.CFrame; bg.Parent=root
end
task.spawn(function()
    while true do
        task.wait(0.2)
        local char = LocalPlayer.Character
        if char then
        local h = char:FindFirstChildWhichIsA("Humanoid")
        if h then
        local currentSeat = h.SeatPart
        if currentSeat and currentSeat:IsA("VehicleSeat") then
            if currentSeat.Parent ~= lastCar then SetupCarFly() end
        else
            if lastCar then CleanupCarFly(); lastCar = nil end
        end
        end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if not Config.TheBronx.carfly then CleanupCarFly(); return end
    if not hum or hum.SeatPart ~= seat then return end
    if not root or not bv or not bg then SetupCarFly(); return end
    local carSpeed = Config.TheBronx.carflyspeed or 120
    local cam = workspace.CurrentCamera; local camCF = cam.CFrame
    local camLook = camCF.LookVector; local camRight = camCF.RightVector
    if not UserInputService.TouchEnabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then bg.CFrame = CFrame.lookAt(root.Position, root.Position + camLook) end
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camRight end
        bv.Velocity = move.Magnitude > 0 and move.Unit * carSpeed or Vector3.zero
    else
        bg.CFrame = CFrame.lookAt(root.Position, root.Position + camLook)
        local move = hum.MoveDirection; local velocity = Vector3.zero
        if move.Magnitude > 0 then
            local camRight2 = camCF.RightVector; local camLook2 = Vector3.new(camCF.LookVector.X,0,camCF.LookVector.Z).Unit
            velocity = (camRight2 * move.X) + (camLook2 * -move.Z); velocity = velocity * carSpeed
        end
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Jumping then velocity = velocity + Vector3.new(0, carSpeed * 0.8, 0) end
        bv.Velocity = velocity
    end
end)
do
local espColorMap={Red=Color3.fromRGB(255,0,0),Purple=Color3.fromRGB(138,43,226),Green=Color3.fromRGB(0,255,0),Blue=Color3.fromRGB(0,170,255),White=Color3.fromRGB(255,255,255),Yellow=Color3.fromRGB(255,255,0),Cyan=Color3.fromRGB(0,255,255),Orange=Color3.fromRGB(255,165,0),Pink=Color3.fromRGB(255,105,180)}
local chamsFillColor=Color3.fromRGB(138,43,226); local chamsOutlineColor=Color3.fromRGB(255,0,255)
local ESPSettings={Enabled=false,BoxESP=false,BoxFill=false,BoxCorners=false,NameESP=false,HealthESP=false,TracerESP=false,DistanceESP=false,Box3DESP=false,BoxColor=Color3.fromRGB(255,0,0),TracerColor=Color3.fromRGB(0,255,0),TextColor=Color3.fromRGB(255,255,255),MaxDistance=800}
local ESPObjects={}; local ChamsHighlights={}
local function CreateESPForPlayer(plr)
    if plr==LocalPlayer or ESPObjects[plr] then return end
    local corners={}; for i=1,8 do local ln=Drawing.new("Line"); ln.Thickness=2; ln.Color=ESPSettings.BoxColor; ln.Visible=false; corners[i]=ln end
    local b3d={}; for i=1,12 do local ln=Drawing.new("Line"); ln.Thickness=1; ln.Color=ESPSettings.BoxColor; ln.Visible=false; b3d[i]=ln end
    ESPObjects[plr]={Box=Drawing.new("Square"),Corners=corners,Name=Drawing.new("Text"),Health=Drawing.new("Text"),Distance=Drawing.new("Text"),Tracer=Drawing.new("Line"),TracerOutline=Drawing.new("Line"),Box3D=b3d}
    local e=ESPObjects[plr]; e.Box.Thickness=1; e.Box.Filled=false; e.Box.Color=ESPSettings.BoxColor; e.Box.Visible=false
    e.Name.Size=14; e.Name.Center=true; e.Name.Outline=true; e.Name.Color=ESPSettings.TextColor; e.Name.Visible=false
    e.Health.Size=12; e.Health.Center=true; e.Health.Outline=true; e.Health.Color=Color3.fromRGB(0,255,0); e.Health.Visible=false
    e.Distance.Size=12; e.Distance.Center=true; e.Distance.Outline=true; e.Distance.Color=Color3.fromRGB(255,255,0); e.Distance.Visible=false
    e.Tracer.Thickness=1; e.Tracer.Color=ESPSettings.TracerColor; e.Tracer.Visible=false
    e.TracerOutline.Thickness=3; e.TracerOutline.Color=Color3.new(0,0,0); e.TracerOutline.Visible=false
end
local function RemoveESPForPlayer(plr)
    if not ESPObjects[plr] then return end; local e=ESPObjects[plr]
    for _,ln in ipairs(e.Box3D or {}) do pcall(function() ln:Remove() end) end
    for _,ln in ipairs(e.Corners or {}) do pcall(function() ln:Remove() end) end
    for k,d in pairs(e) do if k~="Box3D" and k~="Corners" then pcall(function() d:Remove() end) end end
    ESPObjects[plr]=nil
end
local EDGES={{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
local function UpdateESP()
    if not ESPSettings.Enabled then for _,e in pairs(ESPObjects) do pcall(function() e.Box.Visible=false; e.Name.Visible=false; e.Health.Visible=false; e.Distance.Visible=false; e.Tracer.Visible=false; e.TracerOutline.Visible=false; for _,ln in ipairs(e.Corners or {}) do ln.Visible=false end; for _,ln in ipairs(e.Box3D or {}) do ln.Visible=false end end) end; return end
    local cam=workspace.CurrentCamera; local vp=cam.ViewportSize
    for plr,e in pairs(ESPObjects) do pcall(function()
        local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local hrp=char and char:FindFirstChild("HumanoidRootPart"); local head=char and char:FindFirstChild("Head")
        local function hide() e.Box.Visible=false; e.Name.Visible=false; e.Health.Visible=false; e.Distance.Visible=false; e.Tracer.Visible=false; e.TracerOutline.Visible=false; for _,ln in ipairs(e.Corners or {}) do ln.Visible=false end; for _,ln in ipairs(e.Box3D or {}) do ln.Visible=false end end
        if not(char and hum and hrp and head and hum.Health>0) then hide(); return end
        local rp,on=cam:WorldToViewportPoint(hrp.Position); local hp2=cam:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0)); local lp2=cam:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
        local dist=(hrp.Position-cam.CFrame.Position).Magnitude
        if not(on and rp.Z>0 and dist<=ESPSettings.MaxDistance) then hide(); return end
        local bH=math.abs(hp2.Y-lp2.Y); local bW=math.max(bH/2,10)
        if ESPSettings.BoxESP then e.Box.Filled=ESPSettings.BoxFill; e.Box.Size=Vector2.new(bW,bH); e.Box.Position=Vector2.new(rp.X-bW/2,hp2.Y); e.Box.Color=ESPSettings.BoxColor; e.Box.Visible=true else e.Box.Visible=false end
        if ESPSettings.BoxCorners and e.Corners then
            local bx=rp.X-bW/2; local by=hp2.Y; local cw=math.max(bW*.25,5); local ch=math.max(bH*.25,5); local col=ESPSettings.BoxColor; local co=e.Corners
            co[1].From=Vector2.new(bx,by); co[1].To=Vector2.new(bx+cw,by); co[2].From=Vector2.new(bx,by); co[2].To=Vector2.new(bx,by+ch)
            co[3].From=Vector2.new(bx+bW,by); co[3].To=Vector2.new(bx+bW-cw,by); co[4].From=Vector2.new(bx+bW,by); co[4].To=Vector2.new(bx+bW,by+ch)
            co[5].From=Vector2.new(bx,by+bH); co[5].To=Vector2.new(bx+cw,by+bH); co[6].From=Vector2.new(bx,by+bH); co[6].To=Vector2.new(bx,by+bH-ch)
            co[7].From=Vector2.new(bx+bW,by+bH); co[7].To=Vector2.new(bx+bW-cw,by+bH); co[8].From=Vector2.new(bx+bW,by+bH); co[8].To=Vector2.new(bx+bW,by+bH-ch)
            for _,ln in ipairs(co) do ln.Color=col; ln.Visible=true end
        elseif e.Corners then for _,ln in ipairs(e.Corners) do ln.Visible=false end end
        if ESPSettings.NameESP then e.Name.Text=plr.Name; e.Name.Position=Vector2.new(rp.X,hp2.Y-18); e.Name.Color=ESPSettings.TextColor; e.Name.Visible=true else e.Name.Visible=false end
        if ESPSettings.HealthESP then local hp=math.clamp(hum.Health/hum.MaxHealth,0,1); e.Health.Text=math.floor(hp*100).."%"; e.Health.Position=Vector2.new(rp.X,lp2.Y+5); e.Health.Color=Color3.fromRGB(math.floor((1-hp)*255),math.floor(hp*255),0); e.Health.Visible=true else e.Health.Visible=false end
        if ESPSettings.DistanceESP then e.Distance.Text="["..math.floor(dist).."m]"; e.Distance.Position=Vector2.new(rp.X,lp2.Y+18); e.Distance.Visible=true else e.Distance.Visible=false end
        if ESPSettings.TracerESP then local fr=Vector2.new(vp.X/2,vp.Y); local to=Vector2.new(rp.X,lp2.Y); e.TracerOutline.From=fr; e.TracerOutline.To=to; e.TracerOutline.Visible=true; e.Tracer.From=fr; e.Tracer.To=to; e.Tracer.Color=ESPSettings.TracerColor; e.Tracer.Visible=true else e.Tracer.Visible=false; e.TracerOutline.Visible=false end
    end) end
end
for _,plr in pairs(Players:GetPlayers()) do CreateESPForPlayer(plr) end
Players.PlayerAdded:Connect(CreateESPForPlayer)
Players.PlayerRemoving:Connect(RemoveESPForPlayer)
RunService.RenderStepped:Connect(UpdateESP)
local function ApplyChams(plr)
    if plr==LocalPlayer or not plr.Character then return end
    pcall(function()
        local old=plr.Character:FindFirstChild("WalChams"); if old then old:Destroy() end
        local hi=Instance.new("Highlight"); hi.Name="WalChams"; hi.FillColor=chamsFillColor; hi.OutlineColor=chamsOutlineColor
        hi.FillTransparency=0.4; hi.OutlineTransparency=0; hi.Adornee=plr.Character; hi.Parent=plr.Character; ChamsHighlights[plr]=hi
    end)
end
local function RefreshChams()
    if not getgenv().ChamsEnabled then return end
    for _,plr in pairs(Players:GetPlayers()) do ApplyChams(plr) end
end
local VisualsTab = UI:AddTab("Visuals","👁️",3.5)

do

    local _tracerModes = {beam=false,blind=false,bigbox=false,plane=false,bigball=false,pole=false,cross=false}
    pcall(function() getgenv()._tracerModes = _tracerModes end)
    local function _VB(tool,dir,color,size,shape,mat)
        if not tool then return end
        local h=tool:FindFirstChild("Handle"); if not h then return end
        local gsl=tool:FindFirstChild("GunScript_Local"); if not gsl then return end
        local fp=h:FindFirstChild("GunFirePoint") or h
        pcall(function() ReplicatedStorage.VisualizeBullet:FireServer(tool,h,dir,fp,{true,{112139677907600,92977228204408},1,1,10,gsl:FindFirstChild("HitEffect"),true},{false,{},1,1,1,nil},{false,0,{},false,0,0},{false,0,false,{},0,0,0,false,nil},{true,Vector3.new(0.1,0,0),Vector3.new(-0.1,0,0),gsl:FindFirstChild("TracerEffect"),nil,gsl:FindFirstChild("ParticleEffect"),300,526,0,Vector3.zero,size,color,0,mat,shape,false,6696543809,0,Vector3.new(0.007,0.007,0.007)},{false,{},0.5,1,1,100},{false,0,Color3.new(1,0.647,0.6),0,false}) end)
    end
    local function _Beam(from,to,color,thick,dur)
        local d=(to-from).Magnitude; if d<0.1 then return end
        local p=Instance.new("Part"); p.Size=Vector3.new(thick,thick,d); p.CFrame=CFrame.new((from+to)/2,to); p.Anchored=true; p.CanCollide=false; p.Material=Enum.Material.Neon; p.Color=color; p.Parent=workspace
        TweenService:Create(p,TweenInfo.new(dur),{Transparency=1}):Play(); task.delay(dur+0.1,function() pcall(function() p:Destroy() end) end)
    end
    local _MFNS={
        beam=function(f,t,tool,dir) _Beam(f,t,Color3.fromRGB(0,200,255),0.28,0.5); _VB(tool,dir,Color3.fromRGB(0,200,255),Vector3.new(0.25,0.25,0.25),Enum.PartType.Cylinder,Enum.Material.Neon) end,
        blind=function(f,t,tool,dir) _Beam(f,t,Color3.new(1,1,1),0.5,0.4); task.spawn(function() for i=1,15 do _VB(tool,dir,Color3.new(1,1,1),Vector3.new(3,3,3),Enum.PartType.Ball,Enum.Material.Neon); task.wait(0.06) end end) end,
        bigbox=function(f,t,tool,dir) local c2=Color3.fromRGB(255,40,40); _Beam(f,t,c2,0.35,0.5); task.spawn(function() for i=1,10 do _VB(tool,dir,c2,Vector3.new(4,4,4),Enum.PartType.Block,Enum.Material.Neon); task.wait(0.05) end end) end,
        bigball=function(f,t,tool,dir) local c2=Color3.fromRGB(0,255,150); _Beam(f,t,c2,0.35,0.5); task.spawn(function() for i=1,10 do _VB(tool,dir,c2,Vector3.new(4,4,4),Enum.PartType.Ball,Enum.Material.Neon); task.wait(0.05) end end) end,
        pole=function(f,t,tool,dir) local c2=Color3.fromRGB(255,80,255); _Beam(f,t,c2,0.3,0.5); task.spawn(function() for i=1,10 do _VB(tool,dir,c2,Vector3.new(1,1,1),Enum.PartType.Cylinder,Enum.Material.Neon); task.wait(0.05) end end) end,
        cross=function(f,t,tool,dir) local c2=Color3.fromRGB(255,220,0); _Beam(f,t,c2,0.3,0.5); task.spawn(function() for i=1,8 do _VB(tool,dir,c2,Vector3.new(0.5,0.5,0.5),Enum.PartType.Cylinder,Enum.Material.Neon); task.wait(0.05) end end) end,
        plane=function(f,t,tool,dir) local c2=Color3.fromRGB(150,200,255); _Beam(f,t,c2,0.3,0.5); task.spawn(function() for i=1,8 do _VB(tool,dir,c2,Vector3.new(2,2,2),Enum.PartType.Block,Enum.Material.Neon); task.wait(0.06) end end) end,
    }
    local function _shootTracers(tool)
        local char=LocalPlayer.Character; if not char then return end
        local handle=tool:FindFirstChild("Handle"); if not handle then return end
        local cam=workspace.CurrentCamera; local dir=cam.CFrame.LookVector; local from=handle.Position
        local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances={char}
        local result=workspace:Raycast(from,dir*800,params); local to=result and result.Position or (from+dir*800)
        for k,v in pairs(_tracerModes) do if v and _MFNS[k] then task.spawn(_MFNS[k],from,to,tool,dir) end end
    end
    local function _hookGun(t) t.Activated:Connect(function() _shootTracers(t) end) end
    local function _hookChar(ch) ch.ChildAdded:Connect(function(c2) if c2:IsA("Tool") then _hookGun(c2) end end); for _,c2 in ipairs(ch:GetChildren()) do if c2:IsA("Tool") then _hookGun(c2) end end end
    if LocalPlayer.Character then _hookChar(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(_hookChar)

    UI:AddSection(VisualsTab, "🔫 Bullet Tracers")
    UI:AddToggle(VisualsTab, "Blue Balls Tracer", false, function(v) _tracerModes.beam=v end)
    UI:AddToggle(VisualsTab, "White Ball Tracer", false, function(v) _tracerModes.blind=v end)
    UI:AddToggle(VisualsTab, "Red Box Tracer", false, function(v) _tracerModes.bigbox=v end)
    UI:AddToggle(VisualsTab, "Neon Blue Tracer", false, function(v) _tracerModes.plane=v end)
    UI:AddToggle(VisualsTab, "Cyan Ball Tracer", false, function(v) _tracerModes.bigball=v end)
    UI:AddToggle(VisualsTab, "Pink Tracers", false, function(v) _tracerModes.pole=v end)
    UI:AddToggle(VisualsTab, "Yellow Tracer", false, function(v) _tracerModes.cross=v end)

    local CarModsTab = UI:AddTab("Car Mods", "🚗", 3.7)

    UI:AddSection(CarModsTab, "⛽ Fuel")
    local _infFuelConn
    UI:AddToggle(CarModsTab, "Inf Fuel", false, function(state)
        if _infFuelConn then _infFuelConn:Disconnect(); _infFuelConn=nil end
        if not state then return end
        local pumps, lastScan = {}, 0
        _infFuelConn = RunService.Heartbeat:Connect(function()
            local char=LocalPlayer.Character; if not char then return end
            local hum=char:FindFirstChild("Humanoid"); if not hum or not hum.SeatPart then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            if tick()-lastScan > 4 then
                lastScan=tick(); pumps={}
                local map=workspace:FindFirstChild("1# Map")
                if map then for _,v in ipairs(map:GetDescendants()) do if v.Name=="#Pump" and v:IsA("MeshPart") then pumps[#pumps+1]=v end end end
            end
            for _,v in ipairs(pumps) do
                if v.Parent and (v.Position-hrp.Position).Magnitude <= 18.5 then
                    if not LocalPlayer:GetAttribute("PaidGas") then pcall(function() ReplicatedStorage.RequestRefill:FireServer("Purchase") end) end
                    if LocalPlayer:GetAttribute("PaidGas") then pcall(function() ReplicatedStorage.RequestRefill:FireServer(true) end) end
                end
            end
        end)
    end)

    local VM = { SpeedEnabled=false, SpeedValue=0.005, BreakEnabled=false, BreakValue=0.05, InstantStop=false, InstantStopBind=Enum.KeyCode.V }
    local function _vmSeat()
        local char=LocalPlayer.Character; if not char then return end
        local hum=char:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then return hum.SeatPart end
    end
    RunService.Heartbeat:Connect(function()
        if VM.SpeedEnabled and UserInputService:IsKeyDown(Enum.KeyCode.W) then
            local s=_vmSeat(); if s then s.AssemblyLinearVelocity = s.AssemblyLinearVelocity * Vector3.new(1+VM.SpeedValue,1,1+VM.SpeedValue) end
        end
        if VM.BreakEnabled and UserInputService:IsKeyDown(Enum.KeyCode.S) then
            local s=_vmSeat(); if s then s.AssemblyLinearVelocity = s.AssemblyLinearVelocity * Vector3.new(1-VM.BreakValue,1,1-VM.BreakValue) end
        end
        if VM.InstantStop and VM.InstantStopHeld then
            local s=_vmSeat(); if s then s.AssemblyLinearVelocity=Vector3.new(0,0,0); s.AssemblyAngularVelocity=Vector3.new(0,0,0) end
        end
    end)
    UI:AddSection(CarModsTab, "🚗 Vehicle Modifications")
    UI:AddToggle(CarModsTab, "Velocity Speed Enabled", false, function(s) VM.SpeedEnabled=s end)
    UI:AddSlider(CarModsTab, "Speed Value", 1, 25, 5, function(v) VM.SpeedValue=v/1000 end)
    UI:AddToggle(CarModsTab, "Break Velocity Enabled", false, function(s) VM.BreakEnabled=s end)
    UI:AddSlider(CarModsTab, "Break Value", 10, 300, 50, function(v) VM.BreakValue=v/1000 end)
    UI:AddToggle(CarModsTab, "Instant Break Enabled", false, function(s) VM.InstantStop=s end)
    UI:AddKeybind(CarModsTab, "Instant Break Key", Enum.KeyCode.V, function(on) VM.InstantStopHeld = on end)
end

do
    UI:AddSection(ExploitsTab, "🛡️ Admin Detection")
    UI:AddToggle(ExploitsTab, "Admin Detection (Auto Leave)", false, function(v)
        getgenv()._adminDetect = v
        if v then
            local adminIds = {7574356202,9840202816,2361804144,504603254,2059859959,1673101632,3744075531,5170526005,329097649,8879510201,1591729028,4006717220,1965457341,100696125,157944161,571073274,1913839150,1043344298,691991358,3127042754,9802505,1187817721,1188540444,3997447018,5518581701,2300787931,4246623001,336408538,7309042402,39901822,5068993693,2632508759,1196871048,97728999,8472043145,2495032,7262444842,26105082,4301940303,40871536,3602117253,2248489384}
            local adminSet = {}; for _,id in ipairs(adminIds) do adminSet[id]=true end
            for _,p in pairs(Players:GetPlayers()) do if adminSet[p.UserId] then game:GetService("TeleportService"):Teleport(game.PlaceId); return end end
            if not getgenv()._adminConn then
                getgenv()._adminConn = Players.PlayerAdded:Connect(function(p)
                    if getgenv()._adminDetect and adminSet[p.UserId] then
                        task.wait(0.5)
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    end
                end)
            end
            Notify("Admin", "Detection ON - monitoring for admins", 3)
        else
            if getgenv()._adminConn then getgenv()._adminConn:Disconnect(); getgenv()._adminConn = nil end
            Notify("Admin", "Detection OFF", 2)
        end
    end)
end

do
    local Lighting = game:GetService("Lighting")
    local TweenSrv = game:GetService("TweenService")
    local blur = Instance.new("BlurEffect"); blur.Size = 0; blur.Enabled = false; blur.Parent = Lighting
    local cc = Instance.new("ColorCorrectionEffect"); cc.Saturation = 0; cc.Enabled = false; cc.Parent = Lighting
    local gui = Instance.new("ScreenGui"); gui.Name = "SkidHubWasted"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 999998
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not gui.Parent then pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
    local function edge(size, pos, anchor, rot, t0, t1)
        local f = Instance.new("Frame")
        f.Size = size; f.Position = pos; f.AnchorPoint = anchor
        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ZIndex = 2; f.Parent = gui
        local g = Instance.new("UIGradient")
        g.Rotation = rot
        g.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, t0), NumberSequenceKeypoint.new(1, t1) })
        g.Parent = f
        return f
    end
    local edges = {
        edge(UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 90, 0, 1),
        edge(UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 1, 0), Vector2.new(0, 1), 90, 1, 0),
        edge(UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 0, 0, 1),
        edge(UDim2.new(0.4, 0, 1, 0), UDim2.new(1, 0, 0, 0), Vector2.new(1, 0), 0, 1, 0),
    }
    local wasted = Instance.new("TextLabel"); wasted.Size = UDim2.new(1, 0, 0, 120); wasted.Position = UDim2.new(0, 0, 0.5, -60); wasted.BackgroundTransparency = 1; wasted.ZIndex = 5
    wasted.Font = Enum.Font.Bangers; wasted.Text = "WASTED"; wasted.TextSize = 110; wasted.TextColor3 = Color3.fromRGB(200, 0, 0)
    wasted.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); wasted.TextStrokeTransparency = 0; wasted.TextTransparency = 1; wasted.Parent = gui
    local active = false
    local function show()
        active = true
        blur.Enabled = true; cc.Enabled = true
        TweenSrv:Create(blur, TweenInfo.new(0.6), { Size = 18 }):Play()
        TweenSrv:Create(cc, TweenInfo.new(0.6), { Saturation = -0.85 }):Play()
        TweenSrv:Create(wasted, TweenInfo.new(0.8), { TextTransparency = 0 }):Play()
        task.spawn(function()
            while active do
                for _, f in ipairs(edges) do TweenSrv:Create(f, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.45 }):Play() end
                TweenSrv:Create(wasted, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { TextSize = 124 }):Play()
                task.wait(0.78)
                if not active then break end
                for _, f in ipairs(edges) do TweenSrv:Create(f, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.02 }):Play() end
                TweenSrv:Create(wasted, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { TextSize = 108 }):Play()
                task.wait(0.78)
            end
        end)
    end
    local function hide()
        active = false
        for _, f in ipairs(edges) do TweenSrv:Create(f, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play() end
        TweenSrv:Create(blur, TweenInfo.new(0.4), { Size = 0 }):Play()
        TweenSrv:Create(cc, TweenInfo.new(0.4), { Saturation = 0 }):Play()
        TweenSrv:Create(wasted, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        task.delay(0.45, function() blur.Enabled = false; cc.Enabled = false end)
    end
    local function hook(char)
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if hum then hum.Died:Connect(show) end
    end
    if LocalPlayer.Character then hook(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(char) hide() hook(char) end)
end
UI:AddSection(VisualsTab,"👁️ ESP")
UI:AddToggle(VisualsTab,"Enable ESP",false,function(v) ESPSettings.Enabled=v end)
UI:AddToggle(VisualsTab,"Box ESP",false,function(v) ESPSettings.BoxESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"Box Fill",false,function(v) ESPSettings.BoxFill=v end)
UI:AddToggle(VisualsTab,"Box Corners",false,function(v) ESPSettings.BoxCorners=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"3D Box ESP",false,function(v) ESPSettings.Box3DESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"Name ESP",false,function(v) ESPSettings.NameESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"Health ESP",false,function(v) ESPSettings.HealthESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"Tracer ESP",false,function(v) ESPSettings.TracerESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddToggle(VisualsTab,"Distance ESP",false,function(v) ESPSettings.DistanceESP=v; if v then ESPSettings.Enabled=true end end)
UI:AddSlider(VisualsTab,"Max Distance",100,2000,800,function(v) ESPSettings.MaxDistance=v end)
UI:AddDropdown(VisualsTab,"Box Color",{"Red","Purple","Green","Blue","White","Yellow","Cyan","Orange","Pink"},"Red",function(v)
    if espColorMap[v] then ESPSettings.BoxColor=espColorMap[v]; ESPSettings.TracerColor=espColorMap[v]
        for _,e in pairs(ESPObjects) do pcall(function() e.Box.Color=espColorMap[v]; e.Tracer.Color=espColorMap[v]; for _,ln in ipairs(e.Corners or {}) do ln.Color=espColorMap[v] end; for _,ln in ipairs(e.Box3D or {}) do ln.Color=espColorMap[v] end end) end end
end)
UI:AddSection(VisualsTab,"✨ Chams")
UI:AddToggle(VisualsTab,"Chams",false,function(v)
    getgenv().ChamsEnabled=v
    if v then
        RefreshChams()
        if getgenv().ChamsConn then getgenv().ChamsConn:Disconnect() end
        getgenv().ChamsConn=Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function() task.wait(0.5); if getgenv().ChamsEnabled then ApplyChams(plr) end end) end)
        for _,plr in pairs(Players:GetPlayers()) do if plr~=LocalPlayer then plr.CharacterAdded:Connect(function() task.wait(0.5); if getgenv().ChamsEnabled then ApplyChams(plr) end end) end end
        spawn(function() while getgenv().ChamsEnabled do task.wait(5); RefreshChams() end end)
        Notify("Chams","Enabled",2)
    else
        for plr,hi in pairs(ChamsHighlights) do pcall(function() if hi and hi.Parent then hi:Destroy() end end) end; ChamsHighlights={}
        for _,plr in pairs(Players:GetPlayers()) do if plr.Character then local hi=plr.Character:FindFirstChild("WalChams"); if hi then hi:Destroy() end end end
        if getgenv().ChamsConn then getgenv().ChamsConn:Disconnect(); getgenv().ChamsConn=nil end; Notify("Chams","Disabled",2)
    end
end)
UI:AddDropdown(VisualsTab,"Chams Fill Color",{"Purple","Red","Green","Blue","White","Yellow","Cyan","Orange","Pink"},"Purple",function(v)
    if espColorMap[v] then chamsFillColor=espColorMap[v]; for _,hi in pairs(ChamsHighlights) do pcall(function() if hi and hi.Parent then hi.FillColor=chamsFillColor end end) end; if getgenv().ChamsEnabled then RefreshChams() end end
end)
UI:AddDropdown(VisualsTab,"Chams Outline Color",{"Pink","Red","Green","Blue","White","Yellow","Cyan","Orange","Purple"},"Pink",function(v)
    if espColorMap[v] then chamsOutlineColor=espColorMap[v]; for _,hi in pairs(ChamsHighlights) do pcall(function() if hi and hi.Parent then hi.OutlineColor=chamsOutlineColor end end) end; if getgenv().ChamsEnabled then RefreshChams() end end
end)
UI:AddSection(VisualsTab,"🌅 Sky Presets")
UI:AddButton(VisualsTab,"Day Time Sky",function()
    local L=game:GetService("Lighting"); L.ClockTime=9
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://74258544564321"; S.SkyboxDn="rbxassetid://75418092548143"; S.SkyboxFt="rbxassetid://114547356324218"; S.SkyboxLf="rbxassetid://91138773974890"; S.SkyboxRt="rbxassetid://111749399946832"; S.SkyboxUp="rbxassetid://96933043812138"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Night Time Sky",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://155624722"; S.SkyboxDn="rbxassetid://155624727"; S.SkyboxFt="rbxassetid://155624730"; S.SkyboxLf="rbxassetid://155624736"; S.SkyboxRt="rbxassetid://155624742"; S.SkyboxUp="rbxassetid://155624749"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Pink Clouds",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://11555017034"; S.SkyboxDn="rbxassetid://11555013415"; S.SkyboxFt="rbxassetid://11555010145"; S.SkyboxLf="rbxassetid://11555006545"; S.SkyboxRt="rbxassetid://11555000712"; S.SkyboxUp="rbxassetid://11554996247"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Purple Galaxy",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://159454299"; S.SkyboxDn="rbxassetid://159454296"; S.SkyboxFt="rbxassetid://159454293"; S.SkyboxLf="rbxassetid://159454286"; S.SkyboxRt="rbxassetid://159454300"; S.SkyboxUp="rbxassetid://159454288"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Sunset",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://15502525195"; S.SkyboxDn="rbxassetid://15502522797"; S.SkyboxFt="rbxassetid://15502524520"; S.SkyboxLf="rbxassetid://15502522129"; S.SkyboxRt="rbxassetid://15502523711"; S.SkyboxUp="rbxassetid://15502526102"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Cloudy Summer",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky"); S.SkyboxBk="rbxassetid://17838127289"; S.SkyboxDn="rbxassetid://17838129609"; S.SkyboxFt="rbxassetid://17838144422"; S.SkyboxLf="rbxassetid://17838131484"; S.SkyboxRt="rbxassetid://17838148822"; S.SkyboxUp="rbxassetid://17838140709"; S.Parent=L
end)
UI:AddButton(VisualsTab,"Custom Sky",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    local S=Instance.new("Sky")
    local id="rbxassetid://117345242676633"
    S.SkyboxBk=id; S.SkyboxDn=id; S.SkyboxFt=id; S.SkyboxLf=id; S.SkyboxRt=id; S.SkyboxUp=id
    S.Parent=L
end)
do
    local skies = {
        {"pat",     "72781607771925"},
        {"thinker", "109804031157929"},
        {"son",     "129967531694220"},
        {"dex",     "84585770971279"},
        {"GOD",     "82397705080892"},
        {"huh",     "99333367082849"},
    }
    for _, sky in ipairs(skies) do
        local name, id = sky[1], "rbxassetid://"..sky[2]
        UI:AddButton(VisualsTab, name, function()
            local L = game:GetService("Lighting")
            local old = L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
            local S = Instance.new("Sky")
            S.SkyboxBk=id; S.SkyboxDn=id; S.SkyboxFt=id; S.SkyboxLf=id; S.SkyboxRt=id; S.SkyboxUp=id
            S.Parent = L
        end)
    end
end
UI:AddButton(VisualsTab,"Reset Sky",function()
    local L=game:GetService("Lighting")
    local old=L:FindFirstChildOfClass("Sky"); if old then old:Destroy() end
    L.ClockTime=14
end)
end
end
end)()
-- ===== Theme tab =====
local THEME_KEYS = { "accent", "window_outline", "inline", "background", "visible_backgrounds", "text_color", "glow", "deselected" }
local THEME_FILE = "SkidHub_Theme.txt"
local ThemePresets = {
    ["Christmas"] = {
        accent = Color3.fromRGB(240, 56, 72), window_outline = Color3.fromRGB(0, 0, 0),
        inline = Color3.fromRGB(26, 34, 29), background = Color3.fromRGB(14, 22, 18),
        visible_backgrounds = Color3.fromRGB(18, 27, 21), text_color = Color3.fromRGB(248, 242, 228),
        glow = Color3.fromRGB(60, 230, 130), deselected = Color3.fromRGB(112, 136, 118),
    },
    ["Aurora Boreal"] = {
        accent = Color3.fromRGB(195, 120, 255), window_outline = Color3.fromRGB(140, 110, 200),
        inline = Color3.fromRGB(50, 32, 82), background = Color3.fromRGB(26, 16, 46),
        visible_backgrounds = Color3.fromRGB(38, 24, 64), text_color = Color3.fromRGB(242, 235, 255),
        glow = Color3.fromRGB(150, 90, 255), deselected = Color3.fromRGB(150, 130, 195),
    },
    ["Skid Purple"] = {
        accent = Color3.fromRGB(151, 0, 255), window_outline = Color3.fromRGB(151, 0, 255),
        inline = Color3.fromRGB(27, 27, 27), background = Color3.fromRGB(17, 19, 19),
        visible_backgrounds = Color3.fromRGB(18, 18, 18), text_color = Color3.fromRGB(221, 223, 222),
        glow = Color3.fromRGB(151, 0, 255), deselected = Color3.fromRGB(89, 91, 91),
    },
    ["Ocean"] = {
        accent = Color3.fromRGB(60, 170, 255), window_outline = Color3.fromRGB(30, 90, 150),
        inline = Color3.fromRGB(22, 36, 54), background = Color3.fromRGB(12, 20, 32),
        visible_backgrounds = Color3.fromRGB(16, 28, 44), text_color = Color3.fromRGB(226, 240, 255),
        glow = Color3.fromRGB(60, 170, 255), deselected = Color3.fromRGB(100, 125, 150),
    },
    ["Crimson"] = {
        accent = Color3.fromRGB(235, 50, 60), window_outline = Color3.fromRGB(120, 20, 28),
        inline = Color3.fromRGB(38, 20, 22), background = Color3.fromRGB(22, 12, 13),
        visible_backgrounds = Color3.fromRGB(30, 16, 18), text_color = Color3.fromRGB(245, 230, 230),
        glow = Color3.fromRGB(235, 50, 60), deselected = Color3.fromRGB(140, 105, 108),
    },
    ["Mint"] = {
        accent = Color3.fromRGB(70, 225, 160), window_outline = Color3.fromRGB(30, 110, 80),
        inline = Color3.fromRGB(22, 38, 32), background = Color3.fromRGB(12, 22, 18),
        visible_backgrounds = Color3.fromRGB(16, 30, 24), text_color = Color3.fromRGB(228, 248, 240),
        glow = Color3.fromRGB(70, 225, 160), deselected = Color3.fromRGB(105, 140, 125),
    },
}
local ThemeOrder = { "Christmas", "Aurora Boreal", "Skid Purple", "Ocean", "Crimson", "Mint" }

local currentTheme = {}
for key, color in pairs(ThemePresets["Christmas"]) do currentTheme[key] = color end

local function ApplyThemeColors(t)
    for _, key in ipairs(THEME_KEYS) do
        if t[key] then
            pcall(function() Library:RefreshTheme(key, t[key]) end)
            currentTheme[key] = t[key]
        end
    end
    pcall(function() Window.Items.Glow.ImageColor3 = currentTheme.glow end)
end

local function ApplyThemePreset(name, remember)
    local preset = ThemePresets[name]
    if not preset then return end
    ApplyThemeColors(preset)
    if remember and type(writefile) == "function" then
        pcall(writefile, THEME_FILE, name)
    end
end

local savedThemeName = "Christmas"
if type(isfile) == "function" and type(readfile) == "function" then
    pcall(function()
        if isfile(THEME_FILE) then
            local saved = readfile(THEME_FILE)
            if ThemePresets[saved] then savedThemeName = saved end
        end
    end)
end

local ThemeTab = Window:Tab({ Name = "Theme" })
local ThemeSection = ThemeTab:Section({ Name = "Theme", Side = "Left" })
local ThemeCustom = ThemeTab:Section({ Name = "Custom colors", Side = "Right" })

ThemeSection:Dropdown({
    Name = "Theme preset",
    Options = ThemeOrder,
    Default = savedThemeName,
    Callback = function(Value)
        if not uiReady then return end
        ApplyThemePreset(Value, true)
    end,
})

ThemeSection:Button({
    Name = "Reset to Christmas",
    Callback = function()
        ApplyThemePreset("Christmas", true)
    end,
})

ThemeSection:Label({ Name = "Recolors the whole menu" })
ThemeSection:Label({ Name = "Your pick is remembered next time" })

ThemeCustom:Label({ Name = "Accent"}):Colorpicker({
    Color = currentTheme.accent,
    Callback = function(color)
        if not uiReady then return end
        ApplyThemeColors({ accent = color })
    end,
})
ThemeCustom:Label({ Name = "Background"}):Colorpicker({
    Color = currentTheme.background,
    Callback = function(color)
        if not uiReady then return end
        ApplyThemeColors({ background = color })
    end,
})
ThemeCustom:Label({ Name = "Text"}):Colorpicker({
    Color = currentTheme.text_color,
    Callback = function(color)
        if not uiReady then return end
        ApplyThemeColors({ text_color = color })
    end,
})


Library:FestiveTab(Window)
Library:Configs(Window)
uiReady = true
if savedThemeName ~= "Christmas" then
    ApplyThemePreset(savedThemeName, false)
end
Notify("Skid Hub", "Loaded | RightShift to toggle", 4)

task.spawn(function()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then return end
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local existing = parent:FindFirstChild("_CursorDot"); if existing then existing:Destroy() end
    local dotGui = Instance.new("ScreenGui")
    dotGui.Name = "_CursorDot"; dotGui.ResetOnSpawn = false; dotGui.IgnoreGuiInset = true; dotGui.DisplayOrder = 999999
    dotGui.Parent = parent
    local dot = Instance.new("Frame")
    dot.AnchorPoint = Vector2.new(0.5,0.5); dot.Size = UDim2.fromOffset(6,6)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0
    dot.ZIndex = 999999; dot.Parent = dotGui
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(0,0,0); st.Thickness = 1; st.Transparency = 0.4; st.Parent = dot
    RunService.RenderStepped:Connect(function()
        local m = UserInputService:GetMouseLocation()
        dot.Position = UDim2.fromOffset(m.X, m.Y)
    end)
end)
