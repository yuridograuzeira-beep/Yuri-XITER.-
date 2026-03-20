--[[
    PAINEL DA NICOLLE 🥰 - Flee The Facility
    Versão Completa com todas as funções pedidas
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "PainelDaNicolle"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Variáveis de controle
local settings = {
    -- ESP
    computerESP = false,
    freezerESP = false,
    innocentESP = false,
    beastESP = false,
    exitESP = false,
    
    -- Movimento
    speed = false,
    fly = false,
    superJump = false,
    infiniteStamina = false,
    
    -- Efeitos
    fullbright = false,
    thirdPerson = false,
    invisible = false,
    hitboxExpander = false,
    
    -- Alertas
    beastAlert = false,
    
    -- Ajustes
    speedValue = 50,
    jumpValue = 80,
    
    -- Controle do painel
    panelOpen = false
}

-- Variáveis para funções específicas
local flyConnection = nil
local alertConnection = nil
local originalCFrame = nil
local originalSize = {}

-- CRIAR ÍCONE MINIMALISTA
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0, 20)
icon.BackgroundColor3 = Color3.fromRGB(48, 25, 52)
icon.BorderSizePixel = 3
icon.BorderColor3 = Color3.fromRGB(255, 105, 180)
icon.Text = "🥰"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 30
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = icon

-- CRIAR PAINEL COMPLETO
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 380, 0, 750)
panel.Position = UDim2.new(0, 100, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(48, 25, 52)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 3
panel.BorderColor3 = Color3.fromRGB(255, 105, 180)
panel.Active = true
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
title.Text = "🥰 PAINEL DA NICOLLE 🥰"
title.TextColor3 = Color3.fromRGB(255, 182, 193)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextStrokeColor3 = Color3.fromRGB(255, 105, 180)
title.TextStrokeTransparency = 0.3
title.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = panel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Função para alternar painel
icon.MouseButton1Click:Connect(function()
    settings.panelOpen = not settings.panelOpen
    panel.Visible = settings.panelOpen
end)

closeButton.MouseButton1Click:Connect(function()
    settings.panelOpen = false
    panel.Visible = false
end)

-- Função para criar seções
local function createSection(title, yPos, emoji)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(0.95, 0, 0, 30)
    section.Position = UDim2.new(0.025, 0, 0, yPos)
    section.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    section.Text = emoji .. " " .. title .. " " .. emoji
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.Parent = panel
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    return yPos + 35
end

-- Função para criar botões
local function createToggle(name, setting, yPos, emoji)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 32)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    button.Text = "   " .. emoji .. " " .. name .. ":  Desativado"
    button.TextColor3 = Color3.fromRGB(255, 182, 193)
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(255, 105, 180)
    button.Parent = panel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        button.Text = "   " .. emoji .. " " .. name .. ":  " .. (settings[setting] and "Ativado 💖" or "Desativado")
        button.TextColor3 = settings[setting] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 182, 193)
        
        -- Ativar/desativar funções especiais
        if setting == "hitboxExpander" then
            toggleHitbox()
        elseif setting == "thirdPerson" then
            toggleThirdPerson()
        elseif setting == "invisible" then
            toggleInvisible()
        elseif setting == "beastAlert" then
            toggleBeastAlert()
        elseif setting == "infiniteStamina" then
            toggleInfiniteStamina()
        end
    end)
    
    return yPos + 37
end

-- Criar abas no painel
local yPos = 55
yPos = createSection("ESP - VER TUDO", yPos, "🎯")
yPos = createToggle("COMPUTADORES", "computerESP", yPos, "💻")
yPos = createToggle("FREEZER", "freezerESP", yPos, "❄️")
yPos = createToggle("INOCENTES", "innocentESP", yPos, "😇")
yPos = createToggle("A BESTA", "beastESP", yPos, "👾")
yPos = createToggle("SAÍDAS", "exitESP", yPos, "🚪")

