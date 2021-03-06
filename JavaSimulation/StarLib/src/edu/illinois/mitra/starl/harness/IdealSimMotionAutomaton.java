package edu.illinois.mitra.starl.harness;

import edu.illinois.mitra.starl.gvh.GlobalVarHolder;
import edu.illinois.mitra.starl.interfaces.RobotEventListener;
import edu.illinois.mitra.starl.motion.MotionParameters;
import edu.illinois.mitra.starl.motion.RobotMotion;
import edu.illinois.mitra.starl.objects.Common;
import edu.illinois.mitra.starl.objects.ItemPosition;

public class IdealSimMotionAutomaton extends RobotMotion implements RobotEventListener {
	private static final String TAG = "MotionAutomaton";
	private IdealSimGpsProvider gpspro;
	private String name;
	private MotionParameters defaultParam = MotionParameters.defaultParameters();
	
	private GlobalVarHolder gvh;
	
	private ItemPosition dest;
	
	public IdealSimMotionAutomaton(GlobalVarHolder gvh, IdealSimGpsProvider gpspro) {
		this.gvh = gvh;
		this.gpspro = gpspro; 
		name = gvh.id.getName();
		gvh.addEventListener(this);
		gvh.trace.traceEvent(TAG, "Created", gvh.time());
	}
	@Override
	public void goTo(ItemPosition dest) {
		ItemPosition ip = new ItemPosition(dest);
		this.dest = ip;
		
		gvh.trace.traceEvent(TAG, "Go To", ip, gvh.time());
		
		gpspro.setDestination(name, ip, defaultParam.LINSPEED_MAX);
		
		inMotion = true;
	}

	@Override
	public void turnTo(ItemPosition dest) {
		// turnTo isn't implemented for ideal motion		
	}

	@Override
	public void cancel() {
		gvh.trace.traceEvent(TAG, "Cancelled", gvh.time());
		motion_stop();
	}

	@Override
	public void motion_stop() {
		gvh.trace.traceEvent(TAG, "Halt", gvh.time());
		gpspro.halt(name);
	}
	@Override
	public void robotEvent(Event type, int event) {
		if(type == Event.MOTION) {
			inMotion = (event!=Common.MOT_STOPPED);
		}
	}

	@Override
	public void motion_resume() {
		// I don't think anything needs to happen here
	}
	@Override
	public void setParameters(MotionParameters param) 
	{
		defaultParam = param;
	}
}
