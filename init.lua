local ispendown = 1

minetest.register_chatcommand("fd", {
	func = function(name, meter)
		fd(tonumber(meter))
	end
})

minetest.register_chatcommand("bk", {
	func = function(name, meter)
		bk(tonumber(meter))
	end
})

minetest.register_chatcommand("rt", {
	func = function (name, deg)
		turn(tonumber(deg))
	end
})

minetest.register_chatcommand("lt", {
	func = function (name, deg)
		turn(-tonumber(deg))
	end
})

minetest.register_chatcommand("seth", {
	func = function (name, deg)
		seth(tonumber(deg))
	end
})

minetest.register_chatcommand("pu", {
	func = function (name)
		pu()
	end
})

minetest.register_chatcommand("pd", {
	func = function (name)
		pd()
	end
})

minetest.register_chatcommand("cs", {
	func = function (name)
		cs()
	end
})

minetest.register_chatcommand("repeat", {
	func = function (name, params)
		local fields = {}
		for i in string.gmatch(params, '%S+') do
			table.insert(fields, i)
		end
		dorepeat(tonumber(fields[1]), fields)
	end
})

function cs()
	local player = minetest.get_player_by_name("singleplayer")
	local pos = player:getpos()
	minetest.delete_area({x=pos.x-100, y=pos.y, z=pos.z-100}, {x=pos.x+100, y=pos.y, z=pos.z+100})
end

function pu()
	ispendown = 0
end

function pd()
	ispendown = 1
end

function seth(deg)
	local player = minetest.get_player_by_name("singleplayer")
	player:set_look_yaw(-deg / 180 * math.pi)
end

function turn(deg)
	local player = minetest.get_player_by_name("singleplayer")
	local yaw = player:get_look_yaw()
	local rad = deg / 180 * math.pi
	yaw = yaw - rad - math.pi / 2
	player:set_look_yaw(yaw)
end

function rt(deg)
	turn(deg)
end

function lt(deg)
	turn(-deg)
end

function draw(meter)
	local sign = 1
	if meter == -math.abs(meter) then
		meter = -meter
		sign = -1
	end
	local player = minetest.get_player_by_name("singleplayer")
	local pos = player:getpos()
	local yaw = player:get_look_yaw()
	local x = pos.x
	local z = pos.z
	if (ispendown > 0 and player:get_wielded_item()) then
		minetest.set_node(pos, {name=player:get_wielded_item():get_name()})
	end
	while meter > 0 do
		meter = meter - 1
		x = x + sign * math.cos(yaw)
		z = z + sign * math.sin(yaw)
		player:setpos({x=x, y=pos.y, z=z})
		if ispendown > 0 and player:get_wielded_item() then
			minetest.set_node({x=x, y=pos.y, z=z}, {name=player:get_wielded_item():get_name()})
		end
	end
end

function fd(meter)
	draw(meter)
end

function bk(meter)
	draw(-meter)
end

function dorepeat(n, commands)
  local len = #commands

	print(len, commands[2], commands[len])

	if (commands[2] ~= '[' or commands[len] ~= ']') then
		return
	end

	while n > 0 do
		n = n - 1
		for i = 3, len - 1, 2 do
			c = commands[i]
			cn = tonumber(commands[i+1])
			print(c, cn)
			if c == 'rt' then
				rt(cn)
			elseif c == 'lt' then
				lt(cn)
			elseif c == 'fd' then
				fd(cn)
			elseif c == 'bk' then
				bk(cn)
			end
		end
	end
end
