include <../../libs/flat-ui-colors.scad>;
include <../../libs/screw-sizes.scad>;

pcbThickness = 1.57;
acrylicThickness = 3;

m2D = screwDiameter("m2");

catHeight = 59.098;
caseLayerSpace = 2;

/** 
 *
 * PARTS
 *
 */
module partsEarHoles(h=pcbThickness) {
    translate([7.35, 51.998, -h]) cylinder(h*3, d=m2D, true);
    translate([34.85, 51.998, -h]) cylinder(h*3, d=m2D, true);
}

ledWD = 5.101;
ledH = 1.8;
ledX = 6.419;
ledY = catHeight-49.947-ledWD;
module partLED() {
    color([83/255, 92/255, 104/255]) translate([ledX, ledY, pcbThickness]) cube([ledWD, ledWD, ledH]);
}

displayW = 35.520;
displayD = 33.620;
displayH = 6.1;
displayX = 3.339;
displayY = catHeight-11.748-displayD;
module partDisplay() {
    color([104/255, 109/255, 224/255]) translate([displayX, displayY, pcbThickness]) cube([displayW, displayD, displayH]);
}

header8x1W = 2.66;
header8x1D = 20.498;
header8x1H = 8.5;
neoPixelHeaderX = 39.013;
neoPixelHeaderY = catHeight-11.736-header8x1D;
neoPixelHeaderZ = -header8x1H;
module partNeoPixelHeader() {
    color([83/255, 92/255, 104/255]) translate([neoPixelHeaderX, neoPixelHeaderY, neoPixelHeaderZ]) cube([header8x1W, header8x1D, header8x1H]);
}

dpadSwitchW = 6.239;
dpadSwitchD = 3.742;
dpadSwitchH = 2.8;
dpadCol1X = 17.404;
dpadCol2X = 23.691;
dpadCol3X = 29.914;
dpadRow1Y = catHeight-50.371;
dpadRow2Y = catHeight-54.224;
dpadRow3Y = catHeight-58.054;
module partDpad() {
    c = [246/255, 229/255, 141/255];
    // Left
    color(c) translate([dpadCol1X, dpadRow2Y, pcbThickness]) cube([dpadSwitchW,dpadSwitchD,dpadSwitchH]);
    // Right
    color(c) translate([dpadCol3X, dpadRow2Y, pcbThickness]) cube([dpadSwitchW,dpadSwitchD,dpadSwitchH]);
    // Down
    color(c) translate([dpadCol2X, dpadRow1Y, pcbThickness]) cube([dpadSwitchW,dpadSwitchD,dpadSwitchH]);
    // Up
    color(c) translate([dpadCol2X, dpadRow3Y, pcbThickness]) cube([dpadSwitchW,dpadSwitchD,dpadSwitchH]);
}

s2MiniW = 34;
s2MiniD = 25.4;
s2MiniH = 3.6;
s2MiniX = 1.2;
s2MiniY = 17;

s2HeadersX = 8;
s2HeadersBottomY = s2MiniY;
s2HeadersTopY = s2MiniY+s2MiniD-(header8x1W*2);

s2USBW = 7.5;
s2USBD = 8.8;
s2USBH = 3.2;
s2USBY = s2MiniY + ((s2MiniD-s2USBD)/2);
module partsS2Mini() {
    color([224/255, 86/255, 253/255]) translate([s2MiniX, s2MiniY, -s2MiniH]) cube([s2MiniW, s2MiniD, s2MiniH]);
    
    // Double to account for male pins
    color([190/255, 46/255, 221/255]) translate([s2HeadersX, s2HeadersBottomY, -header8x1H-s2MiniH]) cube([header8x1D, header8x1W*2, header8x1H]);
    
    color([190/255, 46/255, 221/255]) translate([s2HeadersX, s2HeadersTopY, -header8x1H-s2MiniH]) cube([header8x1D, header8x1W*2, header8x1H]);
    
    color([190/255, 46/255, 221/255]) translate([s2MiniX, s2USBY, -s2USBH-s2MiniH]) cube([s2USBW, s2USBD, s2USBH]);
}

/** 
 *
 * PCB
 *
 */
module pcb(h=pcbThickness) {
    color([0, 0, 0]) difference() {
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [8.4, 0],
                [33.8, 0],
                [42.098, 7.998],
                [42.098, 47.998],
                [34.849, 58.999],
                [27.6, 47.998],
                [14.6, 47.998],
                [7.348, 58.999],
                [0.099, 47.998],
                [0.099, 7.998],
            ]
        );
        
        partsEarHoles();
    }
    
    partLED();
    partDisplay();
    partNeoPixelHeader();
    partDpad();
    partsS2Mini();
}

/** 
 *
 * Space
 *
 */
module spaceLED(h=acrylicThickness) {
    space = 2;
    hs = space/2;
    translate([ledX-hs, ledY-hs, -h]) cube([ledWD+space, ledWD+space, h*3]);
}

module spaceDisplay(h=acrylicThickness) {
    space = 1.5;
    hs = space/2;
    translate([displayX-hs, displayY-(hs/2), -h]) cube([displayW+space, displayD+hs, h*3]);
}

module spaceRightScrew(h=acrylicThickness) {
    translate([42.098+1.5, catHeight-52.375+12, -h]) cylinder(h*3, d=m2D, true);
}

