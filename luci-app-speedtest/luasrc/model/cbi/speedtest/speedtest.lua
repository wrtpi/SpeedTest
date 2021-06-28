-- Copyright 2021  wrtpi <wrtpi@pm.me>
require("luci.util")
local o,t,e
 
if luci.sys.call("pidof iperf3 >/dev/null") == 0 then
	status = translate("<strong><font color=\"green\">iperf3 服务端运行中</font></strong>")
else
	status = translate("<strong><font color=\"red\">iperf3 服务端已停止</font></strong>")
end

o = Map("speedtest", "<font color='green'>" .. translate("speedtest") .."</font>",translate( "Network speed diagnosis test (including intranet and extranet)") )

t = o:section(TypedSection, "speedtest", translate('iperf3 lanspeedtest'))
t.anonymous = true
t.description = translate(string.format("%s<br />", status))

e = t:option(DummyValue, '', '')
e.rawhtml = true
e.template ='speedtest/speedtest'


t=o:section(TypedSection,"speedtest",translate("wanspeedtest"))
t.anonymous=true
e = t:option(DummyValue, '', '')
e.rawhtml = true
e.template ='speedtest/speedtest'

e =t:option(DummyValue, '', '')
e.rawhtml = true
e.template = 'speedtest/log'

return o
