-- Serviços e variáveis
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Holding = false  -- Se o jogador está mantendo um botão pressionado (pode ser usado para ativar a mira)

-- Função para calcular a direção da mira
local function calcularDirecaoMira(playerPos, alvoPos)
    return (alvoPos - playerPos).unit  -- Retorna o vetor normalizado
end

-- Função para encontrar o inimigo mais próximo
local function encontrarAlvoMaisProximo()
    local alvoMaisProximo = nil
    local menorDistancia = math.huge

    for _, jogador in ipairs(Players:GetPlayers()) do
        if jogador ~= LocalPlayer and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
            local alvoPos = jogador.Character.HumanoidRootPart.Position
            local distancia = (Camera.CFrame.Position - alvoPos).magnitude

            if distancia < menorDistancia then
                menorDistancia = distancia
                alvoMaisProximo = jogador
            end
        end
    end

    return alvoMaisProximo
end

-- Função para ajustar a mira do jogador
local function ajustarMiraParaAlvo()
    local alvo = encontrarAlvoMaisProximo()
    if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local alvoPos = alvo.Character.HumanoidRootPart.Position
        local direcaoMira = calcularDirecaoMira(Camera.CFrame.Position, alvoPos)

        -- Ajuste a posição da câmera para apontar na direção do alvo (invisível ao jogador)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direcaoMira)
    end
end

-- Função para lidar com entrada do jogador (detecção de pressionamento de tecla, por exemplo)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then  -- Clique do botão direito do mouse
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then  -- Soltar o botão direito do mouse
        Holding = false
    end
end)

-- Atualização contínua da mira
RunService.RenderStepped:Connect(function()
    if Holding then
        ajustarMiraParaAlvo()  -- Ajusta a mira quando o jogador está mantendo o botão pressionado
    end
end)
