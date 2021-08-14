local function recursiveLoad(path)
    local files, directories = file.Find(path .. "*", "LUA")

    for _, f in pairs(files) do
        if string.match(f, "^sv") then
            if SERVER then
                include(path .. f)
            end
        elseif string.match(f, "^sh") then
            AddCSLuaFile(path .. f)
            include(path .. f)
        elseif string.match(f, "^cl") then
            AddCSLuaFile(path .. f)
            if CLIENT then
                include(path .. f)
            end
        end
    end

    for _, d in pairs(directories) do
        recursiveLoad(path .. d .. "/")
    end
end

print("ok! ------------------")
recursiveLoad("simple_profiler/")