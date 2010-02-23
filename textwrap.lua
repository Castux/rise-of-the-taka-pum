require "evol"

local split = function(line)
	local words = {}
	for w in string.gmatch(line, "%S+") do
		table.insert(words, w)
	end
	
	words.orig = line
	
	return words
end


textwrap = function(font,str,rect,color,minspace,maxheight,dest)
	
	local words = split(str)
	local imgs = {}
	
	local rect = rect
	if not rect then
		if not dest then
			rect = {0,0,evol.width,evol.height}
		else
			rect = {0,0,dest.w,dest.h}
		end
	end
	
	local w,h = rect[3], rect[4]
	local x,y = rect[1], rect[2]
	
	-- Compute minspace
	local minspace_img = evol.write(font," ",0,0,color,'new')
	local minspace = minspace or minspace_img.w
	evol.free(minspace_img)
	
	local maxheight = maxheight or math.huge
	
	for i,v in ipairs(words) do
		table.insert(imgs,evol.write(font,v,0,0,color,'new'))
	end
	
	
	local index = 0
	local lines = {{}}
	local line = 1
	local sum = 0
	
	while index < #imgs do
	
		if sum + imgs[index+1].w <= w or #lines[line] == 0 then
			-- if there is enough room, or anyway if the line is empty,
			-- insert on the line
			
			table.insert(lines[line],imgs[index+1])
			sum = sum + imgs[index+1].w + minspace
			index = index + 1
			
		else
			-- put it in a new line instead
			line = line + 1
			lines[line] = {imgs[index+1]}	
			sum = imgs[index+1].w + minspace
			index = index + 1
			
		end
	end
	
	
	-- blit em all together
	dy = lines[1][1].h
	for i,line in ipairs(lines) do
		
		-- Compute space width
		local space = 0
		for j,word in ipairs(line) do
			space = space + word.w
		end
		
		space = (w - space) / (#line - 1)
		
		local dx = 0
		for j,word in ipairs(line) do
			word:blit(x + dx,y + dy,dest)
			dx = dx + word.w
			
			if j < #line then
				dx = dx + (i < #lines and space or minspace)
			end
		end
		
		if i < #lines then
			dy = dy + math.min(lines[i+1][1].h,maxheight)
		end
	end
	
	-- Clean up
	for i,v in ipairs(imgs) do evol.free(v) end
	
	return dest
end
