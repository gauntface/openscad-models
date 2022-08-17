include <../../libs/flat-ui-colors.scad>;

pcbThickness = 1.57;
acrylicThickness = 3;

m3HoleD = 3.4;

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
switchZ = 1.4;
btnZ = 1;

caseLeftX = -5.822;
caseRightX = 47.822;

displayPCBX = 35.8;
displayPCBY = 33.4;
displayPCBZ = 6;

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

neoPixelHeaderX = pcbCoreX-header8x1X-0.2;
neoPixelHeaderY = pcbCoreY-header8x1Y-0.6;
neoPixelHeaderZ = -header8x1Z;

layoutPadding = pcbCoreX + 14;

screenEndY = pcbCoreY - displayPCBY - 1.4-1;

module partsEarHoles(h=pcbThickness) {
    earHoleD = 2.6;
    translate([earTipLeftX, earTipsY - 6.4, -h]) cylinder(h*3, d=earHoleD, true);
    translate([earTipRightX, earTipsY - 6.4, -h]) cylinder(h*3, d=earHoleD, true);
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
    translate([(pcbCoreX - displayPCBX) / 2, pcbCoreY - displayPCBY - 1.4, pcbThickness]) cube([displayPCBX, displayPCBY, displayPCBZ]);
    
    displayInnerX = 34.4;
    displayInnerY = 22.8;
    displayInnerZ = 6.4;
    
    // Currently not used but pulled from 3D Print Model
    // displayVisibleX = 32;
    // displayVisibleY = 20;
    translate([(pcbCoreX - displayInnerX) / 2, pcbCoreY - displayInnerY - 7.2, 0]) cube([displayInnerX, displayInnerY, displayInnerZ]);
}

module partLED(h = 1.8) {
    translate([6, 3.8, pcbThickness]) cube([5, 5, h]);
}

module partDPadSwitch() {
    cube([switchX, switchY, switchZ]);
    
    btnX = 2.4;
    btnY = 1.2;
    translate([(switchX - btnX)/2, (switchY - btnY)/2, switchZ]) cube([btnX, btnY, btnZ]);
}

module partDPad() {
    translate([pcbCoreX-18.2, 1, pcbThickness]) partDPadSwitch();

    translate([pcbCoreX-18.2, 8.4, pcbThickness]) partDPadSwitch();
    
    translate([pcbCoreX-6-switchX, 4.7, pcbThickness]) partDPadSwitch();
    
    translate([pcbCoreX-18.6-switchX, 4.7, pcbThickness]) partDPadSwitch();
}

module nuggetPCB(h=pcbThickness) {
    translate([0, 0, acrylicThickness - pcbThickness + 0.00001]) {
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
    space = 0.5;
    translate([s2HeadersX-space, s2HeadersBottomY-space, -h]) cube([header8x1Y + (space * 2), (header8x1X*2) + (space * 2), h * 3]);
    
    translate([s2HeadersX-space, s2HeadersTopY-space, -h]) cube([header8x1Y + (space * 2), (header8x1X*2) + (space * 2), h * 3]);
    
    translate([neoPixelHeaderX-space, neoPixelHeaderY-space, -h]) cube([header8x1X + (space * 2), header8x1Y + (space * 2), h * 3]);
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
    translate([0.4, 4.2, -16]) cylinder(100, d=m3HoleD, true);
    translate([44.8, 22, -16]) cylinder(100, d=m3HoleD, true);
    translate([21, 51.4, -16]) cylinder(100, d=m3HoleD, true);
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
    // TODO: CHECK WHAT THE DPAD SHOULD LOOK LIKE
    color(flatui[4]) union() {
        difference() {
            nuggetLayer(h);
            difference() {
                translate([0, 0, -h]) nuggetPCB(h=h*3);
                translate([caseLeftX-5,screenEndY-50+1,-h]) cube([53.644 + 10, 50, h * 3]);
            }
            
            translate([0, 0, -acrylicThickness * 5]) partLED(h = acrylicThickness * 10);
            translate([0, 0, -acrylicThickness * 5]) dpadButtons(h = acrylicThickness * 10);
        }
        barrierAddition();
    }
}

module nuggetScreenLayer(h=acrylicThickness, minusPCB = false) {
    color(flatui[6]) union() {
        difference() {
            nuggetLayer();
            if (minusPCB){translate([0, 0, -h]) nuggetPCB(h=h*3);}
            // Remove bottom section
            translate([caseLeftX-5,screenEndY-50,-h]) cube([53.644 + 10, 50, h * 3]);
        }
        if (minusPCB){
            translate([caseLeftX, screenEndY, 0]) cube([caseRightX - caseLeftX, 1, h]);
            barrierAddition(excludeBottom = true);
        }
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
    // dpadButtons();
    
    // translate([0, 0, 0]) nuggetScrewLayer();
    translate([0, 0, 3]) nuggetDPadLayer();
    translate([0, 0, 6]) nuggetScreenLayer(minusPCB=true);
    /* translate([0, 0, 9]) nuggetScreenLayer();
    translate([0, 0, -3]) nuggetLowerLayer();
    translate([0, 0, -6]) nuggetLowerLayer();
    translate([0, 0, -9]) nuggetBack();*/
}

module model() {
    caseLayers();
}

module layout() {
    nuggetScrewLayer();
    translate([layoutPadding, 0, 0]) nuggetDPadLayer();
    translate([layoutPadding * 2, 0, 0]) nuggetScreenLayer(minusPCB=true);
    translate([layoutPadding * 3, 0, 0]) nuggetScreenLayer();
    translate([layoutPadding * 4, 0, 0]) nuggetLowerLayer();
    translate([layoutPadding * 5, 0, 0]) nuggetLowerLayer();
    translate([layoutPadding * 6, 0, 0]) nuggetBack();
}

module laserDesign() {
    projection(cut = true) translate([-layoutPadding, 0, -acrylicThickness / 2]) nuggetScrewLayer();
    projection(cut = false) translate([0, 0, -acrylicThickness / 2]) layout();
}

model();