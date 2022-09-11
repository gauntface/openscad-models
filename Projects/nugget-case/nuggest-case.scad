include <../../libs/flat-ui-colors.scad>;
include <../../libs/screw-sizes.scad>;

pcbThickness = 1.57;
acrylicThickness = 3;

m2D = screwDiameter("m2");

earTipLeftX = 7.25;
earTipRightX = 34.75;
earTipsY = 59.6;

pcbCoreX = 42;
pcbCoreY = 48.6;

s2InsetX = 1.2;
s2MiniPCBTop = 3.6;

header8x1X = 2.4;
header8x1Y = 20.32;
header8x1Z = 8.5;

switchX = 6;
switchY = 3.6;
switchZ = 1.8;
btnZ = 1;

caseLeftX = -5.822;
caseRightX = 47.822;

displayPCBW = 35.8;
displayPCBD = 33.6;
displayPCBH = 6.1;

usbPortW = 7.6;
usbPortD = 8.8;
usbPortH = 3.4;
usbX = s2InsetX;
usbY = pcbCoreY - usbPortD - 14.2;
usbZ = -usbPortH-s2MiniPCBTop;

miniX = 34;
miniY = 25.4;
miniZ = 3.6;

miniYInset = 6.4;
s2HeadersX = 8;
s2HeadersBottomY = pcbCoreY-miniY-miniYInset;
s2HeadersTopY = pcbCoreY-miniYInset-(header8x1X*2);

neoPixelHeaderX = pcbCoreX-header8x1X-0.6;
neoPixelHeaderY = 47.6-header8x1Y;
neoPixelHeaderZ = -header8x1Z;

layoutPadding = pcbCoreX + 14;

ledWH = 4.6;
ledH = 1.8;
ledX = 6;
ledY = 9 - ledWH;

dpadCol1X = 17;
dpadCol2X = dpadCol1X + 0.4 + switchX;
dpadCol3X = dpadCol2X + 0.4 + switchX;

dpadRow1Y = 0.5;
dpadRow2Y = dpadRow1Y + 0.4 + switchY;
dpadRow3Y = dpadRow2Y + 0.4 + switchY;

screenEndY = 47.2-displayPCBD;

module partsEarHoles(h=pcbThickness) {
    holeY = earTipsY - 5.6 - (m2D/2);
    translate([earTipLeftX, holeY, -h]) cylinder(h*3, d=m2D, true);
    translate([earTipRightX, holeY, -h]) cylinder(h*3, d=m2D, true);
}

module partsNeoPixelHeader() {
    translate([neoPixelHeaderX, neoPixelHeaderY, neoPixelHeaderZ]) cube([header8x1X, header8x1Y, header8x1Z]);
}

module partsUSBPort() {
    translate([usbX, usbY, usbZ]) cube([usbPortW, usbPortD, usbPortH]);
}

module partsS2Mini() {
    translate([s2InsetX, pcbCoreY-miniY-miniYInset, -miniZ]) cube([miniX, miniY, miniZ]);
    
    // Double to account for male pins
    translate([s2HeadersX, s2HeadersBottomY, -header8x1Z-s2MiniPCBTop]) cube([header8x1Y, header8x1X*2, header8x1Z]);
    
    translate([s2HeadersX, s2HeadersTopY, -header8x1Z-s2MiniPCBTop]) cube([header8x1Y, header8x1X*2, header8x1Z]);
}

module partDisplay() {
    translate([(pcbCoreX - displayPCBW) / 2, pcbCoreY - displayPCBD - 1.4, pcbThickness]) cube([displayPCBW, displayPCBD, displayPCBH]);
    
    displayInnerX = 34.4;
    displayInnerY = 22.8;
    displayInnerZ = 6.4;
    
    // Currently not used but pulled from 3D Print Model
    // displayVisibleX = 32;
    // displayVisibleY = 20;
    translate([(pcbCoreX - displayInnerX) / 2, pcbCoreY - displayInnerY - 7.2, 0]) cube([displayInnerX, displayInnerY, displayInnerZ]);
}

module partLED(h = ledH) {
    translate([ledX, ledY, pcbThickness]) cube([ledWH, ledWH, h]);
}

module partDPadSwitch() {
    cube([switchX, switchY, switchZ]);
    
    btnX = 2.4;
    btnY = 1.2;
    translate([(switchX - btnX)/2, (switchY - btnY)/2, switchZ]) cube([btnX, btnY, btnZ]);
}

