sub init()
    m.top.functionName = "doLaunch"
end sub

' Launches another channel by POSTing to this device's own ECP endpoint.
' Requires Settings > System > Advanced system settings > Control by mobile apps
' > Network access to be "Default" or "Permissive".
sub doLaunch()
    ips = []
    di = CreateObject("roDeviceInfo")
    ci = di.GetConnectionInfo()
    if ci <> invalid and ci.ip <> invalid and ci.ip <> "" then ips.push(ci.ip)
    ips.push("127.0.0.1")

    lastCode = 0
    for each ip in ips
        xfer = CreateObject("roUrlTransfer")
        xfer.SetUrl("http://" + ip + ":8060/launch/" + m.top.appId)
        lastCode = xfer.PostFromString("")
        if lastCode = 200 or lastCode = 204
            m.top.result = { ok: true, code: lastCode, message: "" }
            return
        end if
    end for

    msg = "ECP returned " + lastCode.toStr() + ". Check app ID, and that Network access is not 'Disabled'."
    m.top.result = { ok: false, code: lastCode, message: msg }
end sub
