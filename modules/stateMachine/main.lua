#!/usr/bin/lua

require("rfsm")
require("yarp")
--require("rfsm2uml")

yarp.Network()
-------
shouldExit = false

-- initialization
aff_rpc = yarp.RpcClient()
--karma_rpc = yarp.RpcClient()
fe_rpc = yarp.RpcClient()

-- load state machine model and initialize it
fsm_model = rfsm.load("./affRFSM.lua")
fsm = rfsm.init(fsm_model)
--rfsm2uml.rfsm2uml(fsm, 'png', "fsm.png", "Figure caption")

repeat   
    rfsm.run(fsm)
    yarp.Time_delay(0.1)
until shouldExit ~= false

print("finishing")

aff_rpc:close()
--karma_rpc:close()
fe_rpc:close()

-- De-initialize yarp network
yarp.Network_fini()




