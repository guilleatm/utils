function tableToString (t, separator, brackets)

	separator = separator or ' '	
	local tableOfStrings = {"{"}

	for k, e in pairs(t) do

		local kType = type(k)
		if kType == 'string' then
			table.insert(tableOfStrings, string.format("%s=", k))
		elseif kType == 'table' then
			table.insert(tableOfStrings, string.format("table:%s=", k))
		elseif kType == 'function' then
			table.insert(tableOfStrings, tostring(k))
		end

		local eType = type(e)
		if eType == 'table' then
			if next(e) == nil then
				table.insert(tableOfStrings, "{}")
			else
				table.insert(tableOfStrings, tableToString(e, separator, true))
			end
		elseif eType == 'number' or eType == 'boolean' then
			table.insert(tableOfStrings, tostring(e))
		else 
			table.insert(tableOfStrings, string.format("\"%s\"", tostring(e)))
		end

		table.insert(tableOfStrings, separator)
	end

	table.remove(tableOfStrings, #tableOfStrings)
	table.insert(tableOfStrings, '}')
	if not brackets then
		table.remove(tableOfStrings, 1)
		table.remove(tableOfStrings, #tableOfStrings)
	end
	local result = table.concat(tableOfStrings)
	return result
end

function stringToTable(s, separator) -- les go

	separator = separator or ' '
	local result = {}

	local e = ""
	local key = nil
	local inString, inTable = false, 0

	for i = 1, #s do
		local c = s:sub(i, i)
		if c == "'" then c = '"' end



		if inTable > 0 then -- In table
			if c == '{' then
				inTable = inTable + 1
			elseif c == '}' then
				inTable = inTable - 1
			
				if inTable == 0 then
					if key then
						result[key] = stringToTable(e, separator)
						key = nil
					else--if e ~= "" then
						table.insert(result, stringToTable(e, separator))
					end
					e = ""
				end
			end
			
			if inTable > 0 then
				e = e .. c
			end
		
		elseif inString then -- In string
			if c == '"' then
				inString = false				
			else
				e = e .. c
			end

		else -- Not in string and not in table

			if c == '"' then
				inString = true
			elseif c == '{' then
				inTable = 1
			elseif c == '=' then
				key = e
				e = ""
			elseif c == separator then
				if key then
					result[key] = tonumber(e) or e
					key = nil
				elseif e ~= "" then -- Després de insertar una tabla, e = "" i ni ha un separator
					table.insert(result, tonumber(e) or e)
				end
				e = ""
			else
				e = e .. c
			end
		end
	end

	if #e > 0 then
		table.insert(result, tonumber(e) or e)
	end

	return result
end

function binarySearch(element, v, iStart, iEnd) -- Binary search --> O(logN). Returns the index of the element.

	iStart = iStart or 1
	iEnd = iEnd or #v
	local middle = math.floor((iStart + iEnd) / 2)

	local middleValue = v[middle]

	if middleValue == element then
		return middle
		
	elseif iStart == iEnd then
		return nil

	elseif middleValue < element then
		iStart = middle + 1
	else
		iEnd = middle - 1
	end
	return binarySearch(element, v, iStart, iEnd)
end

-- if toInert, if the element already exist, the new element will be inserted first (of all repeated elements)
function binarySearchAmplified(element, v, toInsert, whereToLook, iStart, iEnd)

	if #v == 0 then
		if toInsert then
			return 1
		else
			return nil
		end
	end

	iStart = iStart or 1
	iEnd = iEnd or #v
	local middle = math.floor((iStart + iEnd) / 2)

	--local getValue -- getValue is not local, this way, it does not have to be loaded and stored in each call (remember that this is recursive)
	-- if you do getValue local, then you can remove the v and whereToLook arguments from the function and from the calls.
	if not getValue then
		getValue = function (i, v, whereToLook)
			if i == 0 or i > #v then return nil end -- If you need more performance, you can put this line in #P1
			local middleValue = v[i]
			if whereToLook then
				-- #P1
				for i, key in ipairs(whereToLook) do
					middleValue = middleValue[key]
				end
			end
			return middleValue
		end
	end

	local middleValue = getValue(middle, v, whereToLook)

	if middleValue == element then
		if toInsert then
			for i = middle, 1, -1 do
				if getValue(i - 1, v, whereToLook) ~= middleValue then -- Supports nil (v[0])
					return i
				end
			end
		end

		local first, last = middle, middle
		while last <= #v do -- Looking right
			if getValue(last + 1, v, whereToLook) ~= element then -- Supports nil (v[#v + 1])
				break
			end
			last = last + 1
		end

		while first > 0  do -- Looking left
			if getValue(first - 1, v, whereToLook) ~= element then -- Supports nil (v[0])
				break
			end
			first = first - 1
		end
		
		return first, last
		
	elseif iStart == iEnd then
		if toInsert then
			if element > middleValue then
				return middle + 1
			else
				return middle
			end
		end
		return nil
	elseif iStart > iEnd then
		if toInsert then
			return iStart
		else
			return nil
		end

	elseif middleValue < element then
		iStart = middle + 1
	else
		iEnd = middle - 1
	end
	return binarySearchAmplified(element, v, toInsert, whereToLook, iStart, iEnd)
end

function toPath(path)
	assert(path, "ERROR: toPath(path), Invalid path")
	if string.sub(path, #path) ~= '/' then
		path = path .. '/'
	end
	return path
end

function isIn(a, b, x, y, radius) -- Checks if the point (a, b) is inside a circle of center x, y and radius radius
	if math.sqrt(math.pow(a - x, 2) + math.pow(b - y, 2)) < radius then
		return true
	end
	return false
end
