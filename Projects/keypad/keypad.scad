include <../../libs/cherry-mx-switch.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;
include <../../libs/flat-ui-colors.scad>;
include <../../libs/rotary-encoder.scad>;

thickness = 3;
casePadding = 5;

switchPadding = 1.5;
switchColCount = 3;
switchRowCount = 2;

screenWidthX = 38.2;
screenDepthY = 12.2;
screenEncoderPadding = 8;
encoderSwitchPadding = 6;

height = 34 + (thickness * 2);

widthX = encoderBaseXY + screenEncoderPadding + screenWidthX + (casePadding * 2) + (thickness * 2);
depthY = encoderBaseXY + encoderSwitchPadding + (topXY * switchRowCount) + (switchPadding * (switchRowCount - 1)) + (casePadding * 2) + (thickness * 2);

headphoneLength = 34;
headphoneRim = 2;
headphoneD = 7.8;
headphoneNutD = 12;

nothing = 0.1;

lrTeethSize = [thickness, depthY - (thickness * 2), height - (thickness * 2)];
lrTeethOpts = [
    ["bottomCount", 2],    
    ["bottomSize", 5],
    ["bottomHeight", thickness],
    ["bottomSpaceBetween", false],
    ["bottomPadding", 0.1],

    ["topCount", 2],    
    ["topSize", 5],
    ["topHeight", thickness],
    ["topSpaceBetween", false],
    ["topPadding", 0.1],

    ["leftCount", 2],    
    ["leftSize", 4],
    ["leftHeight", thickness],
    ["leftSpaceBetween", false],

    ["rightCount", 2],    
    ["rightSize", 4],
    ["rightHeight", thickness],
    ["rightSpaceBetween", false],
];

fbTeethSize = [thickness, widthX, height - (thickness * 2)];
fbTeethOpts=[
    ["bottomCount", 2],    
    ["bottomSize", 5],
    ["bottomHeight", thickness],
    ["bottomSpaceBetween", false],
    ["bottomPadding", 0.1],

    ["topCount", 2],    
    ["topSize", 5],
    ["topHeight", thickness],
    ["topSpaceBetween", false],
    ["topPadding", 0.1],
];

tbPadding = 6;
tbSize = [widthX + tbPadding, depthY + tbPadding, thickness];

module frontSide() {
    difference() {
        translate([widthX / 2, thickness / 2, (height / 2)])
        rotate([0, 0, 90])
        teeth(size=fbTeethSize, opts=fbTeethOpts);
        
        parts();
        joints();
    }
}

module backSide() {
    difference() {
        translate([widthX / 2, depthY - (thickness / 2), (height / 2)])
        rotate([0, 0, 90])
        teeth(size=fbTeethSize, opts=fbTeethOpts);

        parts();
        joints();
    }
}

module leftSide() {
    difference() {
        translate([thickness/ 2, depthY / 2, (height / 2)])
        teeth(size=lrTeethSize, opts=lrTeethOpts);

        frontSide();
        backSide();
        parts();
        joints();
    }
}

module rightSide() {
    difference() {
        translate([widthX - (thickness/ 2), depthY / 2, (height / 2)])
        teeth(size=lrTeethSize, opts=lrTeethOpts);

        frontSide();
        backSide();
        parts();
        joints();
    }
}

module topSide() {
    difference() {
        translate([-(tbPadding / 2), -(tbPadding / 2), height - thickness])
        cube(tbSize);

        parts(cutout=true);
        joints();
        leftSide();
        rightSide();
        frontSide();
        backSide();
    }
}

module bottomSide() {
    difference() {
        translate([-(tbPadding / 2), -(tbPadding / 2), 0])
        cube(tbSize);
        
        leftSide();
        rightSide();
        frontSide();
        backSide();
        parts(cutout=true);
        joints();
    }
}

module headphoneJack() {
    rotate([90, 0, 90])  {
        cylinder(h=headphoneLength, d=headphoneD, center=false);
    }
    headphoneNutW = 2;
    translate([headphoneRim + thickness + (headphoneNutW / 2) + nothing, 0, 0])
    cube([headphoneNutW, headphoneNutD, headphoneNutD], center=true);
}

module switchRow(padding, cutout=false) {
    translate([0, 0, height]) {
        if (cutout) {
            cherrymxPlate();
        } else {
            cherrymxSwitch();
        }
    }
    
