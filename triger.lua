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

-- Função para iniciar o voo
local function startFlying()
    if not flying then
        flying = true

        -- Criando o BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)  -- Força máxima
        bodyVelocity.Velocity = Vector3.new(0, liftForce, 0)  -- Força inicial para começar a voar
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")

        -- Atualiza a velocidade com base na entrada do jogador
        userInputService.InputChanged:Connect(function(input)
            if flying then
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouseDirection = input.Position - Vector2.new(game:GetService("Workspace").CurrentCamera.WorldToScreenPoint(character.HumanoidRootPart.Position).X, game:GetService("Workspace").CurrentCamera.WorldToScreenPoint(character.HumanoidRootPart.Position).Y)
                    bodyVelocity.Velocity = Vector3.new(mouseDirection.X, liftForce, mouseDirection.Y) * flightSpeed / 100
                end
            end
        end)
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
