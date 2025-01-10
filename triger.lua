-- Obtém o jogador
local player = game.Players.LocalPlayer

-- Obtém o personagem do jogador
local character = player.Character or player.CharacterAdded:Wait()

-- Espera até o humanoide estar presente
local humanoide = character:WaitForChild("Humanoid")

-- Defina a velocidade desejada (por exemplo, 100)
local velocidadeDesejada = 100

-- Aumenta a velocidade do personagem
humanoide.WalkSpeed = velocidadeDesejada

-- (Opcional) Atualiza a velocidade se o personagem morrer e renascer
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoide = character:WaitForChild("Humanoid")
    humanoide.WalkSpeed = velocidadeDesejada
end)
