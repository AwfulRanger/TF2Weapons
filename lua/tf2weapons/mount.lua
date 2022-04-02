TF2Weapons.Mounted = TF2Weapons.Mounted or {
	
	Font = false,
	Crosshair = false,
	
}



if IsMounted( "tf" ) ~= true then return end



local function write64( f, n )
	
	f:WriteULong( n )
	f:WriteULong( 0 )
	
end

local gmameta = {
	
	AddFile = function( self, src, dst, path )
		
		local f = file.Open( src, "rb", path or "tf" )
		if f == nil then return end
		
		local size = f:Size()
		local data = f:Read( size )
		
		f:Close()
		
		table.insert( self.files, { path = dst, data = data, size = size } )
		
	end,
	
	AddData = function( self, data, dst )
		
		table.insert( self.files, { path = dst, data = data, size = string.len( data ) } )
		
	end,
	
	Write = function( self )
		
		file.CreateDir( string.GetPathFromFilename( self.path ) )
		
		local f = file.Open( self.path, "wb", "DATA" )
		if f == nil then return end
		
		-- header
		f:Write( "GMAD" ) -- ident
		f:WriteByte( 3 ) -- version
		-- steam id
		f:WriteULong( 0 )
		f:WriteULong( 0 )
		-- timestamp
		write64( f, os.time() )
		-- required content
		f:WriteByte( 0 )
		-- name
		f:Write( self.name or "name" )
		f:WriteByte( 0 )
		-- description
		f:Write( self.desc or "description" )
		f:WriteByte( 0 )
		-- author
		f:Write( "author" )
		f:WriteByte( 0 )
		-- version
		f:WriteULong( 1 )
		
		for i = 1, #self.files do
			
			-- file number
			f:WriteULong( i )
			-- file name
			f:Write( self.files[ i ].path )
			f:WriteByte( 0 )
			-- file size
			write64( f, self.files[ i ].size )
			-- crc
			f:WriteULong( 0 )
			
		end
		
		-- end of files
		f:WriteULong( 0 )
		
		for i = 1, #self.files do
			
			-- file data
			f:Write( self.files[ i ].data )
			
		end
		
		-- crc
		f:WriteULong( 0 )
		
		f:Close()
		
	end,
	
	Mount = function( self )
		
		return game.MountGMA( "data/" .. self.path )
		
	end,
	
}
gmameta.__index = gmameta

local function creategma( name, desc )
	
	local tbl = {
		
		name = name,
		desc = desc,
		path = "tf2weapons/content/" .. name .. ".dat",
		files = {},
		
	}
	
	return setmetatable( tbl, gmameta )
	
end



if TF2Weapons.Mounted.Font ~= true then
	
	local fontgma = creategma( "tf2weapons_font", "TF2Weapons fonts" )
	fontgma:AddFile( "resource/tf2build.ttf", "resource/fonts/tf2weapons_tf2build.ttf" )
	fontgma:AddFile( "resource/tf2secondary.ttf", "resource/fonts/tf2weapons_tf2secondary.ttf" )
	fontgma:Write()
	
	TF2Weapons.Mounted.Font = fontgma:Mount()
	
end



if TF2Weapons.Mounted.Crosshair ~= true then
	
	local crosshairgma = creategma( "tf2weapons_crosshair", "TF2Weapons crosshair" )
	--crosshairgma:AddFile( "materials/sprites/crosshairs.vmt", "materials/tf2weapons/crosshairs.vmt" )
	
	local vmt = file.Read( "materials/sprites/crosshairs.vmt", "tf" )
	if vmt ~= nil then
		
		vmt = string.gsub( vmt, "\"sprites/crosshairs\"", "\"tf2weapons/crosshairs\"", 1 )
		crosshairgma:AddData( vmt, "materials/tf2weapons/crosshairs.vmt" )
		
	end
	
	crosshairgma:AddFile( "materials/sprites/crosshairs.vtf", "materials/tf2weapons/crosshairs.vtf" )
	crosshairgma:Write()
	
	TF2Weapons.Mounted.Crosshair = crosshairgma:Mount()
	
end
