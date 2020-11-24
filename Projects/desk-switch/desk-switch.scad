include <../../libs/cherry-mx-switch.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;

thickness = 3;

height = 22 + (thickness * 2);
depthX = 38 + (thickness * 2);
widthY = 40 + (thickness * 2);

headphoneLength = 34;
headphoneRim = 2;
headphoneD = 7.8;
headphoneNutD = 12;

nothing = 0.1;

lrTeethSize = [thickness, depthX - (thickness * 2), height - (thickness * 2)];
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

fbTeethSize = [thickness, widthY, height - (thickness * 2)];
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
tbSize = [depthX + tbPadding, widthY + tbPadding, thickness];

module leftSide() {
    difference() {
        translate([depthX / 2, thickness / 2, (height / 2)])
        rotate([0, 0, 90])
        teeth(size=lrTeethSize, opts=lrTeethOpts);
        
        parts();
        joints();
    }
}

module rightSide() {
    difference() {
        translate([depthX / 2, widthY - (thickness / 2), (height / 2)])
        rotate([0, 0, 90])
        teeth(size=lrTeethSize, opts=lrTeethOpts);

        parts();
        joints();
    }
}

module frontSide() {
    difference() {
        translate([thickness/ 2, widthY / 2, (height / 2)])
        teeth(size=fbTeethSize, opts=fbTeethOpts);

        leftSide();
        rightSide();
        parts();
        joints();
    }
}

module backSide() {
    difference() {
        translate([depthX - (thickness/ 2), widthY / 2, (height / 2)])
        teeth(size=fbTeethSize, opts=fbTeethOpts);

        leftSide();
        rightSide();
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

module parts(cutout=false) {
    padding = 2;
    translate([-headphoneRim, (headphoneNutD / 2) + thickness + padding, (height / 2)]) {
        headphoneJack();
    }

    avSpace = widthY - (thickness * 2) - headphoneNutD - padding;
    switchY = headphoneNutD + thickness + padding + (avSpace / 2);
    translate([depthX / 2, switchY, height]) {
        if (cutout) {
            cherrymxPlate();
        } else {
            cherrymxSwitch();
        }
    }
}

module joints() {
    x = depthX / 2;
    leftY = 1.5;
    rightY = widthY - 1.5;
    topZ = height - thickness;
    bottomZ = thickness;
    
    // Top Left
    translate([x, leftY, topZ])
    rotate([180, 0, 0])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom Left
    translate([x, leftY, bottomZ])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Top Right
    translate([x, rightY, topZ])
    rotate([180, 0, 0])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom Right
    translate([x,rightY, bottomZ])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
}

module displayModel() {
    color("#FFC312") leftSide();
    color("#C4E538") rightSide();
    
    color("#12CBC4") frontSide();
    color("#FDA7DF") backSide();
    
    color("#ED4C67") topSide();
    color("#EE5A24") bottomSide();
}

module layoutPieces() {
    translate([0, 0, -thickness / 2])
    rotate([90, 0, 0])
    leftSide();
    
    translate([0, height + thickness, thickness / 2])
    rotate([90, 0, 0])
    translate([0, -widthY, 0])
    rightSide();
    
    translate([depthX + thickness, 0, thickness / 2])
    rotate([90, 0, 0])
    rotate([0, 0, -90])
    frontSide();
    
    translate([depthX + thickness, height + thickness, -thickness / 2])
    rotate([90, 0, 0])
    rotate([0, 0, -90])
    translate([-depthX, 0, 0])
    backSide();
    
    //translate([depthX + tbPadding + thickness, height + tbPadding + thickness, -height + (thickness / 2)])
    translate([depthX + tbPadding + depthX + tbPadding + thickness, height + tbPadding + thickness, -height + (thickness / 2)])
    rotate([0, 0, 90])
    topSide();
    
    translate([depthX + tbPadding - 1, height + tbPadding + thickness, -thickness / 2])
    rotate([0, 0, 90])
    bottomSide();
}

module displayProjection() {
    projection() {
        layoutPieces();
    }
}

// displayModel();
// parts();

displayProjection();