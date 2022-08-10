include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;
include <../../libs/flat-ui-colors.scad>;

thickness = 3;

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

switchX = 4;
switchY = 3;
switchZ = 2.5;

casePadding = 6;
lowerLayerCount = 6;
topLayerCount = 2;

m3HoleD = 3.4;

pcbCasePadding = 1;
caseEdgesWidth = (casePadding * 2) + pcbCasePadding;
frontZ = pcbH + switchZ + 1.5;

module pcbLED() {
    translate([0, 0, -0.5]) {
        color(flatui[1]) cube([2.5, 1.5, 0.5 + pcbH + 0.1]);
    }
}

module pcb(cutout = false) {
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

module shellLayer() {
    difference() {
        translate([-(caseEdgesWidth / 2), -(caseEdgesWidth / 2), 0]) cube([pcbX + caseEdgesWidth, pcbY + caseEdgesWidth, thickness]);
        
        translate([-1, -1, -50]) cube([pcbX + 2, pcbY + 2, 100]); 
    }
}

module shellLayers() {
    translate([0, 0, frontZ - thickness]) color(flatui[1]) shellLayer();
    translate([0, 0, frontZ - (thickness * 2)]) color(flatui[2]) shellLayer();
    translate([0, 0, frontZ - (thickness * 3)]) color(flatui[4]) shellLayer();
    translate([0, 0, frontZ - (thickness * 4)]) color(flatui[5]) shellLayer();
}

module clearLayer() {
    cube([pcbX + caseEdgesWidth, pcbY + caseEdgesWidth, thickness]);
}

module clearLayers() {
    translate([-(caseEdgesWidth / 2), -(caseEdgesWidth / 2), frontZ]) clearLayer();
    translate([-(caseEdgesWidth / 2), -(caseEdgesWidth / 2), frontZ - (thickness * 5)]) clearLayer();
}

module renderModel() {
    /* plateLayer();
    belowPlateLayers();
    abovePlateLayers();
    parts(false);*/
    
    // clearLayers();
    
    shellLayers();
    
    pcb();
}

renderModel();
