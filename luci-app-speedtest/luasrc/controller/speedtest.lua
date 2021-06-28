
module("luci.controller.speedtest", package.seeall)

function index()

	entry({"admin","network","speedtest"},cbi("speedtest/speedtest", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}),_("speedtest"),90).dependent=true

	entry({"admin", "network","test_iperf0"}, post("test_iperf0"), nil).leaf = true

	entry({"admin", "network","test_iperf1"}, post("test_iperf1"), nil).leaf = true

	entry({"admin","network","speedtest", "run"}, call("run"))

	entry({"admin", "network", "speedtest", "realtime_log"}, call("get_log")) 

end


function testlan(cmd, addr)
		luci.http.prepare_content("text/plain")
		local util = io.popen(cmd)
		if util then
			while true do
				local ln = util:read("*l")
				if not ln then break end
				luci.http.write(ln)
				luci.http.write("\n")
			end
			util:close()
		end

end

function testwan(cmd)
		local util = io.popen(cmd)
		util:close()
end

function test_iperf0(addr)
	testlan("iperf3 -s ", addr)
end

function test_iperf1(addr)
	luci.sys.call("killall iperf3")
end

function get_log()
    local fs = require "nixio.fs"
    local e = {}
    e.running = luci.sys.call("busybox ps -w | grep speedtest | grep -v grep >/dev/null") == 0
    e.log = fs.readfile("/var/log/speedtest.log") or ""
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function run()
    testwan("/etc/init.d/speedtest nstest ")
	luci.http.redirect(luci.dispatcher.build_url("admin","network","speedtest"))
end