yPos = yPos + 5
yPos = createSection("MOVIMENTAÇÃO", yPos, "⚡")
yPos = createToggle("SUPER VELOCIDADE", "speed", yPos, "🚀")
yPos = createToggle("VOAR", "fly", yPos, "🕊️")
yPos = createToggle("SUPER PULO", "superJump", yPos, "🦘")
yPos = createToggle("INFINITO STAMINA", "infiniteStamina", yPos, "💪")

yPos = yPos + 5
yPos = createSection("EFEITOS ESPECIAIS", yPos, "✨")
yPos = createToggle("FULL LIGHT", "fullbright", yPos, "🌞")
yPos = createToggle("TERCEIRA PESSOA", "thirdPerson", yPos, "🎥")
yPos = createToggle("INVISÍVEL", "invisible", yPos, "👻")
yPos = createToggle("HITBOX EXPANDER", "hitboxExpander", yPos, "📦")

yPos = yPos + 5
yPos = createSection("ALERTAS", yPos, "⚠️")
yPos = createToggle("ALERTA DA BESTA", "beastAlert", yPos, "🔔")

-- Sliders
yPos = yPos + 5
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, yPos)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Velocidade: " .. settings.speedValue
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.Parent = panel

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
speedSlider.Position = UDim2.new(0.05, 0, 0, yPos + 20)
speedSlider.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
speedSlider.BorderSizePixel = 2
speedSlider.BorderColor3 = Color3.fromRGB(255, 105, 180)
speedSlider.Parent = panel

local speedIndicator = Instance.new("Frame")
speedIndicator.Size = UDim2.new(settings.speedValue / 200, 1, 0, 0)
speedIndicator.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
speedIndicator.BorderSizePixel = 0
speedIndicator.Parent = speedSlider

local speedDrag = Instance.new("TextButton")
speedDrag.Size = UDim2.new(1, 0, 1, 0)
speedDrag.BackgroundTransparency = 1
speedDrag.Text = ""
speedDrag.Parent = speedSlider

speedDrag.MouseButton1Down:Connect(function()
    local connection
    connection = mouse.Move:Connect(function()
        local x = math.clamp(mouse.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
        settings.speedValue = math.floor(x / speedSlider.AbsoluteSize.X * 200)
        speedIndicator.Size = UDim2.new(settings.speedValue / 200, 0, 1, 0)
        speedLabel.Text = "⚡ Velocidade: " .. settings.speedValue
    end)
    mouse.Button1Up:Wait()
    connection:Disconnect()
end)

-- FUNÇÕES PRINCIPAIS

-- Hitbox Expander
local function toggleHitbox()
    if settings.hitboxExpander and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalSize[part] = part.Size
                part.Size = part.Size * 1.5
            end
        end
    elseif player.Character then
        for part, size in pairs(originalSize) do
            if part and part.Parent then
                part.Size = size
            end
        end
    end
end

-- Terceira Pessoa
local function toggleThirdPerson()
    if settings.thirdPerson then
        workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
        workspace.CurrentCamera.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 10), player.Character.HumanoidRootPart.Position)
        
        runService:BindToRenderStep("ThirdPerson", Enum.RenderPriority.Camera.Value, function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                workspace.CurrentCamera.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 10), player.Character.HumanoidRootPart.Position)
            end
        end)
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        runService:UnbindFromRenderStep("ThirdPerson")
    end
end

-- Invisível
local function toggleInvisible()
    if settings.invisible and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    elseif player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

-- Alerta da Besta
local function toggleBeastAlert()
    if alertConnection then
        alertConnection:Disconnect()
        alertConnection = nil
    end
    
    if settings.beastAlert then
        alertConnection = runService.RenderStepped:Connect(function()
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    -- Verifica se é a besta
                    local isBeast = false
                    if plr.Character:FindFirstChildOfClass("Tool") then
                        local tool = plr.Character:FindFirstChildOfClass("Tool")
                        if tool.Name:lower():find("hammer") then
                            isBeast = true
                        end
                    end
                    
                    if isBeast and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        
                        -- Alerta visual baseado na distância
                        if distance < 30 then
                            -- MUITO PERTO - alerta vermelho
                            local alert = Instance.new("ScreenGui")
                            alert.Parent = player:FindFirstChild("PlayerGui")
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            frame.BackgroundTransparency = 0.7
                            frame.Parent = alert
                            game:GetService("Debris"):AddItem(alert, 0.3)
                        elseif distance < 60 then
                            -- PERTO - alerta laranja
                            local alert = Instance.new("ScreenGui")
                            alert.Parent = player:FindFirstChild("PlayerGui")
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                            frame.BackgroundTransparency = 0.8
                            frame.Parent = alert
                            game:GetService("Debris"):AddItem(alert, 0.2)
                        end
                    end
                end
            end
        end)
    end
