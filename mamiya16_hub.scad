
// height of the main part of the spool
SPOOLH = 16;

// diameter of the main part of the spool
SPOOLDIA = 14;

// height of the screw above the top of the cartridge
SCREWH = 2;

// diameter of the takeup feed screw
SCREWDIA = 7.5;

// screw (crosspoint) parameters
CROSSWIDTH = 5.75;				// width of the cross-point
CROSSTHICK = 1.5;			// thickness of the cross-point segments
CROSSDEPTH = 2.5;			// how deep the cross-point digs into the screwhead


// recess around screw parameters
RECESSDEP = 2.75;			// how deep the recess cuts into the spool
RECESSDIA = 10.25;			// the diameter of the recess

// hub parameters
HUBDIA = 11.75;				// diameter of the hub
HUBDEP = 11;				// depth of the hub

///////////////////////////////////////////////////////////////////////////////////////////////////

// fudge
FUDGE = 0.1;

// make round objects more accurate
$fn = 100;

///////////////////////////////////////////////////////////////////////////////////////////////////


// generate a positive form of the cross-point on the hub feed screwhead
module crosspoint(h=1.0)
{
	translate([-CROSSWIDTH/2, -CROSSTHICK/2, 0])
		union() {
			cube([CROSSWIDTH, CROSSTHICK, CROSSDEPTH]);
			translate([(CROSSWIDTH+CROSSTHICK)/2,-(CROSSWIDTH-CROSSTHICK)/2,0]) rotate([0,0,90]) cube([CROSSWIDTH, CROSSTHICK, CROSSDEPTH]);
		}
}

union() {
	difference() {
		cylinder(h=SPOOLH, d=SPOOLDIA);		// main spool body
		translate([0,0,SPOOLH-RECESSDEP+FUDGE]) cylinder(h=RECESSDEP, d=RECESSDIA);		// recess around screwhead
		translate([0,0,-FUDGE]) cylinder(h=HUBDEP, d=HUBDIA);
	}

	difference() {
		translate([0,0,SPOOLH-RECESSDEP-FUDGE]) cylinder(h=SCREWH+RECESSDEP, d=SCREWDIA);	// screw head
		translate([0,0,SPOOLH+SCREWH-CROSSDEPTH+FUDGE])	crosspoint();
	}
}

//crosspoint();