/*************
 * Mamiya-16 Film Cartridge
 *
 * Phil Pemberton <philpem@philpem.me.uk>
 * Licence: Creative Commons BY-NC-SA.
 *
 * This OpenSCAD model creates an STL file which forms the base part of a Mamiya-16 film cartridge.
 *************/



$fn=100;


// cartridge base height
H=18;

// cartridge diameter
D=21.5;

// wall thickness
WALL = 1.5;

SLIDINGFIT = 0.1;

// cap ridge thickness, needs to be the same as the cap
RIDGEWALL = 0.75 + SLIDINGFIT;
// height of the ridge at the top of the cartridge
RIDGEH = 5;

// film slot width
SLOT = 1.25;

// gap between the spools
SPOOLGAP = 18;


// reel mounting pin (hub) diameter
HUBPINDIA = 10;

// reel mounting pin height
HUBPINHGT = 5;


///////////////////////////////////////////////////////////////////////////////////////////////////

// fudge
FUDGE = 0.1;

///////////////////////////////////////////////////////////////////////////////////////////////////


// inner part of the spool
module spoolinner(rightspool)
{
	union() {
		difference() {
			union() {
				cylinder(H, d=D);		// cylindrical body
				cube([D/2, D/2, H]);	// square section
			}
			union() {
				translate([0,0,WALL]) cylinder(H, d=D-(WALL*2));	// inside of cylinder
				translate([(D/2)-WALL-SLOT,FUDGE,WALL]) cube([SLOT, D/2, H]);	// film exit slot
				translate([(D/2)-WALL-SLOT-(D/5)+FUDGE,FUDGE+(D/7),WALL]) cube([D/5, D/5, H]);	// take the sharp edge off the film exit slot
			}
		}
		
		if (rightspool) {
			cylinder(WALL+HUBPINHGT, d=HUBPINDIA);	// hub pin, mates with the hub on the spool
		}
	}
}

// subtracted from spoolinner() to form the ridge
module spoolridge(rightspool)
{
	DX = (D - (RIDGEWALL*2));
	
	difference() {
		union() {
			cylinder(RIDGEH, d=D+FUDGE);		// cylindrical body
			cube([(D+FUDGE)/2, (D+FUDGE)/2, RIDGEH]);	// square section
		}
		union() {
			translate([0,0,-FUDGE]) cylinder(RIDGEH+(2*FUDGE), d=DX);	// inside of cylinder
			translate([-FUDGE, -FUDGE, -FUDGE]) cube([(DX/2)+FUDGE, (DX/2)+FUDGE, RIDGEH+(FUDGE*2)]);	// square section
		}
	}
}


module spool(rightspool) 
{
	difference() {
		spoolinner(rightspool);
		translate([0,0,H-RIDGEH+FUDGE]) spoolridge();
	}
}


// left spool
spool(false);

// right spool
translate([0,SPOOLGAP+D,0]) mirror([0,1,0]) spool(true);

// bridge
BRIDGEW = 7.25;		// width of the bridge
BRIDGEOFS = 4;		// offset of the bridge towards the cartridge centre

NOTCHD = 2.5;		// how far the notch cuts into the bridge
NOTCHW = 7.5;		// the width of the notch
NOTCHH = 1.0;		// how thick the bridge is

translate([(D/2)-BRIDGEW-BRIDGEOFS,D/2,0]) 
	difference() {
		cube([BRIDGEW, SPOOLGAP, WALL]);
		translate([0,SPOOLGAP/2,WALL-NOTCHH+FUDGE]) resize([NOTCHD, NOTCHW, NOTCHH]) cylinder(h=1, d=1);
	}
