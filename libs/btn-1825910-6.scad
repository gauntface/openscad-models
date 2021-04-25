include <./flat-ui-colors.scad>;

btnBumpD = 3.51;
btnBumpH = 0.5;

btnBaseX = 5.99;
btnBaseY = 5.99;
btnBaseH = 3.61;

btnPinsH = 3.51;

/*module encoderPanel(cutout = false, thickness = encoderCutoutH) {
    translate([0, 0, btnBaseH])
    color("#0be881") cylinder(h=encoderCutoutH, d=encoderCutoutD);
    
    if (cutout == false) {
        translate([0, -6, btnBaseH + 1])
        color("#ffc048") cube([2.3, 1, 2], center=true);
        
    } else {
        translate([0, -6, btnBaseH + (thickness / 2)])
        color("#ffc048") cube([2.3, 1, thickness], center=true);
    }
}*/

module btnBump() {
    translate([0, 0, btnBaseH])
    color("#0be881") cylinder(h=btnBumpH, d=btnBumpD);
}

module btnPins() {
    translate([0, 0, -(btnPinsH / 2)])
    color("#4bcffa") cube([btnBaseX, btnBaseY, btnPinsH], center=true);
}

module btn18625910() {
    translate([0, 0, btnBaseH / 2])
    color("#575fcf") cube([btnBaseX, btnBaseY, btnBaseH], center = true);
    
    btnPins();
    
    btnBump();
}

// btn18625910();