module partDPad() {    
    leftRightY = 8.2 - switchY;
    // UP
    translate([dpadCol2X, dpadRow3Y, pcbThickness]) partDPadSwitch();
    
    // Down
    translate([dpadCol2X, dpadRow1Y, pcbThickness]) partDPadSwitch();

    // Left
    translate([dpadCol1X, dpadRow2Y, pcbThickness]) partDPadSwitch();

    // Right
    translate([dpadCol3X, dpadRow2Y, pcbThickness]) partDPadSwitch();
}

module nuggetPCB(h=pcbThickness) {
    translate([0, 0, -pcbThickness]) {
        partsNeoPixelHeader();
        partsUSBPort();
        partsS2Mini();
        partDisplay();
        partLED();
        partDPad();
        
        color([0, 0, 0]) difference() {
            linear_extrude(height = h, center = false, convexity = 10, twist = 0)
            polygon(
                points=[
                    [0, 8.6],
                    [0, pcbCoreY],
                    [earTipLeftX, earTipsY],
                    [14.5, pcbCoreY],
                    [27.5, pcbCoreY],
                    [earTipRightX, earTipsY],
                    [pcbCoreX, pcbCoreY],
                    [pcbCoreX, 8.6],
                    [33.7, 0],
                    [8.3, 0],
                ]
            );
            
            partsEarHoles();
        }
    }
}

module usbSpace(h=acrylicThickness) {
    space = 2;
    translate([-9, usbY - space, -h]) cube([12, usbPortD + (space*2), h * 3]);
}

module backHeadersSpace(h=acrylicThickness) {
    // s2HeadersX
    space = 1;
    translate([s2HeadersX-space, s2HeadersBottomY-space, -h]) cube([header8x1Y + (space * 2), (header8x1X*2) + (space * 2), h * 3]);
    
    translate([s2HeadersX-space, s2HeadersTopY-space, -h]) cube([header8x1Y + (space * 2), (header8x1X*2) + (space * 2), h * 3]);
    
    translate([neoPixelHeaderX-space, neoPixelHeaderY-space, -h]) cube([header8x1X + (space * 2), header8x1Y + (space * 2), h * 3]);
}

module ledSpace(h = acrylicThickness) {
    space = 2;
    wh = ledWH + space;
    translate([ledX - (space/2), ledY - (space/2), -h]) cube([wh, wh, h * 3]);
}

module dpadSpace(h = acrylicThickness) {
    lrW = 21.2;
    lrH = 4.8;
    
    udW = 6.8;
    udH = 12.8;
    
    lrSwitchW = dpadCol3X - dpadCol1X + switchX;
    lrX = dpadCol1X - ((lrW - lrSwitchW) / 2);
    lrY = dpadRow2Y - ((lrH - switchY) / 2);
    
    udSwitchH = dpadRow3Y - dpadRow1Y + switchY;
    udX = dpadCol2X - ((udW - switchX) / 2);
    udY = dpadRow1Y - ((udH - udSwitchH) / 2);
    
    translate([lrX, lrY, -h]) cube([lrW, lrH, h * 3]);
    translate([udX, udY, -h]) cube([udW, udH, h * 3]);
}

module barrierAddition(h = acrylicThickness, excludeBottom=false) {
    // Bottom barrier
    if (!excludeBottom) {
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [0, 1.5],
                [42, 1.5],
                [33.7, 0],
                [8.3, 0],
            ]
        );
    }
    
    // Ear barrier
    difference() {
        union() {
            linear_extrude(height = h, center = false, convexity = 10, twist = 0)
            polygon(
                points=[
                    [0, 48.6],
                    [7.25, 59.6],
                    [14.5, 48.6],
                ]
            );
            
            linear_extrude(height = h, center = false, convexity = 10, twist = 0)
            polygon(
                points=[
                    [0+27.5, 48.6],
                    [7.25+27.5, 59.6],
                    [14.5+27.5, 48.6],
                ]
            );
        }
        screwHoles();
    }
}

module screwHoles() {
    partsEarHoles(h=100);
    translate([0.4, 4.2, -16]) cylinder(100, d=m2D, true);
    translate([44.8, 22, -16]) cylinder(100, d=m2D, true);
}

module nuggetLayer(h=acrylicThickness) {
    difference() {
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [caseLeftX, 6.258],
                [caseLeftX, 50.34],
                [7.25, 70.17],
                [17.637, 54.422],
                [24.363, 54.422],
                [34.75, 70.17],
                [caseRightX, 50.34],
                [caseRightX, 6.258],
                [36.170, caseLeftX],
                [5.830, caseLeftX],
            ]
        );
            screwHoles();
    }
}