module spacePcb(h=acrylicThickness, includeEars=false) {
    translate([0, 0, -h]) linear_extrude(height = h*3, center = false, convexity = 10, twist = 0) union() {
        polygon(
            points=[
                [8.299, catHeight-59.348], // bottom left
                [33.901, catHeight-59.348],
                [42.348, catHeight-51.206],
                [42.348, catHeight-11.025],
                [27.465, catHeight-10.850],
                [14.735, catHeight-10.850],
                [-0.151, catHeight-11.025],
                [-0.151, catHeight-51.206],
            ]
        );

        if (includeEars) {
            // Right Ear
            polygon(
                points=[
                    [27.465, catHeight-10.850],
                    [34.849, catHeight--0.355],
                    [42.348, catHeight-11.025],
                ]
            );
            
            // Left Ear
            polygon(
                points=[
                    [-0.151, catHeight-11.025],
                    [7.348, catHeight--0.355],
                    [14.735, catHeight-10.850],
                ]
            );
        }
    }
}

module spaceBottomRidge(h=acrylicThickness) {
    linear_extrude(height = h, center = false, convexity = 10, twist = 0)
    polygon(
        points=[
            [8, -0.5],
            [35, -0.5],
            [37, 1.5],
            [6, 1.5],
        ]
    );
}

module usbSpace(h=acrylicThickness) {
    space = 4;
    hs = space / 2;
    translate([-10, s2USBY-hs, -h]) cube([15, s2USBD + space, h * 3]);
}

module caseScrews() {
    translate([-0.151-3, s2USBY-6, -acrylicThickness*10]) cylinder(acrylicThickness*20, d=m2D, true);
    translate([42.348+3, catHeight-51.206+20.0905, -acrylicThickness*10]) cylinder(acrylicThickness*20, d=m2D, true);
}

/** 
 *
 * Case Layer
 *
 */
module caseLayer(h=acrylicThickness) {
    difference() {
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [5.879, catHeight-65.348], // Bottom left
                [36.322, catHeight-65.348],
                [48.348, catHeight-53.756],
                [48.348, catHeight-9.226],
                [34.849, catHeight--11.260],
                [24.233, catHeight-4.850],
                [17.966, catHeight-4.850],
                [7.348, catHeight--11.258],
                [-6.151, catHeight-9.226],
                [-6.151, catHeight-53.757],
            ]
        );
        
        partsEarHoles();
        caseScrews();
    }
}

/** 
 *
 * Layers
 *
 */
module layerDpad(h=acrylicThickness) {
    padding = 0.5;
    paddingDouble = padding * 2;
    
    color(flatui[4]) difference() {
        caseLayer(h);
        
        // Left
        translate([dpadCol1X-padding, dpadRow2Y-padding, -h])
            cube([dpadSwitchW+paddingDouble, dpadSwitchD+paddingDouble, h*3]);
        // Right
        translate([dpadCol3X-padding, dpadRow2Y-padding, -h])
            cube([6.239+paddingDouble, 3.742+paddingDouble, h*3]);
        // Down
        translate([dpadCol2X-padding, dpadRow3Y-padding, -h])
            cube([6.239+paddingDouble, 3.742+paddingDouble, h*3]);
        // Up
        translate([dpadCol2X-padding, dpadRow1Y-padding, -h])
            cube([6.239+paddingDouble, 3.742+paddingDouble, h*3]);
        
        spaceLED();
        spaceDisplay();
    }
}

module layerScreenCover(h=acrylicThickness) {
    space=1;
    color(flatui[5]) difference() {
        caseLayer(h);
        translate([-10, displayY-space-50, -h]) cube([80, 50, h*3]);
    }
}

module layerAbovePCB(h=acrylicThickness) {
    color(flatui[3]) union() {
        difference() {
            caseLayer(h);
            spacePcb();
        }
        translate([-0.401, ledY+ledWD, 0]) cube([4, h, h]);
        translate([42.598-4, ledY+ledWD, 0]) cube([4, h, h]);
    }
}

module layerPCBScrew(h=acrylicThickness) {
    color(flatui[1]) difference() {
        union() {
            difference() {
                caseLayer(h);
                spacePcb();
            }
            spaceBottomRidge();
        }
        usbSpace();
        translate([0, 0, 2]) spacePcb(h=1, includeEars = true);
    }
}

module model() {
    translate([0, 0, acrylicThickness]) layerScreenCover();
    layerDpad();
    translate([0, 0, -acrylicThickness]) layerAbovePCB();
    translate([0, 0, -acrylicThickness*2]) layerPCBScrew();
    translate([0, 0, -pcbThickness-displayH + 3]) pcb();
    
    // spacePcb(includeEars=false);
}

layoutPadding = 60;
module layout() {
    
    layerPCBScrew();
    translate([layoutPadding*1, 0, 0]) layerScreenCover();
    translate([layoutPadding*2, 0, 0]) layerDpad();
    translate([layoutPadding*3, 0, 0]) layerAbovePCB();
}

module laserDesign() {
    $fn=20;
    projection(cut = true) translate([-layoutPadding, 0, -acrylicThickness / 2]) layerPCBScrew();
    projection(cut = false) translate([0, 0, -acrylicThickness / 2]) layout();
}

laserDesign();