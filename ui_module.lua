function onLoad()
GUID = self.getGUID()
end

function generateAttackUI(params) -- Generates the UI for the two players involved (Can be reworked for multiple players... not really worried about it now.)
  color1 = params["color1"]
  color2 = params["color2"]
  actor1 = params["actor1"]
  actor2 = params["actor2"]

  local function generate_sideUI(color)
    local sideUI = '<image id="fight_'..color..'" rectAlignment="LowerRight" height="300" width="175" image="fight" preserveAspect="true" offsetxy="25 150" onclick="'.. GUID ..'/hide_attacks" onMouseEnter="'.. GUID ..'/mouseOver" onMouseExit="'.. GUID ..'/mouseOut" visibility="'.. color ..'"></image>'
    return sideUI
  end

  local function generate_attacks(actor, color)
    local master = ""
    for k, v in pairs(database[actor]["attacks"]) do -- Different variables for readability
      local actor_attacks = '<panel id ="'.. color ..'"><image image="'.. database[actor]["attacks"][k]["type"] ..'"></image>'
      local actor_text = '<text color="white" fontSize="20" alignment="upperleft" fontStyle="bold" offsetxy="30 -30">'.. k ..'</text>'
      local grid_start = '<GridLayout height="50" childAlignment="MiddleRight" constraintCount="5" cellsize="32 32" offsetXy="-20 4" rectAlignment="LowerRight">'

      master = master .. actor_attacks .. actor_text .. grid_start

      for b, a in pairs(database[actor]["attacks"][k]["energy"]) do
        energy = '<image image="'.. a ..'_i" preserveAspect="true"></image>'
        master = master .. energy
      end

      master = master .. "</GridLayout></panel>"
    end
    return master
  end

  UI_master = ""

  local sideUI1 = generate_sideUI(color1)
  local sideUI2 = generate_sideUI(color2)

  UI_master = sideUI1 .. sideUI2
  player_grid1 = '<GridLayout id="'.. color1 ..'_panel" spacing="-15 -7" childAlignment="LowerCenter" cellSize="400 127" width="50%" active="false" hideAnimation="FadeOut" showAnimation="FadeIn" animationDuration="0.25" visibility ="'.. color1 ..'">'
  player_grid2 = '<GridLayout id="'.. color2 ..'_panel" spacing="-15 -7" childAlignment="LowerCenter" cellSize="400 127" width="50%" active="false" visibility ="'.. color2 ..'">'

  local attacks1 = generate_attacks(actor1, color1)
  local attacks2 = generate_attacks(actor2, color2)

  UI_master = UI_master .. player_grid1 .. attacks1 .. "</GridLayout>" .. player_grid2 .. attacks2 .. "</GridLayout>"

  UI.setXml(UI_master)
  return true
end

function hide_attacks()
  active = UI.getAttribute("White_Panel", "active")
  if active == "false" then
    UI.show("White_Panel")
  else
    UI.hide("White_Panel")
  end
end


function mouseOver(player, option, id)
  UI.setAttribute(id, "offsetxy", "20 150")
  UI.setAttribute(id, "height", "425")
end

function mouseOut(player, option, id)
  UI.setAttribute(id, "offsetxy", "25 150")
  UI.setAttribute(id, "height", "300")
end
