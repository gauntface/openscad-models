include <../../../libs/flat-ui-colors.scad>;

acrylicThickness = 3;
nothing = 0.1;

height = 270;

haloR = 50;
haloThickness = 16;

legWidth = 16;

spikeLength = 40;

module halo() {
    color(flatui[1]) difference() {
        translate([0, 0, acrylicThickness/2]) cylinder(h = acrylicThickness, r=haloR, center = true);
        translate([0, 0, acrylicThickness/2]) cylinder(h = acrylicThickness*3, r=haloR-haloThickness, center = true);
    }
}

module leg() {
    difference() {
        color(flatui[2]) cube([legWidth, height-haloR, acrylicThickness]);
    
        translate([0, 0, -acrylicThickness]) linear_extrude(height=acrylicThickness * 3) polygon([
            [-nothing, -nothing],
            [-nothing, spikeLength],
            [legWidth / 2, -nothing],
        ]);
        translate([0, 0, -acrylicThickness]) linear_extrude(height=acrylicThickness * 3) polygon([
            [legWidth / 2, -nothing],
            [legWidth+nothing, spikeLength],
            [legWidth+nothing, 0],
        ]);
    }
}

module model() {
    translate([haloR, height - haloR, 0]) halo();

    leg();
    translate([(haloR*2)-legWidth, 0, 0]) leg();
}

module laserCut() {
    $fn=100;
    projection() model();
}

laserCut();