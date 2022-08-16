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

module partsEarHoles(h=pcbThickness) {
    earHoleD = 2.6;
    translate([earTipLeftX, earTipsY - 6.4, -h]) cylinder(h*3, d=earHoleD, true);
    translate([earTipRightX, earTipsY - 6.4, -h]) cylinder(h*3, d=earHoleD, true);
}

module partsNeoPixelHeader() {
    translate([0.2, pcbCoreY-header8x1Y-0.6, -header8x1Z]) cube([header8x1X, header8x1Y, header8x1Z]);
}

module partsUSBPort() {
    usbPortX = 7.6;
    usbPorty = 8.8;
    usbPortz = 3.4;
    translate([pcbCoreX-usbPortX-s2InsetX, pcbCoreY -usbPorty - 14.2, -usbPortz-s2MiniPCBTop]) cube([usbPortX, usbPorty, usbPortz]);
}

module partsS2Mini() {
    miniX = 34;
    miniY = 25.4;
    miniZ = 3.6;
    
    miniYInset = 6.4;
    
    translate([pcbCoreX-miniX-s2InsetX, pcbCoreY-miniY-miniYInset, -miniZ]) cube([miniX, miniY, miniZ]);
    
    // Double to account for male pins
    translate([pcbCoreX-header8x1Y-8, pcbCoreY-miniY-miniYInset, -header8x1Z-s2MiniPCBTop]) cube([header8x1Y, header8x1X*2, header8x1Z]);
    
    translate([pcbCoreX-header8x1Y-8, pcbCoreY-miniYInset-(header8x1X*2), -header8x1Z-s2MiniPCBTop]) cube([header8x1Y, header8x1X*2, header8x1Z]);
}

module partDisplay() {
    displayPCBX = 35.8;
    displayPCBY = 33.4;
    displayPCBZ = 6;
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
    translate([0, 0, 0]) {
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

module nuggetUSBPort(h=acrylicThickness) {
    translate([-9, 8.6+15, -h/2]) cube([12, 14, h * 2]);
}

module nuggetLayer(h=acrylicThickness) {
    linear_extrude(height = h, center = false, convexity = 10, twist = 0)
    polygon(
        points=[
            [-5.822, 6.258],
            [-5.822, 50.34],
            [7.25, 70.17],
            [17.637, 54.422],
            [24.363, 54.422],
            [34.75, 70.17],
            [47.822, 50.34],
            [47.822, 6.258],
            [36.170, -5.822],
            [5.830, -5.822],
        ]
    );
}

module backHeaders(h=acrylicThickness) {
    translate([7.77, 16.2, - h/2]) cube([23, 4.5, h]);
    
    translate([7.77, 16.2 + 4.5 + 13.28, - h/2]) cube([23, 4.5, h * 2]);
    
    translate([36, 26.6, -h/2]) cube([6, 22, h * 2]);
}

module nuggetLowerLayer(h=acrylicThickness) {
    color(flatui[2]) union() {
        difference() {
            nuggetLayer(h);
            translate([0, 0, -h/2]) nuggetPCB(h=h*2);
            nuggetUSBPort(h=h*2);
        }
        
        // Bottom barrier
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [0, 1.5],
                [42, 1.5],
                [33.7, 0],
                [8.3, 0],
            ]
        );
        
        // Ear barrier
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [0, 48.6],
                [7.25, 59.6],
                [14.5, 48.6],
                [13, 48.6],
                [7.25, 58.1],
                [1.5, 48.6],
            ]
        );
        
        linear_extrude(height = h, center = false, convexity = 10, twist = 0)
        polygon(
            points=[
                [0+27.5, 48.6],
                [7.25+27.5, 59.6],
                [14.5+27.5, 48.6],
                [13+27.5, 48.6],
                [7.25+27.5, 58.1],
                [1.5+27.5, 48.6],
            ]
        );
    }
}

module nuggetScrewLayer(h=acrylicThickness) {
    nuggetPCB();
    // TODO: Need to cut down into plastic for this.
    color(flatui[1]) difference() {
        union() {
            difference() {
                nuggetLayer(h);
                translate([0, 0, -h]) nuggetPCB(h=h*3);
                nuggetUSBPort(h=h*2);
                partsEarHoles(h=h*3);
            }
            
            // Bottom barrier
            linear_extrude(height = h, center = false, convexity = 10, twist = 0)
            polygon(
                points=[
                    [0, 1.5],
                    [42, 1.5],
                    [33.7, 0],
                    [8.3, 0],
                ]
            );
            
            // Ear barrier
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
        partsEarHoles(h=h*3);
        nuggetPCB();
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
    color(flatui[4]) difference() {
        nuggetLayer(h);
        difference() {
            translate([0, 0, -h]) nuggetPCB(h=h*3);
            translate([-1, -1, -h*2]) cube([44, 17.6, h*5]);
        }
        
        translate([0, 0, -acrylicThickness * 5]) partLED(h = acrylicThickness * 10);
        translate([0, 0, -acrylicThickness * 5]) dpadButtons(h = acrylicThickness * 10);
    }
}

module nuggetScreenLayer(h=acrylicThickness, minusPCB = false) {
    // partDisplay();
    
    color(flatui[6]) difference() {
        nuggetLayer();
        translate([-5.822-5,-5.822-4,-h]) cube([53.644 + 10, 4.6 + 18.6, h * 3]);
        if (minusPCB){translate([0, 0, -h]) nuggetPCB(h=h*3);}
    }
}

module nuggetBack(h=acrylicThickness) {
    color(flatui[7]) difference() {
        nuggetLayer(h);
        backHeaders(h);
    }
}

module dpadButtons(h=acrylicThickness) {
    // TODO: Position the DPAD
    translate([16, 0, pcbThickness+switchZ+btnZ]) {
        translate([7, 0.5, 0]) cube([7, 12, h]);
        translate([0, 4, 0]) cube([21, 5, h]);
    }
}

module caseLayers() {
    dpadButtons();
    
    translate([0, 0, -3]) nuggetScrewLayer();
    
    /**translate([0, 0, 9]) nuggetScreenLayer();
    translate([0, 0, 6]) nuggetScreenLayer(minusPCB=true);
    translate([0, 0, 3]) nuggetDPadLayer();
    translate([0, 0, 0]) nuggetUpperLayer();
    translate([0, 0, -acrylicThickness]) nuggetScrewLayer();*/
    
    
    /** translate([0, 0, -6]) nuggetLowerLayer();
    translate([0, 0, -9]) nuggetLowerLayer();
    
    
    translate([0, 0, -12]) nuggetBack();*/
}

/* difference() {
    caseLayers();
    translate([2.2, 2.2, -16]) cylinder(30, d=m3HoleD, true);
    translate([44.8, 28.6, -16]) cylinder(30, d=m3HoleD, true);
    translate([21, 51.4, -16]) cylinder(30, d=m3HoleD, true);
}*/

// TODO: Add some ventilation?
// TODO: Add Lanyard?



caseLayers();
// nuggetPCB();