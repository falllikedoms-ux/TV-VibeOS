sub init()
    m.tilesGroup = m.top.findNode("tiles")
    m.status = m.top.findNode("status")
    m.clock = m.top.findNode("clock")
    m.focusIndex = 0
    m.tiles = []
    m.apps = []
    m.columns = 4

    loadConfig()
    buildTiles()
    setFocusIndex(0)

    updateClock()
    timer = m.top.findNode("clockTimer")
    timer.observeField("fire", "updateClock")
    timer.control = "start"

    m.top.setFocus(true)
end sub

sub loadConfig()
    raw = ReadAsciiFile("pkg:/config/channels.json")
    cfg = ParseJson(raw)
    if cfg = invalid or cfg.apps = invalid
        m.status.text = "Could not read config/channels.json"
        return
    end if
    m.apps = cfg.apps
    if cfg.columns <> invalid and cfg.columns > 0 then m.columns = cfg.columns
    if cfg.title <> invalid then m.top.findNode("title").text = cfg.title
end sub

sub buildTiles()
    tileW = 380
    tileH = 220
    gap = 40
    startX = (1920 - (m.columns * tileW + (m.columns - 1) * gap)) \ 2
    startY = 360

    for i = 0 to m.apps.count() - 1
        app = m.apps[i]
        col = i mod m.columns
        row = i \ m.columns
        x = startX + col * (tileW + gap)
        y = startY + row * (tileH + gap)

        g = CreateObject("roSGNode", "Group")
        g.translation = [x, y]

        border = CreateObject("roSGNode", "Rectangle")
        border.width = tileW + 16
        border.height = tileH + 16
        border.translation = [-8, -8]
        border.color = "0xFFFFFFFF"
        border.visible = false
        g.appendChild(border)

        bg = CreateObject("roSGNode", "Rectangle")
        bg.width = tileW
        bg.height = tileH
        bg.color = app.color
        g.appendChild(bg)

        lbl = CreateObject("roSGNode", "Label")
        lbl.width = tileW
        lbl.height = tileH
        lbl.horizAlign = "center"
        lbl.vertAlign = "center"
        lbl.font = "font:LargeBoldSystemFont"
        lbl.text = app.name
        lbl.color = app.text
        g.appendChild(lbl)

        m.tilesGroup.appendChild(g)
        m.tiles.push({ border: border, group: g })
    end for
end sub

sub setFocusIndex(idx as Integer)
    if m.tiles.count() = 0 then return
    m.tiles[m.focusIndex].border.visible = false
    m.tiles[m.focusIndex].group.scale = [1, 1]
    m.focusIndex = idx
    m.tiles[idx].border.visible = true
    m.status.text = ""
end sub

sub updateClock()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()
    h = dt.GetHours()
    suffix = "AM"
    if h >= 12 then suffix = "PM"
    h = h mod 12
    if h = 0 then h = 12
    mins = dt.GetMinutes().toStr()
    if mins.len() = 1 then mins = "0" + mins
    m.clock.text = h.toStr() + ":" + mins + " " + suffix
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    n = m.tiles.count()
    if n = 0 then return false
    i = m.focusIndex
    col = i mod m.columns

    if key = "right"
        if col < m.columns - 1 and i + 1 < n then setFocusIndex(i + 1)
        return true
    else if key = "left"
        if col > 0 then setFocusIndex(i - 1)
        return true
    else if key = "down"
        if i + m.columns < n
            setFocusIndex(i + m.columns)
        else if (i \ m.columns) < ((n - 1) \ m.columns)
            setFocusIndex(n - 1)
        end if
        return true
    else if key = "up"
        if i - m.columns >= 0 then setFocusIndex(i - m.columns)
        return true
    else if key = "OK" or key = "play"
        launchApp(m.apps[i])
        return true
    end if
    return false
end function

sub launchApp(app as Object)
    if app.id = invalid or app.id = ""
        m.status.text = app.name + " has no Roku app ID yet. Edit config/channels.json (see README)."
        return
    end if
    m.status.text = "Launching " + app.name + "..."
    m.launchTask = CreateObject("roSGNode", "LaunchTask")
    m.launchTask.observeField("result", "onLaunchResult")
    m.launchTask.appId = app.id
    m.launchTask.control = "RUN"
end sub

sub onLaunchResult()
    r = m.launchTask.result
    if r = invalid then return
    if not r.ok
        m.status.text = "Launch failed: " + r.message
    end if
end sub
