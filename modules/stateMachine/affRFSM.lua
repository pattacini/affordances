
--require("yarp")
return rfsm.state {

    ----------------------------------
	-- state INIT   	            --
	----------------------------------
	ST_INIT = rfsm.state{
		entry=function()
	        print(">> in ST_INIT")
            ret = aff_rpc:open("/fsm/aff:o")
            ret = ret and fe_rpc:open("/fsm/fe:o")
            
            if ret == false then
                print("cannot open some ports")
                rfsm.send_events(fsm, "e_open_failed")
            else    
                rfsm.send_events(fsm, "e_open_ok")
            end    
		end
	},


    ----------------------------------
	-- state CONNECT   	            --
	----------------------------------
	ST_CONNECT = rfsm.state{
		entry=function()
	        print(">> in ST_CONNECT")
            --ret = yarp.NetworkBase_connect(are_rpc:getName(), "/actionsRendeingEngine/cmd:io")
            ret = yarp.NetworkBase_connect(aff_rpc:getName(), "/affManager/cmd:rpc")
            --ret = yarp.NetworkBase_connect(karma_rpc:getName(), "/karma/rpc")
            ret = yarp.NetworkBase_connect(fe_rpc:getName(), "/featExt/rpc:i")
            if ret == false then
                print("cannot connect to some ports")
                rfsm.send_events(fsm, "e_con_failed")
            else    
                rfsm.send_events(fsm, "e_con_ok")
            end    
		end
	},

    ----------------------------------
	-- state GOHOME                 --
	----------------------------------
	ST_GOHOME = rfsm.state{
		entry = function()
            print(">> in ST_GOHOME ")
            request = yarp.Bottle()
            reply = yarp.Bottle()
            request:clear()
            request:addString('goHome')
            aff_rpc:write(req, reply)
            if reply:get(0):asString() == "ok" then
                 rfsm.send_events(fsm, "e_home_ok")
                 print(">> gone home")
            else
                 rfsm.send_events(fsm, "e_home_failed")
                 print(">> going home failed")
            end
		end
	},
    
	----------------------------------
	-- state LOOKATTOOL   	        --
	----------------------------------
	ST_LOOKATTOOL = rfsm.state{
            entry = function()
            print(">> in ST_LOOKATTOOL")
            request = yarp.Bottle()
            reply = yarp.Bottle()
            request:clear()
            request:addString('lookAtTool')
            aff_rpc:write(req, reply)           
            if reply:get(0):asInt() == "ok" then
                 rfsm.send_events(fsm, "e_lookAtTool_ok")
            else
                 rfsm.send_events(fsm, "e_lookAtTool_failed")
                 print("Cant find any tool")
            end
        end
        --cnt=0
        --function guardLook() cnt=cnt+1; return cnt<max; end
        ----------------------------------
        -- sub-state FINDTOOLS          --
        ----------------------------------     
        ST_FINDTOOLS = rfsm.state{
            entry = function()
                print(">> in ST_FINDTOOLS")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('findTools')
                aff_rpc:write(req, reply)           
                if reply:get(0):asInt() == "ok" then
                     rfsm.send_events(fsm, "e_findTools_ok")
                else
                     rfsm.send_events(fsm, "e_findTools_failed")
                     print("Cant find any tool")
                end
            end
        },
        
        ----------------------------------
        -- sub-state LOOKTORACK     --
        ----------------------------------     
        ST_LOOKATRACK = rfsm.state{
            entry = function()
                print(">> in ST_LOOKATRACK")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('lookAtRack')
                aff_rpc:write(req, reply)           
                if reply:get(0):asInt() == "ok" then
                     rfsm.send_events(fsm, "e_lookAtRack_ok")
                else
                     rfsm.send_events(fsm, "e_lookAtRack_failed")
                     print("Something happened when looking at Rack")
                end
            end
        },
        
        ----------------------------------
        -- sub-state LOOKTOPOINT        --
        ----------------------------------     
        ST_LOOKATPOINT = rfsm.state{
            entry = function()
                print(">> in ST_LOOKATPOINT")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('lookAtPoint')
                aff_rpc:write(req, reply)           
                if reply:get(0):asInt() == "ok" then
                     rfsm.send_events(fsm, "e_lookAtPoint_ok")
                else
                     rfsm.send_events(fsm, "e_lookAtPoint_failed")
                     print("Something wrong when looking at the point")
                end
            end
        },
        
        ----------------------------------
        -- sub-state SELECTTOOL         --
        ----------------------------------     
        ST_SELECTTOOL = rfsm.state{
            entry = function()
                print(">> in ST_SELECTTOOL")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('selectTool')
                aff_rpc:write(req, reply)           
                if reply:get(0):asInt() == "ok" then
                     rfsm.send_events(fsm, "e_selectTool_ok")
                else
                     rfsm.send_events(fsm, "e_selectTool_failed")
                     print("Could not decide for a tool")
                end
            end
        },            
    }, 
    
    
    ----------------------------------
	-- state GETTOOL  	            --
	----------------------------------
	ST_GETTOOL = rfsm.state{
        ----------------------------------
        -- sub-state REACHTOOL         --
        ----------------------------------     
        ST_REACHTOOL = rfsm.state{
            entry = function()
                print(">> in ST_REACHTOOL")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('reachTool')
                aff_rpc:write(req, reply)           
                if reply:get(0):asString() == "ok" then
                     rfsm.send_events(fsm, "e_areachTool_ok")
                else
                     rfsm.send_events(fsm, "e_reachTool_failed")
                     print("Reaching Tool not achieved")
                end
            end
        },
    
        ----------------------------------
        -- sub-state ASKFORTOOL         --
        ----------------------------------     
        ST_ASKFORTOOL = rfsm.state{
            entry = function()
                print(">> in ST_ASKFORTOOL")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('askForTool')
                aff_rpc:write(req, reply)           
                if reply:get(0):asString() == "ok" then
                     rfsm.send_events(fsm, "e_askForTool_ok")
                else
                     rfsm.send_events(fsm, "e_askForTool_failed")
                     print("Asking for tool could not be done")
                end
            end
        },
    
        ----------------------------------
        -- sub-state GRASPTOOL  	    --
        ----------------------------------
        ST_GRASPTOOL = rfsm.state{
            entry = function()
                print(">> in ST_GRASPTOOL")
                request = yarp.Bottle()
                reply = yarp.Bottle()
                request:clear()
                request:addString('graspTool')
                aff_rpc:write(req, reply)           
                if reply:get(0):asString() == "ok" then
                     rfsm.send_events(fsm, "e_graspTool_ok")
                else
                     rfsm.send_events(fsm, "e_graspTool_failed")
                     print("Grasping tool failed")
                end
            end
        },
    },
    ----------------------------------
	-- state OBSTOOL  	            --
	----------------------------------
	ST_OBSTOOL = rfsm.state{
		entry = function()
            print(">> in ST_OBSTOOL")
            request = yarp.Bottle()
            reply = yarp.Bottle()
            request:clear()
            request:addString('observeTool')
            aff_rpc:write(req, reply)
            if reply:get(0):asString() == "ok" then
                 rfsm.send_events(fsm, "e_observeTool_ok")
            else
                 rfsm.send_events(fsm, "e_observeTool_failed")
                 print("Cannot observe tool")
            end
		end
	},
    
    
    ----------------------------------
	-- state DROPTOOL  	            --
	----------------------------------
	ST_DROPTOOL = rfsm.state{
		entry = function()
            print(">> in ST_DROPTOOL")
            request = yarp.Bottle()
            reply = yarp.Bottle()
            request:clear()
            request:addString('drop')
            aff_rpc:write(req, reply)
            if reply:get(0):asString() == "ok" then
                 rfsm.send_events(fsm, "e_drop_ok")
            else
                 rfsm.send_events(fsm, "e_drop_failed")
                 print("Drop failed")
            end
		end
	},
    
	----------------------------------
	-- state FINI                   --
	----------------------------------
	ST_FINI = rfsm.state{
		entry=function()
			print(">> in ST_FINI")
            shouldExit = true
		end
	},


	----------------------------------
	-- setting the transitions      --
	----------------------------------

	rfsm.transition { src='initial', tgt='ST_INIT'},
    
    rfsm.transition { src='ST_INIT', tgt='ST_CONNECT', events={ 'e_open_ok' } },
    rfsm.transition { src='ST_INIT', tgt='ST_FINI', events={ 'e_open_failed' } },    
    
    rfsm.transition { src='ST_CONNECT', tgt='ST_GOHOME', events={ 'e_con_ok' } },
    rfsm.transition { src='ST_CONNECT', tgt='ST_FINI', events={ 'e_con_failed' } },    
    
    rfsm.transition { src='ST_GOHOME', tgt=".ST_LOOKATTOOL.ST_FINDTOOLS", events={ 'e_home_ok' } },
    rfsm.transition { src='ST_GOHOME', tgt='ST_FINI', events={ 'e_home_failed' } },
	
    -- From state findTools
    rfsm.transition { src=".ST_LOOKATTOOL.ST_FINDTOOLS", tgt=".ST_LOOKATTOOL.ST_SELECTTOOL", events={ 'e_findTools_ok' } },        
    rfsm.transition { src=".ST_LOOKATTOOL.ST_FINDTOOLS", tgt=".ST_LOOKATTOOL.ST_LOOKATRACK", events={ 'e_findTools_failed' } },
    -- XXX This need to be changed to allow to go to LookAtRack or to lookAtPoint, or to askForTool.
    
    -- From LookAtRack
	rfsm.transition { src=".ST_LOOKATTOOL.ST_LOOKATRACK", tgt=".ST_GETTOOL.ST_REACHTOOL", events={ 'e_LookAtRack_ok' } },        
    rfsm.transition { src=".ST_LOOKATTOOL.ST_LOOKATRACK", tgt=".ST_GETTOOL.ST_ASKFORTOOL", events={ 'e_LookAtRack_failed' } },
      
    -- From SelectTool
	rfsm.transition { src=".ST_LOOKATTOOL.ST_SELECTTOOL", tgt=".ST_GETTOOL.ST_REACHTOOL", events={ 'e_selectTool_ok' } },        
    rfsm.transition { src=".ST_LOOKATTOOL.ST_SELECTTOOL", tgt=".ST_GETTOOL.ST_ASKFORTOOL", events={ 'e_selectTool_failed' } },

    -- From AskForTool
	rfsm.transition { src=".ST_GETTOOL.ST_ASKFORTOOL", tgt=".ST_GETTOOL.ST_GRASPTOOL", events={ 'e_askForTool_ok' } },        
    rfsm.transition { src=".ST_GETTOOL.ST_ASKFORTOOL", tgt='ST_FINI', events={ 'e_askForTool_failed' } },
    
    -- From ReachTool
	rfsm.transition { src=".ST_GETTOOL.ST_REACHTOOL", tgt=".ST_GETTOOL.ST_GRASPTOOL", events={ 'e_reachTool_ok' } },        
    rfsm.transition { src=".ST_GETTOOL.ST_REACHTOOL", tgt=".ST_GETTOOL.ST_ASKFORTOOL", events={ 'e_reachTool_failed' } },

    -- From GraspTool
	rfsm.transition { src=".ST_GETTOOL.ST_GRASPTOOL", tgt='ST_OBSTOOL', events={ 'e_graspTool_ok' } },        
    rfsm.transition { src=".ST_GETTOOL.ST_GRASPTOOL", tgt=".ST_GETTOOL.ST_ASKFORTOOL", events={ 'e_graspTool_failed' } },

    -- From ObsTool
    rfsm.transition { src='ST_OBSTOOL', tgt='ST_DROPTOOL', events={ 'e_obs_ok' } },  
    rfsm.transition { src='ST_OBSTOOL', tgt='ST_FINI', events={ 'e_obs_failed' } },
	  
    -- From Drop
    rfsm.transition { src='ST_DROPTOOL', tgt='ST_GOHOME', events={ 'e_drop_ok' } },  
    rfsm.transition { src='ST_DROPTOOL', tgt='ST_FINI', events={ 'e_drop_failed' } },
	  
}




