-- Generated automaticly by RB Generator.
fx_version('cerulean')
lua54    'yes'
game 'gta5' 

author 'SQC_Max'
description 'Washing script to clean black money'
version '1.2'

shared_script(
'@ox_lib/init.lua',    
'config.lua');

server_scripts{
'config.lua',
'server/sv.lua'
}

client_scripts{
'config.lua',
'client/cl.lua'
}
