-- TELEPORT SEQUENCIAL BONITO + INTERVALO CONFIGURÁVEL
-- By Deathbringer ⚡

local player = game.Players.LocalPlayer
local ativo = false
local inicio, fim, intervalo = 1, 10, 5

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TPPainel"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- TÍTULO
local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.BackgroundTransparency = 1
titulo.Text = "Painel de Teleporte"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 18

-- INICIO
local inicioBox = Instance.new("TextBox", frame)
inicioBox.Size = UDim2.new(0, 220, 0, 30)
inicioBox.Position = UDim2.new(0, 15, 0, 40)
inicioBox.PlaceholderText = "Número inicial (ex: 1)"
inicioBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inicioBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inicioBox.Font = Enum.Font.Gotham
inicioBox.TextSize = 14
Instance.new("UICorner", inicioBox).CornerRadius = UDim.new(0, 8)

-- FIM
local fimBox = Instance.new("TextBox", frame)
fimBox.Size = UDim2.new(0, 220, 0, 30)
fimBox.Position = UDim2.new(0, 15, 0, 80)
fimBox.PlaceholderText = "Número final (ex: 100)"
fimBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fimBox.TextColor3 = Color3.fromRGB(255, 255, 255)
fimBox.Font = Enum.Font.Gotham
fimBox.TextSize = 14
Instance.new("UICorner", fimBox).CornerRadius = UDim.new(0, 8)

-- INTERVALO
local intervaloBox = Instance.new("TextBox", frame)
intervaloBox.Size = UDim2.new(0, 220, 0, 30)
intervaloBox.Position = UDim2.new(0, 15, 0, 120)
intervaloBox.PlaceholderText = "Intervalo (segundos)"
intervaloBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
intervaloBox.TextColor3 = Color3.fromRGB(255, 255, 255)
intervaloBox.Font = Enum.Font.Gotham
intervaloBox.TextSize = 14
Instance.new("UICorner", intervaloBox).CornerRadius = UDim.new(0, 8)

-- BOTÃO
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 220, 0, 35)
button.Position = UDim2.new(0, 15, 0, 160)
button.Text = "Ativar Teleporte"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

-- FUNÇÃO PARA OBTER HRP ATUAL
local function getHRP()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart
    end
    return nil
end

-- FUNÇÃO TELEPORT
local function teleportar()
    while ativo do
        for i = inicio, fim do
            if not ativo then break end
            
            local hrp = getHRP()
            if not hrp then
                warn("HumanoidRootPart não encontrado. Aguardando personagem...")
                player.CharacterAdded:Wait()
                task.wait(1) -- Pequeno delay para garantir que o personagem está completamente carregado
                hrp = getHRP()
            end
            
            if hrp then
                local stages = workspace:FindFirstChild("Stages")
                if stages then
                    local part = stages:FindFirstChild(tostring(i))
                    if part and part:IsA("Model") and part.PrimaryPart then
                        hrp.CFrame = part.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                    elseif part and part:IsA("BasePart") then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    else
                        warn("Stage "..i.." não encontrado ou sem PrimaryPart")
                    end
                end
            end
            
            -- Espera o intervalo, mas verifica periodicamente se ainda está ativo
            local tempoEspera = 0
            while tempoEspera < intervalo and ativo do
                task.wait(0.1)
                tempoEspera = tempoEspera + 0.1
            end
        end
    end
    button.Text = "Ativar Teleporte"
end

-- BOTÃO CLICK
button.MouseButton1Click:Connect(function()
    if not ativo then
        inicio = tonumber(inicioBox.Text) or 1
        fim = tonumber(fimBox.Text) or 10
        intervalo = tonumber(intervaloBox.Text) or 5
        ativo = true
        button.Text = "Desativar Teleporte"
        task.spawn(teleportar)
    else
        ativo = false
        button.Text = "Ativar Teleporte"
    end
end)

-- Conectar evento de morte para pausar temporariamente
player.CharacterAdded:Connect(function()
    if ativo then
        warn("Personagem morreu. Teleporte pausado temporariamente.")
    end
end)
