include <./flat-ui-colors.scad>;

panelMountX = 26;
panelMountY = 6;
panelMountZ = 38;

module screwHoles(screwDepth) {
    translate([-10, 0, 0]) {
        color(flatui[1]) cylinder(h=screwDepth, d=3.4);

        color(flatui[1]) translate([20, 0, 0]) cylinder(h=screwDepth, d=3.4);
    }
}

module panel(screwDepth=1) {
    rotate([90, 0, 0]) {
        color(flatui[2]) translate([-(panelMountX / 2), -(panelMountY / 2), -panelMountZ]) cube([panelMountX, panelMountY, panelMountZ]);

        screwHoles(screwDepth);
    }
}

panel(20);