--------------------------------------------------------------------------
--------------------------------------------------------------------------
---                                 .::.                               ---
---                               .;:**'            AMC                ---
---                               `                  0                 ---
---   .:XHHHHk.              db.   .;;.     dH  MX   0                 ---
--- oMMMMMMMMMMM       ~MM  dMMP :MMMMMR   MMM  MR      ~MRMN          ---
--- QMMMMMb  "MMX       MMMMMMP !MX' :M~   MMM MMM  .oo. XMMM 'MMM     ---
---   `MMMM.  )M> :X!Hk. MMMM   XMM.o"  .  MMMMMMM X?XMMM MMM>!MMP     ---
---    'MMMb.dM! XM M'?M MMMMMX.`MMMMMMMM~ MM MMM XM `" MX MMXXMM      ---
---     ~MMMMM~ XMM. .XM XM`"MMMb.~*?**~ .MMX M t MMbooMM XMMMMMP      ---
---      ?MMM>  YMMMMMM! MM   `?MMRb.    `"""   !L"MMMMM XM IMMM       ---
---       MMMX   "MMMM"  MM       ~%:           !Mh.""" dMI IMMP       ---
---       'MMM.                                             IMX        ---
---        ~M!M                                             IMP        ---
---                        MASTER TRAINER GALAXY                       ---
---                           POKEDEX MODULE                           ---
--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- The pokedex is a sandbox spawner for debugging and setting up custom teams.
-- It's state is always reset between sessions since it doesn't actually matter. 

function onload(saved_data)
  -- self.interactable = false -- Move via gizmo tool. Disable to lock first. Pokedex should NEVER MOVE!!!
  self.setName("Pokedex") -- Should always be called "Pokedex"
  self.AssetBundle.playLoopingEffect(2) -- instead of fancy onload/onsave just set it closed to reset state

  --- Options
  db_module    = getObjectFromGUID("28b051")
  index        = 1 -- Starting index
  timeout      = false -- Should not be false.
  timeout_time = 0.65 -- Time between clicking buttons. Prevents XMLUI from breaking
  reset_pos    = {3.36846, - 27.43427, 0} -- Reset positions of components
  max_pokemon  = 152 -- Current max index number
  ---

  function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
    for _, name in ipairs(children) do
      element = element.getChild(name)
    end
    return element
  end

  if saved_data ~= "" then -- Deletes any loaded hologram from last save
    local model = JSON.decode(saved_data)
    if model then
    local m = getObjectFromGUID(model["model"])
    if m then
    m.destruct()
  end
end
  end

  pokeball   = extractChild(self, {'PokeDex (1)(Clone)', 'BottomScreen', 'Canvas (1)', 'Panel', 'Pokeball'}).getComponent("RectTransform")
  sheet      = extractChild(self, {'PokeDex (1)(Clone)', 'Top_Part', 'Canvas', 'Panel', 'Panel', 'Image'}).getComponent("RectTransform")
  type_image = extractChild(self, {'PokeDex (1)(Clone)', 'Top_Part', 'Canvas', 'Panel', 'Lines', '2', 'Type_image', 'Image', }).getComponent("RectTransform")

  selected = false
end

function onSave()
  saved_data = JSON.encode(saved_model)
  return saved_data
end

----------------------------
-- Browser
----------------------------
function down() -- Scrolls down
  if selected == true then
    return nil
  else


    index = index + 1
    if index == max_pokemon then index = max_pokemon - 1 return nil end
    -- Set position of the sheet
    pos = sheet.get("localPosition")
    pos.x = pos.x - 209.5 -- Not extremely precise, but good for this purpose.
    if pos.x < - 3138 then
      pos.y = pos.y + 209.5
      pos.x = 3147
    end
    sheet.set("localPosition", pos)

    self.UI.setAttribute("name1", "text", pokedex_index[index - 1])
    self.UI.setAttribute("name2", "text", pokedex_index[index])
    self.UI.setAttribute("name3", "text", pokedex_index[index + 1])

    -- Show if Pokemon exists
    if database[pokedex_index[index - 1]:lower()] then
      self.UI.setAttribute("hp1", "active", "false")
    else
      self.UI.setAttribute("hp1", "active", "true")
    end

    if database[pokedex_index[index]:lower()] then
      self.UI.setAttribute("hp2", "active", "false")
    else
      self.UI.setAttribute("hp2", "active", "true")
    end

    if database[pokedex_index[index + 1]:lower()] then
      self.UI.setAttribute("hp3", "active", "false")
    else
      self.UI.setAttribute("hp3", "active", "true")
    end

    -- Rotate pokeball for coolness
    rot = pokeball.get("eulerAngles")
    rot.y = rot.y - 15
    pokeball.set("eulerAngles", rot)
    self.AssetBundle.playTriggerEffect(0)
  end
end

function up() -- Scrolls up
  -- Selected movement
  if selected == true then
    return nil
  else

    -- Set position of the sheet
    pos = sheet.get("localPosition")
    if pos.x == 3147 and pos.y == -2094 then
      return nil
    end

    index = index - 1

    pos.x = pos.x + 209.5 -- Accurate enough.
    if pos.x > 3147 then
      pos.y = pos.y - 209.5
      pos.x = -3138
    end

    sheet.set("localPosition", pos)
    self.UI.setAttribute("name1", "text", pokedex_index[index - 1])
    self.UI.setAttribute("name2", "text", pokedex_index[index])
    self.UI.setAttribute("name3", "text", pokedex_index[index + 1])

    -- Show if Pokemon exists
    if pokedex_index[index - 1] then
      if database[pokedex_index[index - 1]:lower()] then
        self.UI.setAttribute("hp1", "active", "false")
      else
        self.UI.setAttribute("hp1", "active", "true")
      end
    end

    if database[pokedex_index[index]:lower()] then
      self.UI.setAttribute("hp2", "active", "false")
    else
      self.UI.setAttribute("hp2", "active", "true")
    end

    if database[pokedex_index[index + 1]:lower()] then
      self.UI.setAttribute("hp3", "active", "false")
    else
      self.UI.setAttribute("hp3", "active", "true")
    end

    -- Rotate pokeball for coolness
    rot = pokeball.get("eulerAngles")
    rot.y = rot.y + 15
    pokeball.set("eulerAngles", rot)
    self.AssetBundle.playTriggerEffect(0)
  end
end

function search(_,num) -- Enter an ID to go to that index. Laggy but nobody but host should be using it anywho
  if num == "" then return nil end

  local num = tonumber(num) -- Always a integer anyways
  if num > max_pokemon then
    self.UI.setAttribute("search","text",tostring(max_pokemon))
    num = max_pokemon
  end

  if num > index then
  for i = 0, num - index - 1, 1 do
    down()
  end
end

if num < index then
for i = 0, num - index + 1, -1 do
  up()
end
end

end

----------------------------
-- Buttons
----------------------------
function open() -- Opens the Pokedex
  self.AssetBundle.playLoopingEffect(1)
  self.UI.setAttribute("open", "active", false)
  self.UI.setAttribute("BottomScreen", "active", true)
  self.UI.setAttribute("close", "active", true)
  self.UI.setAttribute("name1", "active", true)
  self.UI.setAttribute("name2", "active", true)
  self.UI.setAttribute("name3", "active", true)

  self.AssetBundle.playTriggerEffect(1)
  database = db_module.getTable("database") -- The database is retrieved every time the Pokedex is opened.
  log("Pokedex [".. self.getGUID() .."] opened")
  Wait.time(|| self.UI.setAttribute("n_text", "active", true), 0.50)
  Wait.time(|| self.UI.setAttribute("grey", "active", true), 0.50)
end

function close() -- Closes the pokedex
  self.AssetBundle.playLoopingEffect(2)
  self.UI.setAttribute("open", "active", true)
  self.UI.setAttribute("BottomScreen", "active", false)
  self.UI.setAttribute("close", "active", false)
  self.UI.setAttribute("n_text", "active", false)
  self.UI.setAttribute("grey", "active", false)
  selected = false

  if pokemon_obj ~= nil then
    pokemon_obj.destruct()
  end

end

function select() -- Selects a Pokemon or selects a move
  ---- Button timeout
  if timeout == true then return nil end
  timeout = true
  Wait.time(function() timeout = false end, timeout_time)
  ----

  if selected == false then
    if database[pokedex_index[index]:lower()] == nil then
      return nil
    end
    selected = true
    self.UI.setAttribute("hp1", "active", "false")
    self.UI.setAttribute("hp2", "active", "false")
    self.UI.setAttribute("hp3", "active", "false")
    self.AssetBundle.playLoopingEffect(3)
    self.AssetBundle.playTriggerEffect(2)

    ------ Set UI
    for i = 1, 3, 1 do
      -- Reset UI
      self.UI.setAttribute("attack" .. i, "text", " ")
      self.UI.setAttribute("damage" .. i, "text", " ")
    end

    local hp = database[pokedex_index[index]:lower()]["hp"]

    local t = 0
    for x, b in pairs(database[pokedex_index[index]:lower()]["attacks"]) do
      t = t + 1
      self.UI.setAttribute("attack" .. t, "text", x)
      local damage = database[pokedex_index[index]:lower()]["attacks"][x]["damage"]
      if damage == 0 then damage = " " end
      self.UI.setAttribute("damage" .. t, "text", damage)
    end

    self.UI.setAttribute("hp", "text", hp)
    self.UI.setAttribute("name", "text", pokedex_index[index])
    Wait.time(|| self.UI.show("p_text"), 0.60)
    self.UI.setAttribute("n_text", "active", "false")

    local bpos = type_image.get("localPosition")
    local type = database[pokedex_index[index]:lower()]["type"]

    bpos.x = bpos.x + types[type][1]
    bpos.y = bpos.y + types[type][2]
    type_image.set("localPosition", bpos)
    ------

    local position = self.getPosition()
    local rotation = self.getRotation()
    position.x = position.x - 4.91
    position.y = position.y + 0.50
    position.z = position.z + 0.50

    local spawn_params = {
      type = "Custom_Assetbundle",
      position = position,
      rotation = rotation,
      scale = {x = 0.25, y = 0.25, z = 0.25},
      sound = false,
      snap_to_grid = false,
      callback_function = function(obj) spawn_obj(obj) end
    }
    spawnObject(spawn_params)
  else
    return nil
  end
end

function spawn_obj(obj) -- Spawn object a
  local obj_params = {
    assetbundle = tostring(database[pokedex_index[index]:lower()]["assetbundle"]),
    type = 1
  }

  local success = obj.setCustomObject(obj_params)
  if success == true then
    pokemon_obj = obj.reload()
    pokemon_obj.interactable = false
    saved_model = {model = pokemon_obj.getGUID()}
  else
    log("Error spawning assetbundle ".. obj_params.assetbundle)
  end
end

function back() -- Return
  ---- Button timeout
  if timeout == true then return nil end
  timeout = true
  Wait.time(function() timeout = false end, timeout_time)
  ----

  if selected == true then
    selected = false
    self.AssetBundle.playLoopingEffect(4)
    self.AssetBundle.playTriggerEffect(3)
    self.UI.setAttribute("p_text", "active", "false")
    Wait.time(|| type_image.set("localPosition", reset_pos), 0.50)
    Wait.time(|| self.UI.show("n_text"), 0.65)

    if pokemon_obj ~= nil then
      Wait.time(|| pokemon_obj.destruct(), 0.55)
    end

  else
    return nil
  end
end

function spawn()
  local function spawn_ball(obj)
    obj_params = {
      assetbundle = "http://cloud-3.steamusercontent.com/ugc/782985908091916046/FC447EFCEA246B85BAEB7F8A3B01ECAA49259D94/",
      type = 1
    }
    obj.setCustomObject(obj_params)
    obj = obj.reload()
    luascript = generateData(pokedex_index[index]:lower())
    obj.setLuaScript(luascript)
    obj.setLock(false)
    obj.setName("Pokeball")
    obj.addForce({0, 50, 0}, 1) -- this only sort of works right now
    log("Pokemon spawned [" .. obj.getGUID() .. "]")
  end


  if selected == false then return nil
  else
    local position = self.getPosition()

    position.x = position.x + 3.50
    position.y = position.y + 1
    position.z = position.z + 0.50

    local spawn_params = {
      type = "Custom_Assetbundle",
      position = position,
      sound = false,
      snap_to_grid = false,
      callback_function = function(obj) spawn_ball(obj) end
    }

    spawnObject(spawn_params)
  end
end


function generateData(pmon) -- Generates the data that gets put into a pokeball
  rand = math.random(0, 1)
  if rand == 1 then gender = "'male'" else gender = "'female'" end -- Randomly picks male / female (for now)
  -- Nickname is nill if you use a pokedex
  -- name is the name given *in the database*
  -- gender is randomly chosen
  -- hp is the CURRENT hp, not the TOTAL hp. - overflow shouldn't matter.
  n = "'".. pmon .."'" -- force convert to string from string to string auuuuuuugh
  t = "data = {name = ".. n ..", gender = ".. gender ..", hp = ".. database[pmon]["hp"] ..", nickname = nil, index =".. index .."}" -- Codeblocks don't work with strings :)
  o = [[

function onLoad()
  self.tooltip = false

  local function loaded()
    if self.loading_custom == false then
     return true
   else
     return false
   end
  end

  Wait.condition(setImage, loaded) -- onLoad triggers early if spawned via script. This prevents premature image setting.
end

function setImage()
  local function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
    for _, name in ipairs(children) do
      a = 1 + 1 -- Without this it fails. I don't know why.
      element = element.getChild(name)
    end
    return element
  end

  sheet = extractChild(self, {'Pokeball(Clone)', 'Bottom', 'Canvas', 'Panel', 'Image'}).getComponent("RectTransform")
  pos = sheet.get("localPosition")

  for i = 1, data.index - 1 do
  pos.x = pos.x - 2.26

  if pos.x > 69 then
    pos.y = pos.y + 2.26
    pos.x = -1.0477
  end

  end
  sheet.set("localPosition", pos)
end

function onObjectPickUp(colorName, obj) if obj == self then self.AssetBundle.playLoopingEffect(3)
    end
end

function onObjectDrop(colorName, obj)
    if obj == self then
      self.AssetBundle.playLoopingEffect(4)
    end
end]] -- Makes it so when you click it it opens it and vice versa.
  -- Need to add image to assetbundle that changes based on the pmon, similar to the Pokedex. I really don't see any easier way to do this.


  return t .. o
end

----------------------------
-- Tables
----------------------------
-- Positions of the types on the spritesheet.
types = {
  dark     = {0, - 100},
  fairy    = {0, - 50},
  flying   = {0, 0},
  ground   = {0, 50},
  poison   = {0, 103},
  steel    = {0, 155},

  dragon   = { - 97, - 100},
  fighting = { - 97, - 50},
  ghost    = { - 97, 0},
  ice      = { - 97, 50},
  psychic  = { - 97, 103},
  water    = { - 97, 155},

  bug      = {97, - 100},
  electric = {97, - 50},
  fire     = {97, 0},
  grass    = {97, 50},
  normal   = {97, 103},
  rock     = {97, 155},
}

-- We don't get this from the database because it's exclusive to the Pokedex
-- These need to be converted to lowercase before use on the DB.
pokedex_index = {
  "Bulbasaur",
  "Ivysaur",
  "Venusaur",
  "Charmander",
  "Charmeleon",
  "Charizard",
  "Squirtle",
  "Wartortle",
  "Blastoise",
  "Caterpie",
  "Metapod",
  "Butterfree",
  "Weedle",
  "Kakuna",
  "Beedrill",
  "Pidgey",
  "Pidgeotto",
  "Pidgeot",
  "Rattata",
  "Raticate",
  "Spearow",
  "Fearow",
  "Ekans",
  "Arbok",
  "Pikachu",
  "Raichu",
  "Sandshrew",
  "Sandslash",
  "NidoranF",
  "Nidorina",
  "Nidoqueen",
  "NidoranM",
  "Nidorino",
  "Nidoking",
  "Clefairy",
  "Clefable",
  "Vulpix",
  "Ninetales",
  "Jigglypuff",
  "Wigglytuff",
  "Zubat",
  "Golbat",
  "Oddish",
  "Gloom",
  "Vileplume",
  "Paras",
  "Parasect",
  "Venonat",
  "Venomoth",
  "Diglett",
  "Dugtrio",
  "Meowth",
  "Persian",
  "Psyduck",
  "Golduck",
  "Mankey",
  "Primeape",
  "Growlithe",
  "Arcanine",
  "Poliwag",
  "Poliwhirl",
  "Poliwrath",
  "Abra",
  "Kadabra",
  "Alakazam",
  "Machop",
  "Machoke",
  "Machamp",
  "Bellsprout",
  "Weepinbell",
  "Victreebel",
  "Tentacool",
  "Tentacruel",
  "Geodude",
  "Graveler",
  "Golem",
  "Ponyta",
  "Rapidash",
  "Slowpoke",
  "Slowbro",
  "Magnemite",
  "Magneton",
  "Farfetch'd",
  "Doduo",
  "Dodrio",
  "Seel",
  "Dewgong",
  "Grimer",
  "Muk",
  "Shellder",
  "Cloyster",
  "Gastly",
  "Haunter",
  "Gengar",
  "Onix",
  "Drowzee",
  "Hypno",
  "Krabby",
  "Kingler",
  "Voltorb",
  "Electrode",
  "Exeggcute",
  "Exeggutor",
  "Cubone",
  "Marowak",
  "Hitmonlee",
  "Hitmonchan",
  "Lickitung",
  "Koffing",
  "Weezing",
  "Rhyhorn",
  "Rhydon",
  "Chansey",
  "Tangela",
  "Kangaskhan",
  "Horsea",
  "Seadra",
  "Goldeen",
  "Seaking",
  "Staryu",
  "Starmie",
  "MrMime",
  "Scyther",
  "Jynx",
  "Electabuzz",
  "Magmar",
  "Pinsir",
  "Tauros",
  "Magikarp",
  "Gyarados",
  "Lapras",
  "Ditto",
  "Eevee",
  "Vaporeon",
  "Jolteon",
  "Flareon",
  "Porygon",
  "Omanyte",
  "Omastar",
  "Kabuto",
  "Kabutops",
  "Aerodactyl",
  "Snorlax",
  "Articuno",
  "Zapdos",
  "Moltres",
  "Dratini",
  "Dragonair",
  "Dragonite",
  "Mewtwo",
  "Mew",
  "Chikorita",
  "Bayleef",
  "Meganium",
  "Cyndaquil",
  "Quilava",
  "Typhlosion",
  "Totodile",
  "Croconaw",
  "Feraligatr",
  "Sentret",
  "Furret",
  "Hoothoot",
  "Noctowl",
  "Ledyba",
  "Ledian",
  "Spinarak",
  "Ariados",
  "Crobat",
  "Chinchou",
  "Lanturn",
  "Pichu",
  "Cleffa",
  "Igglybuff",
  "Togepi",
  "Togetic",
  "Natu",
  "Xatu",
  "Mareep",
  "Flaaffy",
  "Ampharos",
  "Bellossom",
  "Marill",
  "Azumarill",
  "Sudowoodo",
  "Politoed",
  "Hoppip",
  "Skiploom",
  "Jumpluff",
  "Aipom",
  "Sunkern",
  "Sunflora",
  "Yanma",
  "Wooper",
  "Quagsire",
  "Espeon",
  "Umbreon",
  "Murkrow",
  "Slowking",
  "Misdreavus",
  "Unown",
  "Wobbuffet",
  "Girafarig",
  "Pineco",
  "Forretress",
  "Dunsparce",
  "Gligar",
  "Steelix",
  "Snubbull",
  "Granbull",
  "Qwilfish",
  "Scizor",
  "Shuckle",
  "Heracross",
  "Sneasel",
  "Teddiursa",
  "Ursaring",
  "Slugma",
  "Magcargo",
  "Swinub",
  "Piloswine",
  "Corsola",
  "Remoraid",
  "Octillery",
  "Delibird",
  "Mantine",
  "Skarmory",
  "Houndour",
  "Houndoom",
  "Kingdra",
  "Phanpy",
  "Donphan",
  "Porygon2",
  "Stantler",
  "Smeargle",
  "Tyrogue",
  "Hitmontop",
  "Smoochum",
  "Elekid",
  "Magby",
  "Miltank",
  "Blissey",
  "Raikou",
  "Entei",
  "Suicune",
  "Larvitar",
  "Pupitar",
  "Tyranitar",
  "Lugia",
  "Ho-oh",
  "Celebi",
  "Treecko",
  "Grovyle",
  "Sceptile",
  "Torchic",
  "Combusken",
  "Blaziken",
  "Mudkip",
  "Marshtomp",
  "Swampert",
  "Poochyena",
  "Mightyena",
  "Zigzagoon",
  "Linoone",
  "Wurmple",
  "Silcoon",
  "Beautifly",
  "Cascoon",
  "Dustox",
  "Lotad",
  "Lombre",
  "Ludicolo",
  "Seedot",
  "Nuzleaf",
  "Shiftry",
  "Taillow",
  "Swellow",
  "Wingull",
  "Pelipper",
  "Ralts",
  "Kirlia",
  "Gardevoir",
  "Surskit",
  "Masquerain",
  "Shroomish",
  "Breloom",
  "Slakoth",
  "Vigoroth",
  "Slaking",
  "Nincada",
  "Ninjask",
  "Shedinja",
  "Whismur",
  "Loudred",
  "Exploud",
  "Makuhita",
  "Hariyama",
  "Azurill",
  "Nosepass",
  "Skitty",
  "Delcatty",
  "Sableye",
  "Mawile",
  "Aron",
  "Lairon",
  "Aggron",
  "Meditite",
  "Medicham",
  "Electrike",
  "Manectric",
  "Plusle",
  "Minun",
  "Volbeat",
  "Illumise",
  "Roselia",
  "Gulpin",
  "Swalot",
  "Carvanha",
  "Sharpedo",
  "Wailmer",
  "Wailord",
  "Numel",
  "Camerupt",
  "Torkoal",
  "Spoink",
  "Grumpig",
  "Spinda",
  "Trapinch",
  "Vibrava",
  "Flygon",
  "Cacnea",
  "Cacturne",
  "Swablu",
  "Altaria",
  "Zangoose",
  "Seviper",
  "Lunatone",
  "Solrock",
  "Barboach",
  "Whiscash",
  "Corphish",
  "Crawdaunt",
  "Baltoy",
  "Claydol",
  "Lileep",
  "Cradily",
  "Anorith",
  "Armaldo",
  "Feebas",
  "Milotic",
  "Castform",
  "Kecleon",
  "Shuppet",
  "Banette",
  "Duskull",
  "Dusclops",
  "Tropius",
  "Chimecho",
  "Absol",
  "Wynaut",
  "Snorunt",
  "Glalie",
  "Spheal",
  "Sealeo",
  "Walrein",
  "Clamperl",
  "Huntail",
  "Gorebyss",
  "Relicanth",
  "Luvdisc",
  "Bagon",
  "Shelgon",
  "Salamence",
  "Beldum",
  "Metang",
  "Metagross",
  "Regirock",
  "Regice",
  "Registeel",
  "Latias",
  "Latios",
  "Kyogre",
  "Groudon",
  "Rayquaza",
  "Jirachi",
  "Deoxys(N)",
  "Deoxys(A)",
  "Deoxys(D)",
  "Deoxys(S)",
  "Turtwig",
  "Grotle",
  "Torterra",
  "Chimchar",
  "Monferno",
  "Infernape",
  "Piplup",
  "Prinplup",
  "Empoleon",
  "Starly",
  "Staravia",
  "Staraptor",
  "Bidoof",
  "Bibarel",
  "Kricketot",
  "Kricketune",
  "Shinx",
  "Luxio",
  "Luxray",
  "Budew",
  "Roserade",
  "Cranidos",
  "Rampardos",
  "Shieldon",
  "Bastiodon",
  "Burmy",
  "Wormadam(P)",
  "Wormadam(S)",
  "Wormadam(T)",
  "Mothim",
  "Combee",
  "Vespiquen",
  "Pachirisu",
  "Buizel",
  "Floatzel",
  "Cherubi",
  "Cherrim",
  "Shellos",
  "Gastrodon",
  "Ambipom",
  "Drifloon",
  "Drifblim",
  "Buneary",
  "Lopunny",
  "Mismagius",
  "Honchkrow",
  "Glameow",
  "Purugly",
  "Chingling",
  "Stunky",
  "Skuntank",
  "Bronzor",
  "Bronzong",
  "Bonsly",
  "MimeJr.",
  "Happiny",
  "Chatot",
  "Spiritomb",
  "Gible",
  "Gabite",
  "Garchomp",
  "Munchlax",
  "Riolu",
  "Lucario",
  "Hippopotas",
  "Hippowdon",
  "Skorupi",
  "Drapion",
  "Croagunk",
  "Toxicroak",
  "Carnivine",
  "Finneon",
  "Lumineon",
  "Mantyke",
  "Snover",
  "Abomasnow",
  "Weavile",
  "Magnezone",
  "Lickilicky",
  "Rhyperior",
  "Tangrowth",
  "Electivire",
  "Magmortar",
  "Togekiss",
  "Yanmega",
  "Leafeon",
  "Glaceon",
  "Gliscor",
  "Mamoswine",
  "Porygon-Z",
  "Gallade",
  "Probopass",
  "Dusknoir",
  "Froslass",
  "Rotom",
  "Rotom(Heat)",
  "Rotom(Wash)",
  "Rotom(Frost)",
  "Rotom(Spin)",
  "Rotom(Cut)",
  "Uxie",
  "Mesprit",
  "Azelf",
  "Dialga",
  "Palkia",
  "Heatran",
  "Regigigas",
  "Giratina",
  "Giratina(O)",
  "Cresselia",
  "Phione",
  "Manaphy",
  "Darkrai",
  "Shaymin",
  "Shaymin(S)",
  "Arceus",
  "Victini",
  "Snivy",
  "Servine",
  "Serperior",
  "Tepig",
  "Pignite",
  "Emboar",
  "Oshawott",
  "Dewott",
  "Samurott",
  "Patrat",
  "Watchog",
  "Lillipup",
  "Herdier",
  "Stoutland",
  "Purrloin",
  "Liepard",
  "Pansage",
  "Simisage",
  "Pansear",
  "Simisear",
  "Panpour",
  "Simipour",
  "Munna",
  "Musharna",
  "Pidove",
  "Tranquill",
  "Unfezant",
  "Blitzle",
  "Zebstrika",
  "Roggenrola",
  "Boldore",
  "Gigalith",
  "Woobat",
  "Swoobat",
  "Drilbur",
  "Excadrill",
  "Audino",
  "Timburr",
  "Gurdurr",
  "Conkeldurr",
  "Tympole",
  "Palpitoad",
  "Seismitoad",
  "Throh",
  "Sawk",
  "Sewaddle",
  "Swadloon",
  "Leavanny",
  "Venipede",
  "Whirlipede",
  "Scolipede",
  "Cottonee",
  "Whimsicott",
  "Petilil",
  "Lilligant",
  "Basculin",
  "Sandile",
  "Krokorok",
  "Krookodile",
  "Darumaka",
  "Darmanitan",
  "Darmanitan(Z)",
  "Maractus",
  "Dwebble",
  "Crustle",
  "Scraggy",
  "Scrafty",
  "Sigilyph",
  "Yamask",
  "Cofagrigus",
  "Tirtouga",
  "Carracosta",
  "Archen",
  "Archeops",
  "Trubbish",
  "Garbodor",
  "Zorua",
  "Zoroark",
  "Minccino",
  "Ciccino",
  "Gothita",
  "Gothorita",
  "Gothitelle",
  "Solosis",
  "Duosion",
  "Reuniclus",
  "Ducklett",
  "Swanna",
  "Vanillite",
  "Vanillish",
  "Vanilluxe",
  "Deerling",
  "Sawsbuck",
  "Emolga",
  "Karrablast",
  "Escavalier",
  "Foongus",
  "Amoonguss",
  "Frillish",
  "Jellicent",
  "Alomomola",
  "Joltik",
  "Galvantula",
  "Ferroseed",
  "Ferrothorn",
  "Klink",
  "Klang",
  "Klinklang",
  "Tynamo",
  "Eelektrik",
  "Eelektross",
  "Elgyem",
  "Beheeyem",
  "Litwick",
  "Lampent",
  "Chandelure",
  "Axew",
  "Fraxure",
  "Haxorus",
  "Cubchoo",
  "Beartic",
  "Cryogonal",
  "Shelmet",
  "Accelgor",
  "Stunfisk",
  "Mienfoo",
  "Mienshao",
  "Druddigon",
  "Golett",
  "Golurk",
  "Pawniard",
  "Bisharp",
  "Bouffalant",
  "Rufflet",
  "Braviary",
  "Vullaby",
  "Mandibuzz",
  "Heatmor",
  "Durant",
  "Deino",
  "Zweilous",
  "Hydreigon",
  "Larvesta",
  "Volcarona",
  "Cobalion",
  "Terrakion",
  "Virizion",
  "Tornadus",
  "Thundurus",
  "Reshiram",
  "Zekrom",
  "Landorus",
  "Kyurem",
  "Keldeo",
  "Meloetta(A)",
  "Meloetta(P)",
"Genesect"} -- Starts from 0
