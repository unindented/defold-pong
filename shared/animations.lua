local M = {}

local function chain_animations(target ,values, initializer, updater, callback)
  callback = callback or function () end

  for i = #values - 3, 2, -4 do
    local to = values[i]
    local easing = values[i + 1]
    local duration = values[i + 2]
    local delay = values[i + 3]
    local current_callback = callback

    callback = function ()
      updater(target, to, easing, duration, delay, current_callback)
    end
  end

  initializer(target, values[1])
  callback(nil, target)
end

-- Animate alpha (GUI).

local function gui_animate_alpha_initializer(target, to)
  local from_color = gui.get_color(target)
  from_color.w = to
  gui.set_color(target, from_color)
end

local function gui_animate_alpha_updater(target, to_alpha, easing, duration, delay, cb)
  local to_color = gui.get_color(target)
  to_color.w = to_alpha
  gui.animate(target, gui.PROP_COLOR, to_color, easing, duration, delay, cb)
end

local function gui_animate_alpha(target, values, callback)
  return chain_animations(target, values,
    gui_animate_alpha_initializer, gui_animate_alpha_updater, callback)
end

-- Animate scale (GUI).

local function gui_animate_scale_initializer(target, to)
  local from_scale = vmath.vector4(to, to, to, 0)
  gui.set_scale(target, from_scale)
end

local function gui_animate_scale_updater(target, to_pct, easing, duration, delay, cb)
  local to_scale = vmath.vector4(to_pct, to_pct, to_pct, 0)
  gui.animate(target, gui.PROP_SCALE, to_scale, easing, duration, delay, cb)
end

local function gui_animate_scale(target, values, callback)
  return chain_animations(target, values,
    gui_animate_scale_initializer, gui_animate_scale_updater, callback)
end

-- Exports (GUI).

function M.gui_fade_in(target, delay, callback)
  gui_animate_alpha(target, {
    0,
    1, gui.EASING_IN, 0.17, delay
  }, callback)
end

function M.gui_bounce_in(target, delay, callback)
  M.gui_fade_in(target, delay)

  gui_animate_scale(target, {
    0.75,
    1.09, gui.EASING_IN, 0.17, delay,
    0.96, gui.EASING_INOUT, 0.17, 0,
    1.02, gui.EASING_INOUT, 0.16, 0,
    1, gui.EASING_INOUT, 0.16, 0
  }, callback)
end

function M.gui_fade_out(target, delay, callback)
  gui_animate_alpha(target, {
    1,
    0, gui.EASING_IN, 0.17, delay
  }, callback)
end

function M.gui_bounce_out(target, delay, callback)
  M.gui_fade_out(target, delay)

  gui_animate_scale(target, {
    1,
    0.75, gui.EASING_INOUT, 0.17, delay
  }, callback)
end

return M
