-- injector: @rlua
-- init and so much more: @xyzkade or @kadetheexploiter on github

local funcs = {}
local genv = nil

funcs.validateglobal = function(env)
    if env then
      genv = env
      print('ez')
    else
      print('fail')
    end
end

return funcs
