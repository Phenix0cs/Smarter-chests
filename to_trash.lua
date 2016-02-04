--[[ Smarter chests mod for factorio
The MIT License (MIT)
Copyright (c) 2016, Phenix0cs
]]

local gui_shown = false
local send_to_trash = false

function has_value(tab, val)
   for index, value in ipairs (tab) do
      if value == val then
         return true
      end
   end
   return false
end

function add_gui(player)
   -- Add UI to send extra items to trash slots
   if not has_value(player.gui.top.children_names,"smart-gui") then
	   player.gui.top.add{type = "checkbox", name = "smart-gui", 
	      caption = "Send to trash slots extra items from requests", 
	      state = send_to_trash}
	end
   gui_shown = true
end

function update_gui(player)
   if gui_shown then
		send_to_trash = player.gui.top["smart-gui"].state
	else
	   add_gui(player)
	end
end

function to_trash(player)
   if send_to_trash then
      local player_trash = player.get_inventory(defines.
         inventory.player_trash)
      
      local requested_item = nil
      local nb_logistic_slots = player.force.character_logistic_slot_count
      
      local qty_in_inventory = 0
      local qty_to_move = 0
      local qty_moved = 0
      
      for slot=1,nb_logistic_slots do
         requested_item = player.character.get_request_slot(slot)
         if requested_item ~= nil then
            qty_in_inventory = player.get_item_count(requested_item.name)
            qty_to_move = qty_in_inventory - requested_item.count
            if qty_to_move > 0 then
               qty_moved = player_trash.insert({
                  ["name"] = requested_item.name, ["count"] = qty_to_move})
               if qty_moved > 0 then
                  player.remove_item({
                     ["name"] = requested_item.name, ["count"] = qty_moved})
               end
            end
         end
      end
   end
end

