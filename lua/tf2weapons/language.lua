local gmlang = string.lower( GetConVar( "gmod_language" ):GetString() )

local defaultlang = "resource/tf_english.txt"
local langfiles = {
	
	[ "pt-br" ] = "resource/tf_brazilian.txt",
	[ "bg" ] = "resource/tf_bulgarian.txt",
	[ "cs" ] = "resource/tf_czech.txt",
	[ "da" ] = "resource/tf_danish.txt",
	[ "nl" ] = "resource/tf_dutch.txt",
	[ "en" ] = "resource/tf_english.txt",
	[ "fi" ] = "resource/tf_finnish.txt",
	[ "fr" ] = "resource/tf_french.txt",
	[ "de" ] = "resource/tf_german.txt",
	[ "el" ] = "resource/tf_greek.txt",
	[ "hu" ] = "resource/tf_hungarian.txt",
	[ "it" ] = "resource/tf_italian.txt",
	[ "ja" ] = "resource/tf_japanese.txt",
	[ "ko" ] = "resource/tf_korean.txt",
	[ "no" ] = "resource/tf_norwegian.txt",
	[ "po" ] = "resource/tf_polish.txt",
	[ "pt-pt" ] = "resource/tf_portuguese.txt",
	[ "ru" ] = "resource/tf_russian.txt",
	[ "es-es" ] = "resource/tf_spanish.txt",
	[ "sv-se" ] = "resource/tf_swedish.txt",
	[ "zh-cn" ] = "resource/tf_tchinese.txt",
	[ "th" ] = "resource/tf_thai.txt",
	[ "tr" ] = "resource/tf_turkish.txt",
	[ "uk" ] = "resource/tf_ukrainian.txt",
	
}

local langf = langfiles[ gmlang ] or defaultlang

local f = file.Open( langf, "r", "tf" )
if f ~= nil then
	
	local skip = 2
	f:Skip( skip )
	local lang = f:Read( f:Size() - skip )
	f:Close()
	
	--why are language files in ucs-2 aaaaaaaaaa
	lang = string.Replace( lang, string.char( 0 ), "" )
	
	local explode = string.Explode( "\n", lang )
	local tokens = false
	for i = 1, #explode do
		
		if tokens ~= true then
			
			if string.match( string.lower( explode[ i ] ), "\"tokens\"" ) ~= nil then tokens = true end
			
		else
			
			local key, value = string.match( explode[ i ], "\"(.-)\".-\"(.-)\"" )
			if key ~= nil and value ~= nil then
				
				language.Add( key, value )
				
			end
			
		end
		
	end
	
end