$fn=100;

// cartridge lid height
H=7.5;

// cartridge diameter
D=21.5;

// wall thickness
WALL = 1.5;

SLIDINGFIT = 0.1;

// ridge thickness, needs to be the same as the base
RIDGEWALL = 0.75 - SLIDINGFIT;
// height of the ridge at the top of the cartridge
RIDGEH = 5;

// film slot width
SLOT = 1.25;

// gap between the spools
SPOOLGAP = 18;

///////////////////////////////////////////////////////////////////////////////////////////////////

// fudge
FUDGE = 0.1;


// inner part of the spool
module spoolinner()
{
	difference() {
		union() {
			cylinder(H, d=D);		// cylindrical body
			cube([D/2, D/2, H]);	// square section
		}
		union() {
			//translate([0,0,h]) cylinder(H, d=D-(WALL*2));	// inside of cylinder
			//%translate([(D/2)-WALL-SLOT-(D/5)+FUDGE,FUDGE+(D/7),(H-RIDGEWALL)]) cube([D/5, D/5, H]);	// take the sharp edge off the film exit slot
			translate([(D/2)-WALL-SLOT,FUDGE,H-RIDGEH+FUDGE]) cube([SLOT, D/2, H]);	// film exit slot
		}
	}
}

// subtracted from spoolinner() to form the inside of the lid
module lidcavity()
{
	DX = D - (RIDGEWALL*2);
	
	difference() {
		union() {
			cylinder(RIDGEH, d=DX);		// cylindrical body
			cube([DX/2, DX/2, RIDGEH]);	// square section
		}
	}
}


module spool() 
{
	difference() {
		spoolinner();
		translate([0,0,H-RIDGEH+FUDGE]) lidcavity();
	}
}


// left lid

RHOLE_RIDGE_DIA = 10;		// locating ridge for the film reel
RHOLE_RIDGE_HGT = 3.5;		// locating ridge height
RHOLE_DIA = 8.5;			// hole dia for takeup spool screw

difference() {
	union() {
		spool();
		cylinder(RHOLE_RIDGE_HGT, d=RHOLE_RIDGE_DIA);
	}
	translate([0,0,-FUDGE]) cylinder(H+(2*FUDGE), d=RHOLE_DIA);		// screw hole
	translate([0,0,-FUDGE]) cylinder((WALL/2)+(2*FUDGE), d=(RHOLE_DIA*1.75));		// screw hole
}


// right lid
translate([0,SPOOLGAP+D,0]) mirror([0,1,0]) spool();
