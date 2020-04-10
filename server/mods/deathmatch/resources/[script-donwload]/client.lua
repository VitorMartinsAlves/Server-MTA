local h 		= 30;
local rot		= 80;
local exists 	= {};

local dxfont0_font = dxCreateFont("files/font/font.ttf", 10)
local dxfont1_font = dxCreateFont("files/font/font.ttf", 14)

local screenW, screenH = guiGetScreenSize()
local x, y = (screenW/1360), (screenH/768)

local mods;

function vazernRectangle(posX, posY, width, height, color, postGUI)
	dxDrawRectangle(x*posX, y*posY, x*width, y*height, color, postGUI)
end

function vazernText(text, posX, posY, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning)
	dxDrawText(text, x*posX, y*posY, x*width, y*height, color, x*scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning)
end


local function downloadMods()
	for i, v in ipairs (mods) do 
		local file = v.file;
		downloadFile (file);
	end
end	

function table.find (tbl, index, value)
	for i, v in pairs (tbl) do 
		if v[index] == value then 
			return i;
		end
	end
	return false;
end	

addEvent ("loader.request", true);
addEventHandler ("loader.request", root,
	function (tbl)
		if tbl then 
			mods = tbl;
			downloadMods();
		end
	end
);

addEventHandler ("onClientResourceStart", resourceRoot, 
	function ()
		triggerServerEvent ("loader.onload", localPlayer);
		addEventHandler ("onClientRender", root, drawLoader);
	end
);

addEventHandler ("onClientFileDownloadComplete", root,
	function (name, success)
		if ( source == resourceRoot ) then
			if success then
				local index = table.find (mods, "file", name);
				if index then 
					exists[name] = true;
					-- downloadFile (name);
					local model = mods[index].model;
					if name:find (".dff") then
						local dff = engineLoadDFF (name)
						engineReplaceModel (dff, model);
					elseif name:find (".txd") then 
						local txd = engineLoadTXD (name);
						engineImportTXD(txd, model);
					elseif name:find (".col") then 
						local col = engineLoadCOL (name);
						engineReplaceCOL (col, model);
					end	
					tick = getTickCount()+2000;
				end	
			end
		end
	end
);	

function drawLoader ()
	if not mods then return; end
	if next (mods) then
		rot = rot + 1;
		local count = 0;
		for _ in pairs (exists) do 
			count = count + 1;
		end
		if count == #mods then 
			if getTickCount() > tick then 
				removeEventHandler ("onClientRender", root, drawLoader);
				return;
			end	
		end

		local count2 = math.ceil((count/#mods)*100)

		exports["fx_blur"]:dxDrawBluredRectangle(x*882, y*648, x*468, y*86, tocolor(255, 255, 255, 255))
		vazernRectangle(882, 648, 468, 86, tocolor(0, 0, 0, 185), false)
        vazernText("Fazendo download de #106FE7veículos#ffffff, #106FE7skins#ffffff, #106FE7armas #ffffffe #106FE7texturas do mapa#ffffff.", 892, 650, 1042, 668, tocolor(254, 254, 254, 188), 1, dxfont0_font, "left", "top", false, false, false, true, false)
        vazernText("Os mods irão aparecendo de acordo com o progresso de download.", 892, 668, 1042, 686, tocolor(254, 254, 254, 188), 1, dxfont0_font, "left", "top", false, false, false, true, false)
        vazernRectangle(882, 728, 468/100*count2, 6, tocolor(16, 111, 231), false)      
        vazernText(math.ceil((count/#mods)*100).."%", 1084, 692, 1234, 710, tocolor(254, 254, 254, 188), 1, dxfont1_font, "left", "top", false, false, false, false, false)
	end	
end