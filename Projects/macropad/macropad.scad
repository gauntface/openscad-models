include <../../libs/cherry-mx-switch.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;
include <../../libs/adafruit-oled.scad>;
include <../../libs/flat-ui-colors.scad>;
include <../../libs/adafruit-panel-mount.scad>;

thickness = 3;
keyCols = 5;
keyRows = 2;
keyPadding = 0.5;
keyOffset = topXY + keyPadding;

screenPadding = 4;

padPadding = 12;
padX = ((keyOffset * keyCols) + keyPadding) + padPadding;
padY = ((keyOffset * keyRows) + keyPadding) + screenPadding + pcbY + padPadding;
padZ = 24;

module cherrymxCols(cutout = false) {
    for (i = [0:keyCols - 1]) {
        // o = keyOffset * i;
        // translate([o, 0, 0]) cherrymx(cutout);
        cherrymx(cutout);
    }
}

module cherrymxRows(cutout = false) {
    for (i = [0:keyRows - 1]) {
        // o = keyOffset * i;
        // translate([0, o, 0]) cherrymxCols(cutout);
        cherrymxCols(cutout);
    }
}

module parts(cutout=false) {
    indent = ((topXY / 2) + keyPadding) + (padPadding / 2);
    translate([indent, indent, thickness]) cherrymxRows(cutout);
    
    translate([(padX - pcbX) / 2, (padPadding / 2) + (keyOffset * keyRows) + keyPadding + screenPadding, -(pcbZ + screenZ)]) adafruitOLED();
    
    translate([padX / 2, padY, -padZ + (padPadding / 2)]) rotate([0, 0, 180]) panel(thickness + 1);
}

module padTop() {
    color(flatui[3]) cube([padX, padY, thickness]);
}

module padBottom() {
    translate([0, 0, -padZ - thickness]) color(flatui[3]) cube([padX, padY, thickness]);
}

padTop();
padBottom();
parts(false);