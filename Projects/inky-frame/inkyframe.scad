include <../../libs/cherry-mx-switch.scad>;
include <../../libs/rotary-encoder-ACZ11BR1E.scad>;
include <../../libs/btn-1825910-6.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;
include <../../libs/flat-ui-colors.scad>;

thickness = 3;
keyCols = 3;
keyRows = 2;

pcbX = 131;
pcbY = 127;
pcbH = 1.6;
pcbPadding = 0.25;
pcbScreenX = 126;
pcbScreenY = 100;
pcbScreenZ = 1.5;
// Sloppy fixing of the screen can cause issues
pcbScreenXYPadding = 2;
pcbScreenZPadding = 0.25;

caseHPadding = 6;
lowerLayerCount = 6;
topLayerCount = 2;

m3HoleD = 3.4;

mcX = 17.6;
mcY = 33.6;
mcZ = 5.2;

usbCX = 8.8;
usbCY = 7.2;
usbCZ = 3.1;

module cherrymx(cutout) {
    if (cutout) {
        cherrymxPlate();
    } else {
        cherrymxSwitch();
    }
}

module cherrymxKeys(cutout = false) {
    row1Y = 70 - 35;
    row2Y = 70 - 54.5;
    col1X = 15.5;
    col2X = 35;
    col3X = 54.5;

    // Key 1
    translate([col1X, row1Y, cherrySwitchH]) cherrymx(cutout);

    // Key 2
    translate([col2X, row1Y, cherrySwitchH]) cherrymx(cutout);

    // Key 3
    translate([col3X, row1Y, cherrySwitchH]) cherrymx(cutout);

    // Key 4
    translate([col1X, row2Y, cherrySwitchH]) cherrymx(cutout);

    // Key 5
    translate([col2X, row2Y, cherrySwitchH]) cherrymx(cutout);

    // Key 6
    translate([col3X, row2Y, cherrySwitchH]) cherrymx(cutout);
}

module pcbLED() {
    translate([0, 0, -0.5]) {
        color(flatui[1]) cube([2.5, 1.5, 0.5 + pcbH + 0.1]);
    }
}

module pcb(cutout = false) {
    switchX = 4;
    switchY = 3;
    switchZ = 2.5;
    if (cutout == false) {
        difference() {
            union() {
                color(flatui[3]) cube([pcbX, pcbY, pcbH]);
                
                screenX = pcbScreenX + (pcbScreenXYPadding * 2);
                screenY = pcbScreenY + (pcbScreenXYPadding * 2);
                translate([(pcbX-screenX) / 2, 16 - pcbScreenXYPadding, pcbH]) {
                    color(flatui[4]) cube([screenX, screenY, pcbScreenZ]);
                }
                
                switchesY = 6.5;
                switchesXSpace = 19;
                
                ledsY = switchesY + switchY + 0.5;
                ledsXSpace = (switchX - 2.5) / 2;
                
                cX = (pcbX / 2) - (switchX / 2);
                translate([cX, switchesY, pcbH]) {
                    color(flatui[5]) cube([switchX, switchY, switchZ]);
                }
                translate([cX + ledsXSpace, ledsY, 0]) pcbLED();
                
                bX = cX - switchesXSpace - switchX;
                translate([bX, switchesY, pcbH]) {
                    color(flatui[5]) cube([switchX, switchY, switchZ]);
                }
                translate([bX + ledsXSpace, ledsY, 0]) pcbLED();
                
                aX = bX - switchesXSpace - switchX;
                translate([aX, switchesY, pcbH]) {
                    color(flatui[5]) cube([switchX, switchY, switchZ]);
                }
                translate([aX + ledsXSpace, ledsY, 0]) pcbLED();
                
                dX = cX + switchX + switchesXSpace;
                translate([dX, switchesY, pcbH]) {
                    color(flatui[5]) cube([switchX, switchY, switchZ]);
                }
                translate([dX + ledsXSpace, ledsY, 0]) pcbLED();
                
                eX = dX + switchX + switchesXSpace;
                translate([eX, switchesY, pcbH]) {
                    color(flatui[5]) cube([switchX, switchY, switchZ]);
                }
                translate([eX + ledsXSpace, ledsY, 0]) pcbLED();
                
                // Wifi LED
                translate([pcbX - 11 + (1.5 / 2), pcbY - 2 - 2.5, 0]) rotate([0, 0, 90]) pcbLED();
                
                // Status LED
                translate([pcbX - 22 + (1.5 / 2), pcbY - 2 - 2.5, 0]) rotate([0, 0, 90]) pcbLED();
            }
            
            translate([5, 5, 0]) {
                color(flatui[5]) cylinder(h=20, d=2.5, center=true);
            }
            
            translate([pcbX - 5, 5, 0]) {
                color(flatui[5]) cylinder(h=20, d=2.5, center=true);
            }
            
            translate([pcbX - 5, pcbY - 5, 0]) {
                color(flatui[5]) cylinder(h=20, d=2.5, center=true);
            }
            
            translate([5, pcbY - 5, 0]) {
                color(flatui[5]) cylinder(h=20, d=2.5, center=true);
            }
            
            translate([9, 11, 0]) {
                color(flatui[6]) cylinder(h=20, d=3, center=true);
            }
            
            translate([pcbX-9, 11, 0]) {
                color(flatui[6]) cylinder(h=20, d=3, center=true);
            }
        }
        
        // SDCard
        translate([pcbX - 20, 47, -2.5]) color(flatui[2]) cube([19, 15, 2.5]);
        
        // Micro USB
        translate([pcbX - 52, 25, -4]) color(flatui[4]) cube([53, 10, 4]);
        
        // Pin Headers
        translate([2.5, 15.5, -4]) color(flatui[2]) cube([8, 26, 4]);
        
        // Reset Button
        translate([(pcbX / 2) - (switchX / 2), 15, -switchZ]) color(flatui[2]) cube([switchX, switchY, switchZ]);
        
        // Power PST
        translate([36, 85, -5]) color(flatui[2]) cube([8, 6, 5]);
    }
}

