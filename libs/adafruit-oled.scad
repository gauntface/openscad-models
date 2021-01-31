include <./flat-ui-colors.scad>;

pcbX = 80.6;
pcbY = 36;
pcbZ = 1;

screenX = 69;
screenY = 24;
screenZ = 7.4;

screenPosX = (pcbX - screenX) / 2;
screenPosY = (pcbY - screenY) / 2;

module pcb() {
    color(flatui[1]) cube([pcbX, pcbY, pcbZ]);
}

module screen() {
    color(flatui[2]) translate([screenPosX, screenPosY, pcbZ]) cube([screenX, screenY, screenZ]);
}

module adafruitOLED() {
    pcb();
    screen();
}