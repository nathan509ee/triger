-- Variáveis
local player = game.Players.LocalPlayer  -- Acessa o jogador
local character = player.Character or player.CharacterAdded:Wait()  -- Acessa o personagem
local humanoid = character:WaitForChild("Humanoid")  -- Acessa o Humanoid do personagem
local userInputService = game:GetService("UserInputService")  -- Para detectar a entrada do usuário

-- Definindo as propriedades de voo
local flying = false
local flightSpeed = 50  -- Velocidade do voo
local liftForce = 25  -- Força para subir
local bodyVelocity  -- Variável que armazenará a força de movimento
local moveDirection = Vector3.new(0, 0, 0)  -- Direção do movimento

-- Função para iniciar o voo
local function startFlying()
    if not flying then
        flying = true

        -- Criando o BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)  -- Força máxima
        bodyVelocity.Velocity = Vector3.new(0, liftForce, 0)  -- Força inicial para começar a voar
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
    end
end

-- Função para parar de voar
local function stopFlying()
    if flying then
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()  -- Remove o BodyVelocity
        end
    end
end

-- Função para atualizar o movimento
local function updateMovement()
    if flying then
        -- A direção do movimento é baseada nas teclas pressionadas
        local forward = 0
        local backward = 0

        -- Detecta as teclas pressionadas (W para frente, S para trás)
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            forward = 1
        elseif userInputService:IsKeyDown(Enum.KeyCode.S) then
            backward = -1
        end
        
        -- Definindo a direção do movimento no eixo Z (frente/trás)
        moveDirection = Vector3.new(0, liftForce, forward + backward) * flightSpeed / 10

        -- Atualiza a velocidade do BodyVelocity com a direção
        bodyVelocity.Velocity = moveDirection
    end
end

-- Detectando teclas pressionadas
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then  -- Quando pressionar a tecla de espaço, começar ou parar de voar
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end
end)

-- Atualiza o movimento enquanto voa
game:GetService("RunService").Heartbeat:Connect(function()
    updateMovement()
end)
