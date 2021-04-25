include <./flat-ui-colors.scad>;

encoderCutoutD = 7.5;
encoderCutoutH = 20;

encoderKnobD = 14.4;
encoderKnobH = 16.4;

encoderBaseX = 11.7;
encoderBaseY = 13.75;
encoderBaseH = 6.5;

encoderPinsH = 4;

module encoderKnob() {
    translate([0, 0, encoderBaseH + 4])
    color("#ef5777") cylinder(h=encoderKnobH, d=encoderKnobD);
}

module encoderPanel(cutout = false, thickness = encoderCutoutH) {
    translate([0, 0, encoderBaseH])
    color("#0be881") cylinder(h=encoderCutoutH, d=encoderCutoutD);
    
    if (cutout == false) {
        translate([0, -6, encoderBaseH + 1])
        color("#ffc048") cube([2.3, 1, 2], center=true);
        
    } else {
        translate([0, -6, encoderBaseH + (thickness / 2)])
        color("#ffc048") cube([2.3, 1, thickness], center=true);
    }
}

module encoderBase() {
    translate([-(encoderBaseX / 2), -6.5, 0])
    color("#575fcf") cube([encoderBaseX, encoderBaseY, encoderBaseH]);
}

module encoderPins() {
    translate([-(encoderBaseX / 2), -6.5, -encoderPinsH])
    color("#4bcffa") cube([encoderBaseX, encoderBaseY, encoderPinsH]);
}

module rotaryEncoder(cutout=false, thickness = 3) {
    encoderPanel(cutout, thickness);
    encoderBase();
    
    if (cutout == false) {
        encoderKnob();
        
        encoderPins();
    }
}

// rotaryEncoder();

/*rotaryEncoder();

translate([20, 0, 0])
rotaryEncoder(true);*/