    translate([topXY + padding, 0, height]) {
        if (cutout) {
            cherrymxPlate();
        } else {
            cherrymxSwitch();
        }
    }
    
    translate([(topXY + padding) * 2, 0, height]) {
        if (cutout) {
            cherrymxPlate();
        } else {
            cherrymxSwitch();
        }
    }
}

module screen() {
    color(flatui[7]) cube([screenWidthX, screenDepthY, 3.4]);
}

module parts(cutout=false) {
    switchDepthY = (topXY * switchRowCount) + (switchPadding * (switchRowCount - 1));
    encoderSwitchDepthY = encoderBaseXY + encoderSwitchPadding + switchDepthY;
    
    switchX = ((widthX - ((topXY * switchColCount) + (switchPadding * (switchColCount - 1)))) / 2) + (topXY / 2);
    switchY = (topXY / 2) + ((depthY - encoderSwitchDepthY) / 2);
    translate([switchX, switchY, 0]) {
        switchRow(switchPadding, cutout);
    }
    
    translate([switchX, switchY + topXY + switchPadding, 0]) {
        switchRow(switchPadding, cutout);
    }
    
    
    screenEnocderWidthX = screenWidthX + screenEncoderPadding + encoderBaseXY;
    encoderX = (encoderBaseXY / 2) + ((widthX - screenEnocderWidthX) / 2);
    encoderY = (encoderBaseXY / 2) + ((depthY - encoderSwitchDepthY) / 2) + switchDepthY + encoderSwitchPadding;
    translate([encoderX, encoderY, height - encoderBaseHeight - thickness - 0.5])
    rotaryEncoder(cutout);
    
    screenX = ((widthX - screenEnocderWidthX) / 2) + encoderBaseXY + screenEncoderPadding;
    screenY = ((depthY - encoderSwitchDepthY) / 2) + switchDepthY + encoderSwitchPadding + ((encoderBaseXY - screenDepthY) / 2);
    translate([screenX, screenY, height - thickness - 3.4 - nothing])
    screen();

    translate([widthX - 14 - thickness - 4, depthY, 14 + ((height - 28) / 2)]) {
        union() {
            rotate([90, 0, 0])
            cylinder(h = 32, r = 11);
            
            translate([0, 2.5, 0])
            rotate([90, 0, 0])
            cylinder(h = 2.5, r = 14);
        }
    }
}

module joints() {
    y = depthY / 2;
    leftX = thickness / 2;
    rightX = widthX - (thickness / 2);
    topZ = height - thickness;
    bottomZ = thickness;
    
    // Top Left
    translate([leftX, y, topZ])
    rotate([180, 0, 90])
    createTJoint(th=thickness, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Top Right
    translate([rightX, y, topZ])
    rotate([180, 0, 90])
    createTJoint(th=thickness, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom Left
    translate([leftX, y, bottomZ])
    rotate([0, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom Right
    translate([rightX,y, bottomZ])
    rotate([0, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
}

module displayModel() {
    color(flatui[0]) leftSide();
    color(flatui[1]) rightSide();
    
    color(flatui[2]) frontSide();
    color(flatui[3]) backSide();
    
    color(flatui[4]) topSide();
    color(flatui[5]) bottomSide();
}

module layoutPieces() {
    /* translate([0, 0, -thickness / 2])
    rotate([90, 0, 0])
    leftSide();
    
    translate([0, height + thickness, thickness / 2])
    rotate([90, 0, 0])
    translate([0, -widthX, 0])
    rightSide();
    
    translate([depthY + thickness, 0, thickness / 2])
    rotate([90, 0, 0])
    rotate([0, 0, -90])
    frontSide();
    
    translate([depthY + thickness, height + thickness, -thickness / 2])
    rotate([90, 0, 0])
    rotate([0, 0, -90])
    translate([-depthY, 0, 0])
    backSide();
    
    //translate([depthY + tbPadding + thickness, height + tbPadding + thickness, -height + (thickness / 2)])
    translate([depthY + tbPadding + depthY + tbPadding + thickness, height + tbPadding + thickness, -height + (thickness / 2)])
    rotate([0, 0, 90])
    topSide();
    
    translate([depthY + tbPadding - 1, height + tbPadding + thickness, -thickness / 2])
    rotate([0, 0, 90])
    bottomSide();*/
}

module displayProjection() {
    projection() {
        layoutPieces();
    }
}

displayModel();
parts();

// displayProjection();