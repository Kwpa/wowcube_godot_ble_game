extends Node

signal twist(screen:int,direction:int)
signal tap(count:int)
signal shake_tile_elements(tile : Array, direction : Vector3)
signal reveal_fragment(id:int)
signal fragment_collected(id:int)
signal cube_disconnected()
signal app_connected(msg:String)
signal cube_connected(msg:String)
signal send_msg_to_cube(msg:String)
