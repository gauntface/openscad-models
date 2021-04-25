include <../../libs/cherry-mx-switch.scad>;
include <../../libs/rotary-encoder-ACZ11BR1E.scad>;
include <../../libs/btn-1825910-6.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;
include <../../libs/flat-ui-colors.scad>;

thickness = 3;
keyCols = 3;
keyRows = 2;

pcbX = 74.5;
pcbY = 72;
pcbH = 1.6;

module cherrymx(cutout) {
    if (cutout) {
        cherrymxPlate();
    } else {
        cherrymxSwitch();
    }
}

module cherrymxKeys(cutout = false) {
    // Key 1
    translate([17.5, 34.25, cherrySwitchH]) cherrymx(cutout);
    
    // Key 2
    translate([37.25, 34.25, cherrySwitchH]) cherrymx(cutout);
    
    // Key 3
    translate([56.75, 34.25, cherrySwitchH]) cherrymx(cutout);
    
    // Key 4
    translate([17.5, 14.75, cherrySwitchH]) cherrymx(cutout);
    
    // Key 5
    translate([37.25, 14.75, cherrySwitchH]) cherrymx(cutout);
    
    // Key 6
    translate([56.75, 14.75, cherrySwitchH]) cherrymx(cutout);
}

module pcb(cutout = false) {
    if (cutout == false) {
        color(flatui[3]) cube([pcbX, pcbY, pcbH]);
    }
}

module parts(cutout=false) {
    cherrymxKeys(cutout);
    
    translate([0, 0, -pcbH]) pcb(cutout);
    
    translate([59.75, 58, 0]) rotate([0, 0, 180]) rotaryEncoder(cutout);
    
    translate([7, 60, 0]) btn18625910();
}

module topLayer() {
    translate([0, 0, cherrySwitchH - thickness])
    color(flatui[8]) cube([pcbX, pcbY, thickness]);
}

module padBottom() {
    translate([0, 0, -padZ - thickness]) color(flatui[3]) cube([padX, padY, thickness]);
}

topLayer();
// padBottom();*/
parts(true);