local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

-- Função para verificar se o jogador está mirando em outro jogador
local function checkAim()
    -- Realiza um raycast a partir da posição da câmera para onde ela está mirando
    local mousePos = UserInputService:GetMouseLocation()
    local screenCenter = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local ray = Ray.new(screenCenter.Origin, screenCenter.Direction * 1000) -- Ajuste o alcance aqui se necessário

    local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character) -- Impede que o próprio jogador seja atingido

    -- Se a raycast acertar algo (e não for o próprio jogador), verifica se é outro jogador
    if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
        local targetPlayer = Players:GetPlayerFromCharacter(hit.Parent)
        if targetPlayer and targetPlayer ~= LocalPlayer then
            -- Aqui você pode simular o disparo ou realizar alguma ação
            print("Mira em: " .. targetPlayer.Name)
            return true
        end
    end
    return false
end

-- Função que aciona o disparo
local function triggerFire()
    if checkAim() then
        -- Lógica para disparo (substitua com ação real de disparo, se aplicável)
        print("Disparando no alvo!")
    end
end

-- Detecta se o jogador segura uma tecla (exemplo: botão de disparo)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Botão esquerdo do mouse
            Holding = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Botão esquerdo do mouse
        Holding = false
    end
end)

-- Dispara automaticamente enquanto a tecla estiver pressionada
RunService.Heartbeat:Connect(function()
    if Holding then
        triggerFire()
    end
end)
