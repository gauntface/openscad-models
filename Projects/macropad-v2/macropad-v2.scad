include <../../libs/cherry-mx-switch.scad>;
include <../../libs/flat-ui-colors.scad>;

thickness = 3;

keyCols = 3;
keyRows = 2;
keyPadding = 0;
keyOffset = topXY + keyPadding;

pcbX = 60;
pcbY = 52;
pcbZ = 1.6;

screenX = 38;
screenY = 12;
screenZ = 3.6;

mpXPadding = 10;
mpYPadding = 10;
mpX = (cherrymxSpace * keyCols) + (mpXPadding * 2);
mpY = (cherrymxSpace * keyRows) + (mpYPadding * 2);

module cherrymxCols(cutout = false) {
    for (i = [0:keyCols - 1]) {
        o = cherrymxSpace * i;
        translate([o, 0, 0]) cherrymx(cutout);
    }
}

module cherrymxRows(cutout = false) {
    for (i = [0:keyRows - 1]) {
        o = cherrymxSpace * i;
        translate([0, o, 0]) cherrymxCols(cutout);
    }
}

module cherrymxKeys(cutout = false) {
    translate([cherrymxSpace / 2, cherrymxSpace / 2, 0])
    cherrymxRows(cutout);
}

module screen() {
    translate([mpXPadding, (cherrymxSpace * keyRows) + mpYPadding , -cherrymxPCBZ])
    color(flatui[5]) cube([screenX, screenY, screenZ]);
}

module rotaryEncoder() {
    translate([mpX - (cherrymxSpace / 2), (cherrymxSpace * keyRows) + mpYPadding , -cherrymxPCBZ])
    cube([11.7, 13.75, 6]);
}

module pcb() {
    translate([(mpX - pcbX) / 2, mpYPadding, -cherrymxPCBZ - pcbZ])
    color(flatui[3]) cube([pcbX, pcbY, pcbZ]);
}

module parts(cutout=false) {
    translate([mpXPadding, mpYPadding, 0]) cherrymxKeys(cutout);
    
    screen();
    
    rotaryEncoder();
    
    pcb();
}

module switchPlateLayer() {
    translate([0, 0, -thickness])
    color(flatui[4]) cube([mpX, mpY, thickness]);
}

module middleLayers() {
    translate([0, 0, -(2 * thickness)])
    color(flatui[5]) cube([mpX, mpY, thickness]);
    
    translate([0, 0, -(3 * thickness)])
    color(flatui[6]) cube([mpX, mpY, thickness]);
    
    translate([0, 0, -(4 * thickness)])
    color(flatui[7]) cube([mpX, mpY, thickness]);
    
    translate([0, 0, -(5 * thickness)])
    color(flatui[8]) cube([mpX, mpY, thickness]);
}

module baseLayer() {
    translate([0, 0, -(6 * thickness)])
    color(flatui[9]) cube([mpX, mpY, thickness]);
}

module plates() {
    switchPlateLayer();
    // middleLayers();
    // baseLayer();
}

parts(false);
plates();