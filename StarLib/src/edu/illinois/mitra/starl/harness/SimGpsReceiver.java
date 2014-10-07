package edu.illinois.mitra.starl.harness;

import edu.illinois.mitra.starl.gvh.GlobalVarHolder;
import edu.illinois.mitra.starl.interfaces.GpsReceiver;
import edu.illinois.mitra.starl.interfaces.RobotEventListener.Event;
import edu.illinois.mitra.starl.objects.Common;
import edu.illinois.mitra.starl.objects.ItemPosition;
import edu.illinois.mitra.starl.objects.PositionList;

public class SimGpsReceiver implements GpsReceiver {
	private static final String TAG = "GPSReceiver";
	
	private GlobalVarHolder gvh;
	
	public boolean inMotion = false;
	
	private SimGpsProvider provider;
	
	public SimGpsReceiver(GlobalVarHolder gvh, SimGpsProvider provider, ItemPosition initpos) {
		this.gvh = gvh;
		this.provider = provider;
		provider.registerReceiver(gvh.id.getName(), this);
		provider.addRobot(initpos);
	}
	
	@Override
	public void start() {
		// TODO Auto-generated method stub
	}

	@Override
	public void cancel() {
		// TODO Auto-generated method stub
	}

	public void receivePosition(boolean inMotion) {
		gvh.trace.traceEvent(TAG, "Received Position", gvh.gps.getMyPosition(), gvh.time());
		gvh.sendRobotEvent(Event.GPS_SELF);
		if(inMotion) {
			gvh.sendRobotEvent(Event.MOTION, Common.MOT_STRAIGHT);
		} else {
			gvh.sendRobotEvent(Event.MOTION, Common.MOT_STOPPED);
		}
		this.inMotion = inMotion;
	}

	@Override
	public PositionList getRobots() {
		return provider.getRobotPositions();
	}

	@Override
	public PositionList getWaypoints() {
		return provider.getWaypointPositions();
	}
}