module nuggetLowerLayer(h=acrylicThickness) {
    
    color(flatui[2]) union() {
        difference() {
            nuggetLayer(h);
            translate([0, 0, -h/2]) nuggetPCB(h=h*2);
            usbSpace(h=h*2);
        }
        
        barrierAddition();
    }
}

module nuggetScrewLayer(h=acrylicThickness) {
    color(flatui[1]) difference() {
        union() {
            difference() {
                nuggetLayer(h);
                translate([0, 0, -h]) nuggetPCB(h=h*3);
                usbSpace(h=h*2);
                partsEarHoles(h=h*3);
            }
            
            barrierAddition();
        }
        nuggetPCB(h=3);
    }
    
}

module nuggetUpperLayer(h=acrylicThickness) {
    color(flatui[3]) difference() {
        nuggetLayer(h);
        translate([0, 0, -h]) nuggetPCB(h=h*3);
    }
}

module nuggetDPadLayer(h=acrylicThickness) {
    color(flatui[4]) union() {
        difference() {
            nuggetLayer(h);
            difference() {
                translate([0, 0, -h]) nuggetPCB(h=h*3);
                translate([caseLeftX-5,screenEndY-50+1,-h]) cube([53.644 + 10, 50, h * 3]);
            }
            
            ledSpace();
            dpadSpace();
        }
        barrierAddition(excludeBottom = true);
    }
}

module nuggetScreenLayer(h=acrylicThickness) {
    color(flatui[6]) union() {
        difference() {
            nuggetLayer();
            // Remove bottom section
            translate([caseLeftX-5,screenEndY-50,-h]) cube([53.644 + 10, 50, h * 3]);
        }
    }
}

module nuggetScreenSpaceLayer(h = acrylicThickness) {
    ledXEnd = ledX + ledWH + 0.5;
    space = ((dpadCol1X - ledXEnd) / 2);
    coverX = ledXEnd + space;
    
    color(flatui[8]) union() {
        difference() {
            nuggetLayer();
            difference() {
                translate([0, 0, -h]) nuggetPCB(h=h*3);
                translate([-50 + coverX, -50 + screenEndY, -h]) cube([50, 50, h * 3]);
            }
            ledSpace();
            
            translate([coverX, -50 + screenEndY, -h]) cube([50, 50, h*3]);
            translate([-10, -50 + ledY - 0.5 - space, -h]) cube([50, 50, h*3]);
        }
        
        translate([caseLeftX, screenEndY, 0]) cube([caseRightX - caseLeftX, 1, h]);
        barrierAddition(excludeBottom = true);
        
    }
}

module nuggetBack(h=acrylicThickness) {
    color(flatui[7]) difference() {
        nuggetLayer(h);
        backHeadersSpace(h);
    }
}

module dpadButtons(h=acrylicThickness) {
    translate([16, 0, acrylicThickness+switchZ+btnZ]) {
        translate([7, 0.5, 0]) cube([7, 12, h]);
        translate([0, 4, 0]) cube([21, 5, h]);
    }
}

module caseLayers() {
    
    // translate([0, 0, 0]) nuggetScrewLayer();
    translate([0, 0, 3]) nuggetDPadLayer();
    translate([0, 0, 6]) nuggetScreenSpaceLayer();
    // translate([0, 0, 9]) nuggetScreenLayer();
    //translate([0, 0, -3]) nuggetLowerLayer();
    //translate([0, 0, -6]) nuggetLowerLayer();
    // translate([0, 0, -9]) nuggetBack();
    
    nuggetPCB();
}

module layout() {
    nuggetScrewLayer();
    translate([layoutPadding, 0, 0]) nuggetDPadLayer();
    translate([layoutPadding * 2, 0, 0]) nuggetScreenSpaceLayer();
    translate([layoutPadding * 3, 0, 0]) nuggetScreenLayer();
    translate([layoutPadding * 4, 0, 0]) nuggetLowerLayer();
    translate([layoutPadding * 5, 0, 0]) nuggetLowerLayer();
    translate([pcbCoreX + (layoutPadding * 6), 0, 0]) rotate([0, 180, 0]) nuggetBack();
}

module model() {
    caseLayers();
}

module laserDesign() {
    $fn=20;
    projection(cut = true) translate([-layoutPadding, 0, -acrylicThickness / 2]) nuggetScrewLayer();
    projection(cut = false) translate([0, 0, -acrylicThickness / 2]) layout();
}

model();