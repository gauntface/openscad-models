include <../../libs/flat-ui-colors.scad>;

pcbThickness = 1.57;
acrylicThickness = 3;

m3HoleD = 3.4;

module nuggetPCB(h=pcbThickness) {
    linear_extrude(height = h, center = false, convexity = 10, twist = 0)
    polygon(
        points=[
            [0, 8.6],
            [0, 48.6],
            [7.25, 59.6],
            [14.5, 48.6],
            [27.5, 48.6],
            [34.75, 59.6],
            [42, 48.6],
            [42, 8.6],
            [33.7, 0],
            [8.3, 0],
        ]
    );
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
    // TODO: CHECK IF THIS IS CORRECT - I GUESSED
    // TODO: CHECK THE HOLE SIZE
    
    color(flatui[1]) union() {
        difference() {
            nuggetLayer(h);
            translate([0, 0, -h/2]) nuggetPCB(h=h*2);
            nuggetUSBPort(h=h*2);
            translate([7.25, 59.1, 0]) cylinder(30, d=m3HoleD, true);
            translate([7.25+27.5, 59.1, 0]) cylinder(30, d=m3HoleD, true);
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
}

module nuggetUpperLayer(h=acrylicThickness) {
    color(flatui[3]) difference() {
        nuggetLayer(h);
        translate([0, 0, -h]) nuggetPCB(h=h*3);
    }
}

module nuggetDPadLayer(h=acrylicThickness) {
    // partDisplay();
    
    // TODO: CHECK WHAT THE DPAD SHOULD LOOK LIKE
    color(flatui[4]) difference() {
        nuggetLayer(h);
        difference() {
            translate([0, 0, -h]) nuggetPCB(h=h*3);
            translate([-1, -1, -h*2]) cube([44, 17.6, h*5]);
        }
        
        // TODO: Position the LED Cover
        translate([5, 5, -h]) cube([6.5, 6.5, h * 3]);
        
        // TODO: Position the DPAD
        translate([20, 0, 0]) {
            translate([7, 0, -h]) cube([7, 14, h * 3]);
            translate([0, 4.5, -h]) cube([21, 5, h * 3]);
        }
    }
}

module nuggetScreenLayer(h=acrylicThickness) {
    // partDisplay();
    
    color(flatui[6]) difference() {
        nuggetLayer();
        translate([-5.822-5,-5.822-4,-h]) cube([53.644 + 10, 5.822 + 18.6, h * 3]);
    }
}

module nuggetBack(h=acrylicThickness) {
    color(flatui[7]) difference() {
        nuggetLayer(h);
        backHeaders(h);
    }
}

module partDisplay() {
    translate([5, 18.6, 0]) cube([32, 20, 10]);
}

module caseLayers() {
    translate([0, 0, -3]) nuggetScrewLayer();
    translate([0, 0, -6]) nuggetLowerLayer();
    translate([0, 0, -9]) nuggetLowerLayer();
    translate([0, 0, 0]) nuggetUpperLayer();
    translate([0, 0, 3]) nuggetDPadLayer();
    translate([0, 0, 6]) nuggetScreenLayer();
    translate([0, 0, -12]) nuggetBack();
}

difference() {
    caseLayers();
    translate([2.2, 2.2, -16]) cylinder(30, d=m3HoleD, true);
    translate([44.8, 28.6, -16]) cylinder(30, d=m3HoleD, true);
    translate([21, 51.4, -16]) cylinder(30, d=m3HoleD, true);
}
// TODO: Add some ventilation?
// TODO: Add Lanyard?