module caseScrews() {
    layers = lowerLayerCount + topLayerCount + 1;
    totalHeight = (layers + 2) * thickness;
    offset = (caseHPadding / 2);

    xL = -offset - pcbPadding + 1;
    xR = pcbX + pcbPadding + offset - 1;

    yB = -offset -pcbPadding + 1;
    yT = pcbY + pcbPadding + offset  - 1;

    z = cherrySwitchH - ((lowerLayerCount + 2) * thickness);

    translate([xL, yB, z]) cylinder(totalHeight, d=m3HoleD, true);
    translate([xR, yB, z]) cylinder(totalHeight, d=m3HoleD, true);

    translate([xL, yT, z]) cylinder(totalHeight, d=m3HoleD, true);
    translate([xR, yT, z]) cylinder(totalHeight, d=m3HoleD, true);
}

module microController(cutout = false) {
    if (cutout == false) {
        translate([(pcbX - mcX) / 2, pcbY - mcY - 1, -mcZ-pcbH])
        color(flatui[4]) cube([mcX, mcY, mcZ]);

        translate([(pcbX - usbCX) / 2, pcbY - usbCY, -mcZ-pcbH-usbCZ])
        color(flatui[5]) cube([8.8, 7.2, 3.1]);
    }
}

module parts(cutout=false) {
    cherrymxKeys(cutout);

    translate([0, 0, -pcbH]) pcb(cutout);

    translate([61.5, 70 - 12.625, 0]) rotaryEncoder(cutout, 12);

    translate([5.75, 70 - 12.625, 0]) btn18625910();

    microController(cutout);

    if (cutout == false) {
        caseScrews();
    }
}

module partsExtrude() {
    screenSpaceX = 66;
    screenSpaceY = 20;
    translate([(pcbX - screenSpaceX)/2, 70 - 12.625 - (screenSpaceY / 2), - thickness])
    cube([screenSpaceX, screenSpaceY, thickness * 4]);
}

module caseLayer() {
    offset = -caseHPadding - pcbPadding;
    difference() {
        translate([offset, offset, 0])
        cube([pcbX + (2 * pcbPadding) + (2 * caseHPadding), pcbY + (2 * pcbPadding) + (2 * caseHPadding), thickness]);

        caseScrews();
    }
}

module plateLayer() {
    difference() {
        translate([0 , 0, cherrySwitchH - thickness])
        color(flatui[8]) caseLayer();

        partsExtrude();
        parts(true);
    }
}

module pcbLayer(withTeeth = false, cutoutUSB = false) {
    teethLengthM = 8;
    teethLengthS = 6;

