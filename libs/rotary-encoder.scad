include <./flat-ui-colors.scad>;

encoderScrewRadius = 6.8;
encoderScrewDepth = 20;

encoderKnobRadius = 14.4;
encoderKnobHeight = 16.4;

encoderBaseHeight = 6.5;
encoderBaseXY = 15;

encoderBaseSpace = 10;

module encoderKnob() {
    translate([0, 0, encoderBaseHeight + 4])
    color(flatui[1]) cylinder(h=encoderKnobHeight, d=encoderKnobRadius);
}

module encoderScrew() {
    translate([0, 0, encoderBaseHeight])
    color(flatui[2]) cylinder(h=encoderScrewDepth, d=encoderScrewRadius);
}

module encoderBase() {
    translate([-15/2, -15/2, 0])
    color(flatui[3]) cube([15, 15, encoderBaseHeight]);
}

module encoderBaseSpace() {
    translate([-15/2, -15/2, -encoderBaseSpace])
    color(flatui[4]) cube([15, 15, encoderBaseSpace]);
}

module rotaryEncoder(cutout=false) {
    encoderScrew();
    
    if (cutout == false) {
        encoderKnob();
        encoderBase();
        encoderBaseSpace();
    }
}

rotaryEncoder();

/*rotaryEncoder();

translate([20, 0, 0])
rotaryEncoder(true);*/