end

-- Stamina Infinita
local function toggleInfiniteStamina()
    if settings.infiniteStamina and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Running:Connect(function(speed)
            if speed > 0 then
                player.Character.Humanoid.WalkSpeed = settings.speedValue
            end
        end)
    end
end

-- ESP Saídas
local function exitESP()
    if settings.exitESP then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj.Name:lower():find("door") or obj.Name:lower():find("exit") or obj.Name:lower():find("porta")) and obj:IsA("BasePart") then
                if not obj:FindFirstChild("ExitESP") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ExitESP"
                    bill.Parent = obj
                    bill.Size = UDim2.new(0, 80, 0, 40)
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    bill.AlwaysOnTop = true
                    
                    local frame = Instance.new("Frame")
                    frame.Parent = bill
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
                    frame.BackgroundTransparency = 0.3
                    
                    local text = Instance.new("TextLabel")
                    text.Parent = frame
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = "🚪 SAÍDA"
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBold
                end
            end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ExitESP") then
                obj.ExitESP:Destroy()
            end
        end
    end
end

-- Loop principal
runService.RenderStepped:Connect(function()
    -- ESPs
    if settings.computerESP then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("computer") and obj:IsA("BasePart") and not obj:FindFirstChild("ComputerESP") then
                local bill = Instance.new("BillboardGui")
                bill.Name = "ComputerESP"
                bill.Parent = obj
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                local frame = Instance.new("Frame")
                frame.Parent = bill
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
                frame.BackgroundTransparency = 0.3
                local text = Instance.new("TextLabel")
                text.Parent = frame
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "💻 COMPUTADOR"
                text.TextColor3 = Color3.fromRGB(255, 255, 255)
                text.TextScaled = true
            end
        end
    end
    
    if settings.freezerESP then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("freezer") and obj:IsA("BasePart") and not obj:FindFirstChild("FreezerESP") then
                local bill = Instance.new("BillboardGui")
                bill.Name = "FreezerESP"
                bill.Parent = obj
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                local frame = Instance.new("Frame")
                frame.Parent = bill
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                frame.BackgroundTransparency = 0.3
                local text = Instance.new("TextLabel")
                text.Parent = frame
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "❄️ FREEZER"
                text.TextColor3 = Color3.fromRGB(255, 255, 255)
                text.TextScaled = true
            end
        end
    end
    
    exitESP()
    
    -- Movimento
    if settings.speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = settings.speedValue
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
    
    if settings.superJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 80
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 50
    end
    
    -- Fullbright
    if settings.fullbright then
        lighting.FogEnd = 100000
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.ClockTime = 12
    else
        lighting.FogEnd = 1000
        lighting.Brightness = 1
    end
end)

-- Fly separado
runService.RenderStepped:Connect(function()
    if settings.fly and not flyConnection then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local bodyGyro = Instance.new("BodyGyro")
            local bodyVelocity = Instance.new("BodyVelocity")
            
            bodyGyro.P = 9e4
            bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
            bodyGyro.CFrame = player.Character.HumanoidRootPart.CFrame
            
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
            
            bodyGyro.Parent = player.Character.HumanoidRootPart
            bodyVelocity.Parent = player.Character.HumanoidRootPart
            
            flyConnection = runService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local moveDirection = player.Character.Humanoid.MoveDirection * 50
                    if player.Character:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity.Velocity = moveDirection
                    end
                end
            end)
        end
    elseif not settings.fly and flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro") then
                player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
   
