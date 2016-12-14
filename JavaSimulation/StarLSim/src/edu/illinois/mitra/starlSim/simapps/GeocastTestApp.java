package edu.illinois.mitra.starlSim.simapps;

import java.util.List;
import java.util.Random;

import edu.illinois.mitra.starl.comms.MessageContents;
import edu.illinois.mitra.starl.comms.RobotMessage;
import edu.illinois.mitra.starl.functions.Geocaster;
import edu.illinois.mitra.starl.gvh.GlobalVarHolder;
import edu.illinois.mitra.starl.interfaces.LogicThread;
import edu.illinois.mitra.starl.interfaces.MessageListener;
import edu.illinois.mitra.starl.objects.ItemPosition;
import edu.illinois.mitra.starlSim.main.SimSettings;

public class GeocastTestApp extends LogicThread implements MessageListener {
	
	private enum STAGE { START, MOVE, SEND, DONE }
	private STAGE stage = STAGE.START;
	private Geocaster geo;
	
	private int n_waypoints;
	private Random rand = new Random();
	private int nextpt = -1;
	private int visited_pts = 0;
	
	public GeocastTestApp(GlobalVarHolder gvh) {
		super(gvh);
		gvh.trace.traceStart();
		
		geo = new Geocaster(gvh);
		
		// Register this as a listener for messages with ID=99
		gvh.comms.addMsgListener(99, this);
		
		n_waypoints = gvh.gps.getWaypointPositions().getNumPositions();
	}

	@Override
	public List<Object> callStarL() {
		while(true) {
			switch(stage) {
			case START:
				gvh.sleep((long) (Math.random()*1000));
				gvh.trace.traceSync("Launch");
				stage = STAGE.MOVE;
				break;
			case MOVE:
				int go_to = rand.nextInt(n_waypoints);
				while(go_to == nextpt) {  go_to = rand.nextInt(n_waypoints); }
				nextpt = go_to;
				gvh.plat.moat.goTo(gvh.gps.getWaypointPosition("DEST" + nextpt));
				// Move to the next waypoint
				while(gvh.plat.moat.inMotion) {gvh.sleep(10);}
				stage = STAGE.SEND;
				visited_pts ++;
				break;
			case SEND:
				MessageContents contents = new MessageContents("hello from " + name);
				
				// Send a geocast to a random waypoint
				// Circular target area:
				int sendTo = rand.nextInt(n_waypoints);
				ItemPosition sendToPos = gvh.gps.getWaypointPosition("DEST" + sendTo);
				geo.sendGeocast(contents, 99, sendToPos.x, sendToPos.y, 300);
				System.out.println(name + " sending geocast to DEST" + sendTo);
				
				if(visited_pts == 2) {
					stage = STAGE.DONE;
				} else {
					stage = STAGE.MOVE;
				}
				break;
			case DONE:
				gvh.trace.traceEnd();
				return returnResults();
			}
			gvh.sleep(30);
		}
	}

	@Override
	public void messageReceied(RobotMessage m) {
		System.out.println(name + " received a geocast message: " + m.getContentsList().toString());
		synchronized(stage) {
			stage = STAGE.DONE;
		}
	}
}
