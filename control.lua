--[[ Smarter chests mod for factorio
The MIT License (MIT)
Copyright (c) 2016, Phenix0cs

Mention to SmartTrains mod by Choumiko for inspiration.
]]

require "defines"
require "math"
require "util"

local chest_open = false
local open_entity = nil
local chest = nil
local mining_chest = false

function init()
   global.storage_links = global.storage_links or {}
end

function position(entity)
   if entity.valid then
      return entity.position.x..":"..entity.position.y
   else
      return ""
   end
end

function cleanup_links()
   for pos,link in pairs(global.storage_links) do
      if not global.storage_links[pos].requester.valid then
         link.storage.destroy()
         global.storage_links[pos] = nil
      end
   end
end
 
function built(event)
   if event.created_entity.name == "logistic-chest-storage2-ui" then
      local storage_ui = event.created_entity
      local storage = storage_ui.surface.create_entity
      {name = "logistic-chest-storage2", 
      position = storage_ui.position,
      force = storage_ui.force}
      
      storage.teleport(storage_ui.position) -- TODO Remove if bug is corrected
      
      global.storage_links[position(storage_ui)] =
         {requester = storage_ui, storage = storage, requester_slots = {}}
   end
end

function pre_mined(event)
   if event.entity.name == "logistic-chest-storage2-ui" then
      local position = position(event.entity)
      mining_chest = true
      
      -- Recover items and requester slots
      copy_all_from_storage(event.entity)
   end
end

function canceled_deconstruction(event)
   if event.entity.name == "logistic-chest-storage2-ui" then
      local position = position(event.entity)
            
      copy_all_to_storage(event.entity)
      mining_chest = false
   end
end

function mined_item(event)
   if event.item_stack.name == "logistic-chest-storage2-ui" then
      cleanup_links()
      mining_chest = false
   end
end

function entity_died(event)
   if event.entity.name == "logistic-chest-storage2-ui" then
      local pos = position(event.entity)
      local link = global.storage_links[position(event.entity)]
      
      -- Recover requester slots
      for slot = 1,8 do -- TODO Change if number of slots can be retrived
         request = link.requester_slots[slot]
         if request ~= nil then
            event.entity.set_request_slot(request,slot)
         end
      end
      
      link.storage.destroy()
      global.storage_links[position(event.entity)] = nil
      cleanup_links()
   end
end

function get_content_to_insert(tabl)
   local new_table = {}
   for k,v in pairs(tabl) do
     table.insert(new_table, {["name"] = k, ["count"] = v})
   end
   return new_table
end

function copy_all_from_storage(requester)
   if requester.valid then
      local storage = global.storage_links[position(requester)].storage
      local request = nil
      
      if storage.valid then
         local storage_items = storage.get_inventory(defines.inventory.chest).get_contents()
         storage_items = get_content_to_insert(storage_items)
      
         for _,item in pairs(storage_items) do
            nb_tranfered = requester.insert(item)
            if nb_tranfered > 0 then
               item.count = nb_tranfered
               storage.remove_item(item)
            end
         end
         
         -- Recover requester slots saved
         for slot = 1,8 do -- TODO Change if number of slots can be retrived
            request = global.storage_links[position(requester)].requester_slots[slot]
            if request ~= nil then
               requester.set_request_slot(request,slot)
            end
         end
      end
   end
end

function copy_from_storage_items_requested(requester)
   if requester.valid then
      local storage = global.storage_links[position(requester)].storage
      local request = nil
      local transfert = {name="", count=0}
      local nb_transfered = 0
      
      for slot = 1,8 do -- TODO Change if number of slots can be retrived
         request = global.storage_links[position(requester)].requester_slots[slot]
         if request ~= nil then
            nb_available = storage.get_item_count(request.name)
            if nb_available > 0 then
               transfert.name = request.name
               transfert.count = math.min(nb_available,request.count)
               nb_transfered = requester.insert(request)
               transfert.count = nb_transfered
               storage.remove_item(transfert)
            end
            -- Recover requester slot
            requester.set_request_slot(request,slot)
         end
      end
   end
end

function copy_all_to_storage(requester)
   if requester.valid then
      local req_items = requester.get_inventory(defines.inventory.chest).get_contents()
      local remaining = 0
      
      req_items = get_content_to_insert(req_items)
   
      for _,item in pairs(req_items) do
         nb_tranfered = global.storage_links[
         position(requester)].storage.insert(item)
         if nb_tranfered > 0 then
            item.count = nb_tranfered
            requester.remove_item(item)
         end
          
      end
      -- Save requester slots before disabling them
      for slot = 1,8 do -- TODO Change if number of slots can be retrived
         global.storage_links[position(requester)].
            requester_slots[slot] = requester.get_request_slot(slot)
         requester.clear_request_slot(slot)
      end  
   end
end

function request_for_all_storages()
   for _,link in pairs(global.storage_links) do
      copy_from_storage_items_requested(link.requester)
   end
end

function end_request_for_all_storages()
   for _,link in pairs(global.storage_links) do
      copy_all_to_storage(link.requester)
   end
end

local sending_requests = false

function tick(event)
   open_entity = game.player.opened
   if open_entity ~= nil and
      open_entity.name == "logistic-chest-storage2-ui" and
   not chest_open then
      chest_open = true
      request_for_all_storages()
      copy_all_from_storage(open_entity)
      chest = open_entity
   elseif open_entity == nil and chest_open then
      end_request_for_all_storages()
      chest_open = false
   elseif game.tick % 100 == 1 and not chest_open and 
   not sending_requests and not mining_chest then
      request_for_all_storages()
      sending_requests = true
   elseif game.tick % 100 == 2 and not chest_open and 
   sending_requests and not mining_chest then
      end_request_for_all_storages()
      sending_requests = false
   end
end

script.on_init(init)
script.on_load(init)
script.on_event({defines.events.on_built_entity, 
   defines.events.on_robot_built_entity}, built)
script.on_event(defines.events.on_tick, tick)
script.on_event({defines.events.on_preplayer_mined_item,
   defines.events.on_robot_pre_mined}, pre_mined)
script.on_event({defines.events.on_canceled_deconstruction},
   canceled_deconstruction)
script.on_event({defines.events.on_player_mined_item,
   defines.events.on_robot_mined}, mined_item)
script.on_event({defines.events.on_entity_died},entity_died)