    color(flatui[6])
    union() {
        difference() {
            caseLayer();


            translate([-pcbPadding, -pcbPadding, -nothing])
            cube([pcbX + (2 * pcbPadding), pcbY + (2 * pcbPadding), thickness + (nothing * 2)]);

            if (cutoutUSB == true) {
                usbCutoutX = usbCX + 4;
                usbCutoutY = caseHPadding + (thickness * 2);
                usbCutoutZ = thickness * 3;

                translate([(pcbX - usbCutoutX) / 2, pcbY - thickness, -thickness])
                cube([usbCutoutX, usbCutoutY, usbCutoutZ]);

            }
        }

        if (withTeeth) {
            // Bottom keypad teeth
            translate([25.25 - (thickness / 2), -pcbPadding, 0])
            cube([thickness, teethLengthM + pcbPadding, thickness]);

            translate([44.75 - (thickness / 2), -pcbPadding, 0])
            cube([thickness, teethLengthM + pcbPadding, thickness]);

            // Side teeth
            translate([-pcbPadding, (pcbY / 2), 0])
            cube([teethLengthS + pcbPadding, thickness, thickness]);

            translate([pcbX - teethLengthS, (pcbY / 2), 0])
            cube([teethLengthS + pcbPadding, thickness, thickness]);

            // Top Teeth
            translate([10.625 - (thickness / 2), pcbY - teethLengthS, 0])
            cube([thickness, teethLengthS + pcbPadding, thickness]);

            translate([53.875 - (thickness / 2), pcbY - teethLengthS, 0])
            cube([thickness, teethLengthS + pcbPadding, thickness]);
        }
    }
}

module belowPlateLayers() {
    difference() {
        translate([0, 0, cherrySwitchH - (thickness * 2)])
        color(flatui[0]) pcbLayer();
    }

    difference() {
        translate([0, 0, cherrySwitchH - (thickness * 3)])
        color(flatui[1]) pcbLayer(withTeeth = true);
    }

    for (i = [2:3]) {
        difference() {
            translate([0, 0, cherrySwitchH - (thickness * (i + 2))])
            color(flatui[i % 10]) pcbLayer(withTeeth = true, cutoutUSB = true);
        }
    }

    translate([0, 0, cherrySwitchH - (thickness * lowerLayerCount)])
    color(flatui[4]) caseLayer();
}

module controlLayer(cutout) {
    controlLayerY = 25.25 + caseHPadding;

    difference() {
        translate([-caseHPadding - pcbPadding, (pcbY + caseHPadding) - controlLayerY, 0])
        cube([pcbX + (2 * pcbPadding) + (2 * caseHPadding), controlLayerY + pcbPadding, thickness]);

        if (cutout) {
            partsExtrude();
        }
        caseScrews();
    }
}

module screenCoverLayer() {
    translate([0, 0, - (cherrySwitchH + (thickness * (topLayerCount - 1)))])
    difference() {
        translate([0, 0, cherrySwitchH + (thickness * (topLayerCount - 1))])
        color(flatui[3]) controlLayer(cutout=false);

        parts(true);
    }
}

module abovePlateLayers() {
    for (i = [0:topLayerCount-2]) {
        translate([0, 0, cherrySwitchH + (thickness * i)])
        color(flatui[i % 10]) controlLayer(cutout=true);
    }

    /*translate([0, 0, cherrySwitchH + (thickness * (topLayerCount - 1))])
    screenCoverLayer();*/
}

module layoutPieces() {
    xOffset = pcbX + (caseHPadding * 2) + (pcbPadding * 2) + thickness;
    // Bottom Layer
    caseLayer();

    // PCB surround layer
    translate([xOffset, 0, 0])
    pcbLayer();

    // PCB surround layer with teeth
    translate([xOffset * 2, 0, 0])
    pcbLayer(withTeeth = true);

    // PCB surround layer
    translate([xOffset * 3, 0, 0])
    pcbLayer(withTeeth = true, cutoutUSB = true);

    // Plate
    translate([xOffset * 4, 0, 0])
    plateLayer();

    // Screen surround
    translate([xOffset * 5, 0, 0])
    controlLayer(cutout = true);

    // Screen cover
    translate([xOffset * 6, 0, 0])
    screenCoverLayer();
}

module displayProjection() {
    projection() {
        layoutPieces();
    }
}

module renderModel() {
    /* plateLayer();
    belowPlateLayers();
    abovePlateLayers();
    parts(false);*/
    pcb();
}

renderModel();

// parts();
// displayProjection();