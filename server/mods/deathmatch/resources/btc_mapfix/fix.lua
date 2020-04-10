--Scriptet írta: Csoki
--INFO: Nem törnek a megadott objectek.
--[[

local objektek = { 
[1215] = true, -- Világító kis geci
[1432] = true, -- Asztal vagy mi a geci
}

function sanmta()
	local element = getElementsByType ("object")
	for k,v in ipairs(element) do
		local model = getElementModel (v)
		if objektek[model] then
			setObjectBreakable (v,false)
			setElementFrozen (v,true)
		end
	end
end
addEventHandler ("onClientResourceStart",getResourceRootElement(getThisResource()), sanmta)

]]--

