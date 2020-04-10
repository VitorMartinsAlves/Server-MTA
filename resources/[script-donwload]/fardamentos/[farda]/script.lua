-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'lvpd1.txd' ) 
engineImportTXD( txd, 15 ) 
dff = engineLoadDFF('lvpd1.dff', 15) 
engineReplaceModel( dff, 15 )
end)
