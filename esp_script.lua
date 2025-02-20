local function Updater()
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
            local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

            -- Проверка на максимальную дистанцию
            local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance > Settings.Max_Distance then
                Visibility(false, library)
                return
            end

            if OnScreen then
                local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)

                local function Size(item)
                    item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                    item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                    item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                    item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                end
                Size(library.box)
                Size(library.black)

                --// Трассер
                if Settings.Tracers then
                    if Settings.Tracer_Origin == "Middle" then
                        library.tracer.From = camera.ViewportSize*0.5
                        library.blacktracer.From = camera.ViewportSize*0.5
                    elseif Settings.Tracer_Origin == "Bottom" then
                        library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y) 
                        library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                    end
                    if Settings.Tracer_FollowMouse then
                        library.tracer.From = Vector2.new(mouse.X, mouse.Y+36)
                        library.blacktracer.From = Vector2.new(mouse.X, mouse.Y+36)
                    end
                    library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                else 
                    library.tracer.From = Vector2.new(0, 0)
                    library.blacktracer.From = Vector2.new(0, 0)
                    library.tracer.To = Vector2.new(0, 0)
                    library.blacktracer.To = Vector2.new(0, 02)
                end

                -- Проверка на команду
                if Team_Check.TeamCheck then
                    if plr.TeamColor == player.TeamColor then
                        Colorize(Team_Check.Green)
                    else 
                        Colorize(Team_Check.Red)
                    end
                else 
                    library.tracer.Color = Settings.Tracer_Color
                    library.box.Color = Settings.Box_Color
                end
                if TeamColor == true then
                    Colorize(plr.TeamColor.Color)
                end
                Visibility(true, library)
            else 
                Visibility(false, library)
            end
        else 
            Visibility(false, library)
            if game.Players:FindFirstChild(plr.Name) == nil then
                connection:Disconnect()
            end
        end
    end)
end
