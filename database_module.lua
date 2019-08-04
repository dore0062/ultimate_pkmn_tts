function onLoad(saved_data)
  if saved_data ~= "" then
    local loaded_data = JSON.decode(saved_data)
    last_version = loaded_data["version"]
    database = loaded_data["db"]
  else
    getData()
  end

  dialogue = false
  WebRequest.get("https://mmbndb-dca4f.firebaseio.com/database_version.json", function(a) webRequestCallback2(a) end) -- actually checks the version.
end

function webRequestCallback(webReturn) -- Saves latest version
  if not is_error then
    print("PKMN DB Module: [5CE553]successfully downloaded latest database.")
    database = JSON.decode(webReturn.text)
    this_version = db_version
  else
    print("PKMN DB Module: [FF5733]Downloading latest database failed. Game will not function correctly.")
  end
  dialogue = false
end

function webRequestCallback2(webReturn) -- Saves latest version
  if not is_error then
    db_version = webReturn.text
    if last_version ~= db_version then
      printToAll("PKMN DB Module: [FFC300]new Pokemon Database available.[-] Would you like to download?\n Current version: [FF0000]".. tostring(last_version) .. "[-] New version: [FF0000]".. tostring(db_version) .."[-]\n\nChat [5CE553]YES[-] or [FF5733]NO[-].", {r = 0.75, g = 0.23, b = 0})
      dialogue = true
    else
      printToAll("PKMN DB Module: [DAF7A6]database is up to date.")
      this_version = last_version
    end
    if is_error then
      if database ~= nil then
        print("PKMN DB Module: [FF5733]Connection to database failed. No saved database detected. Game will not function correctly.")
      else
        print("PKMN DB Module: [FF5733]Connection to database failed. Using last saved database.")
      end
    end
  end
end

function onSave()
  local to_save = {version = this_version, db = database}
  local saved_data = JSON.encode(to_save)
  return saved_data
end

function onChat(message, player)
  if player.host == true then
    if dialogue == true then
      if message:lower() == "no" then
        printToAll("PKMN DB Module: update not preformed.")
      end
      if message:lower() == "yes" then
        getData()
      end
    end
  end
end

function getData()
  WebRequest.get("https://mmbndb-dca4f.firebaseio.com/pkmn.json", function(a) webRequestCallback(a) end) -- Loads the current database.
end
