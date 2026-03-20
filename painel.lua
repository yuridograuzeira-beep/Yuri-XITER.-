--[[
    Painel Flee The Facility - Yuri XITER
    Funcionalidades: Computer ESP, Beast ESP, Speed, Fly
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "YuriXITER_Painel"
screenGui.ResetOnSpawn = false

-- Criar painel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 320, 0, 450)
panel.Position = UDim2.new(0, 20, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = screenGui

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Text = "🎯 YURI XITER - FLEE FACILITY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Variáveis de controle
local settings = {
    computerESP = false,
    beastESP = false,
    speed = false,
    fly = false,
    speedValue = 50
}

-- Criar botões
local function createToggle(name, setting, yPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.Text = "   " .. name .. ":  Desativado"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = panel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        button.Text = "   " .. name .. ":  " .. (settings[setting] and "Ativado" or "Desativado")
        button.TextColor3 = settings[setting] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    end)
    
    return yPos + 40
end

-- Criar os botões no painel
local yPos = 50
yPos = createToggle("💻 COMPUTADORES", "computerESP", yPos)
yPos = createToggle("👾 A BESTA", "beastESP", yPos)
yPos = yPos + 10
yPos = createToggle("🚀 SPEED", "speed", yPos)
yPos = createToggle("🕊️ FLY", "fly", yPos)

-- Slider de velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, yPos + 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Velocidade: " .. settings.speedValue
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = panel

-- Fundo do slider
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0.9, 0, 0, 25)
slider.Position = UDim2.new(0.05, 0, 0, yPos + 30)
slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
slider.Parent = panel

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = slider

-- Indicador do slider
local sliderIndicator = Instance.new("Frame")
sliderIndicator.Size = UDim2.new(settings.speedValue / 200, 1, 0, 0)
sliderIndicator.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
sliderIndicator.BorderSizePixel = 0
sliderIndicator.Parent = slider

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 8)
indicatorCorner.Parent = sliderIndicator

-- Botão invisível para arrastar o slider
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(1, 0, 1, 0)
dragButton.BackgroundTransparency = 1
dragButton.Text = ""
dragButton.Parent = slider

dragButton.MouseButton1Down:Connect(function()
    local connection
    connection = mouse.Move:Connect(function()
        local relativeX = math.clamp(mouse.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
        settings.speedValue = math.floor(relativeX / slider.AbsoluteSize.X * 200)
        sliderIndicator.Size = UDim2.new(settings.speedValue / 200, 0, 1, 0)
        speedLabel.Text = "⚡ Velocidade: " .. settings.speedValue
    end)
    mouse.Button1Up:Wait()
    connection:Disconnect()
end)

-- Função Speed
local function updateSpeed()
    if settings.speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = settings.speedValue
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end

-- Função Fly
local flyConnection
local function toggleFly()
    if settings.fly then
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
            
            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local moveDirection = player.Character.Humanoid.MoveDirection * 50
                    if player.Character:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity.Velocity = moveDirection
                    end
                end
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro") then
                player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
            end
            if player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
            end
        end
    end
end

-- Monitorar botões de movimento
game:GetService("RunService").RenderStepped:Connect(function()
    if settings.speed then
        updateSpeed()
    end
    if settings.fly and not flyConnection then
        toggleFly()
    elseif not settings.fly and flyConnection then
        toggleFly()
    end
end)

-- Função ESP para computadores (simplificada)
local function computerESP()
    if settings.computerESP then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("computer") and obj:IsA("BasePart") then
                if not obj:FindFirstChild("ComputerESP") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ComputerESP"
                    bill.Parent = obj
                    bill.Size = UDim2.new(0, 100, 0, 40)
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    bill.AlwaysOnTop = true
                    
                    local frame = Instance.new("Frame")
                    frame.Parent = bill
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    frame.BackgroundTransparency = 0.3
                    
                    local text = Instance.new("TextLabel")
                    text.Parent = frame
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = "💻 COMPUTADOR"
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBold
                end
            end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ComputerESP") then
                obj.ComputerESP:Destroy()
            end
        end
    end
end

-- Função ESP para besta
local function beastESP()
    if settings.beastESP then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not plr.Character.HumanoidRootPart:FindFirstChild("BeastESP") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "BeastESP"
                    bill.Parent = plr.Character.HumanoidRootPart
                    bill.Size = UDim2.new(0, 120, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.AlwaysOnTop = true
                    
                    local frame = Instance.new("Frame")
                    frame.Parent = bill
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    frame.BackgroundTransparency = 0.2
                    
                    local text = Instance.new("TextLabel")
                    text.Parent = frame
                    text.Size = UDim2.new(1, 0, 0.6, 0)
                    text.Position = UDim2.new(0, 0, 0, 0)
                    text.BackgroundTransparency = 1
                    text.Text = "👾 BESTA"
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBold
                    
                    local health = Instance.new("TextLabel")
                    health.Parent = frame
                    health.Size = UDim2.new(1, 0, 0.4, 0)
                    health.Position = UDim2.new(0, 0, 0.6, 0)
                    health.BackgroundTransparency = 1
                    health.Text = "HP: " .. math.floor(plr.Character.Humanoid.Health)
                    health.TextColor3 = Color3.fromRGB(255, 255, 255)
                    health.TextScaled = true
                    
                    -- Atualizar vida
                    plr.Character.Humanoid.HealthChanged:Connect(function()
                        if health and health.Parent then
                            health.Text = "HP: " .. math.floor(plr.Character.Humanoid.Health)
                        end
                    end)
                end
            end
        end
    else
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if plr.Character.HumanoidRootPart:FindFirstChild("BeastESP") then
                    plr.Character.HumanoidRootPart.BeastESP:Destroy()
                end
            end
        end
    end
end

-- Loop principal para ESP
game:GetService("RunService").RenderStepped:Connect(function()
    computerESP()
    beastESP()
end)

-- Monitorar personagem
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if settings.speed then
        character.Humanoid.WalkSpeed = settings.speedValue
    end
end)

-- Rodapé
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -40)
footer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
footer.Text = "👾 Yuri XITER - Flee Facility\n📌 Clique nos botões para ativar"
footer.TextColor3 = Color3.fromRGB(180, 180, 200)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextWrapped = true
footer.Parent = panel

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 10)
footerCorner.Parent = footer

print("✅ PAINEL CARREGADO! Use os botões para ativar as funções.")
