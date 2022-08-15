pcbThickness = 1.57;
acrylicThickness = 3;

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
    translate([7.77, 16.2, - h/2]) cube([23, 4.5, h * 2]);
    
    translate([7.77, 16.2 + 4.5 + 13.28, - h/2]) cube([23, 4.5, h * 2]);
    
    translate([36, 26.6, -h/2]) cube([6, 22, h * 2]);
}

module nuggetLowerLayer(h=acrylicThickness) {
    union() {
        difference() {
            nuggetLayer(h);
            translate([0, 0, -h/2]) nuggetPCB(h=h*2);
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
    union() {
        difference() {
            nuggetLayer(h);
            translate([0, 0, -h/2]) nuggetPCB(h=h*2);
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
    difference() {
        nuggetLayer(h);
        translate([0, 0, -h]) nuggetPCB(h=h*3);
    }
}

module nuggetBack(h=acrylicThickness) {
    difference() {
        nuggetLayer(h);
        backHeaders(h);
    }
}


// color([0.5, 0.5, 0.5]) nuggetPCB(h=pcbThickness);
// translate([0, 0, -(h*1.5)-pcbThickness]) backHeaders();

translate([0, 0, -3]) color([0, 0, 1]) nuggetScrewLayer();
translate([0, 0, -6]) color([0, 1, 0]) nuggetLowerLayer();
translate([0, 0, -9]) color([1, 1, 0]) nuggetLowerLayer();
translate([0, 0, -12]) color([1, 0, 0]) nuggetBack();

color([0, 1, 1]) nuggetUpperLayer();