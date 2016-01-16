--Trying to pull the stupid name. Try N° 55. ¬¬
minetest.register_craftitem("testmod:clock",{
    
    description = "Clock to set time of day",
    inventory_image = "clock.png",
    on_use = function(_, user, _)
    local player = user:get_player_name()
    if player == "singleplayer" then
    minetest.set_timeofday(0.3)
    minetest.chat_send_player(player, player.." has set the time of day.")
    return
  end
end
    
  })

minetest.register_node("testmod:copperg", {
    description = "Copper generator node",
    tiles = {"tile_front.png"},
    is_ground_content = false,
    groups = {oddly_breakable_by_hand = 3},
    drop = {
      max_items = 5,
      items = {
        {
         items= {"default:copper_ingot 99", "default:steel_ingot 99", "default:mese_crystal 99", "default:diamond 99", "default:coal_lump 99"},
         rarity = 1
         },
      },
    },
  })

minetest.register_craft({
    
    output = "testmod:clock",
    recipe = {
      
      {"default:steel_ingot","default:mese_block","default:steel_ingot"},
      {"default:mese_block","default:diamondblock","default:mese_block"},
      {"default:steel_ingot","default:mese_block","default:steel_ingot"}
      
      }
    
  })


punchcount = 1
minetest.register_node("testmod:fivetimes",{
    description = "Dissapear after 5 punches",
    tiles = {"cookable.png"},
    diggable = true,
    groups = {cracky = 1, crumbly = 1},
    on_punch = function (pos, _, puncher, _)
      
      local player = puncher:get_player_name()
      if punchcount < 5 then
        minetest.chat_send_player(player, "The punch count is currently: "..punchcount)
        punchcount = punchcount + 1
      else
        
        minetest.remove_node(pos)
        minetest.chat_send_player(player, player.." has punched a node 5 times, and it has dissapeared.!")
        punchcount = 1
      end
    end
        
    })
  
minetest.register_chatcommand("moonwalk", {
  func = function(name, param)
    
    local player = minetest.get_player_by_name(name)
    
    player:set_physics_override({
        gravity = 0.4,
        jump = 2,
        speed = 2.5,
        })
    end
  })


minetest.register_on_dignode(function(pos, oldnode, digger)
    
  local player = digger:get_player_name()
  pos.y = pos.y +1
 
 
  --minetest.chat_send_player(player, "Digger is "..player)
  
  local tree_stack = 0
  if minetest.get_item_group(oldnode.name, "tree") ~= 0 and minetest.is_protected(pos, player) == false then
    
    
     
  
    
    while true do      
      
      local new_node = minetest.get_node(pos)
      if minetest.get_item_group(new_node.name, "tree") == 0 or new_node.name ~= oldnode.name then break end 
      
      minetest.chat_send_player(player, "Entered while loop")
      
      minetest.remove_node(pos)
      minetest.chat_send_player(player, "Node dug")
      pos.y = pos.y + 1
      
      tree_stack = tree_stack + 1
      minetest.chat_send_player(player, "Stack count rised")
      
      minetest.chat_send_player(player, "tree_stack is "..tree_stack)
     
      
    end
    local toAdd =ItemStack(oldnode.name)
    toAdd:set_count(tree_stack)
    local inv = minetest.get_inventory({type = "player", name=player})
    local leftover = inv:add_item("main", toAdd)
    if leftover:get_count() > 0 then
      minetest.chat_send_player(player, "Leftover is: "..leftover:get_count())
      minetest.add_item(pos, {name = oldnode.name, count = leftover:get_count()})
      return
      end
  else
    
        return
         
  end
 
  --minetest.add_item(pos, {name = oldnode.name, count = tree_stack})
end

  )