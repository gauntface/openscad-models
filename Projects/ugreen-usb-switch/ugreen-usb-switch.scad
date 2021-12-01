include <../../libs/cherry-mx-switch.scad>;
include <../../libs/t-joint.scad>;
include <../../libs/teeth.scad>;

thickness = 3;

pcbX = 46;
pcbY = 95;
pcbZ = 1;
pcbScrewD = 3.8;

height = 18 + (thickness * 2);
depthX = pcbX + (thickness * 2);
widthY = 114 + (thickness * 2);

headphoneLength = 34;
headphoneRim = 2;
headphoneD = 7.8;
headphoneNutD = 12;

usbPortX = 13.8;
usbPortY = 13;
usbPortZ = 5.8;

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
    
    ["leftCount", 0],
    ["rightCount", 0],  
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

module pcb(cutout=false) {
    difference() {
        color("#27ae60") cube([pcbX, pcbY, pcbZ]);
        
        translate([3 + (pcbScrewD / 2), 13.2 + (pcbScrewD/2), -pcbZ]) {
            cylinder(pcbZ * 3, d=pcbScrewD, center=false);
        }
        translate([3 + (pcbScrewD / 2), pcbY - 13.2 - (pcbScrewD/2), -pcbZ]) {
            cylinder(pcbZ * 3, d=pcbScrewD, center=false);
        }
        
        translate([27 + (pcbScrewD / 2), 3 + (pcbScrewD/2), -pcbZ]) {
            cylinder(pcbZ * 3, d=pcbScrewD, center=false);
        }
        translate([27 + (pcbScrewD / 2), pcbY - 3 - (pcbScrewD/2), -pcbZ]) {
            cylinder(pcbZ * 3, d=pcbScrewD, center=false);
        }
    }
    
    if (cutout) {
        translate([3 + (pcbScrewD / 2), 13.2 + (pcbScrewD/2), -thickness * 2]) {
            cylinder(thickness * 3, d=pcbScrewD, center=false);
        }
        translate([3 + (pcbScrewD / 2), pcbY - 13.2 - (pcbScrewD/2), -thickness * 2]) {
            cylinder(thickness * 3, d=pcbScrewD, center=false);
        }
        
        translate([27 + (pcbScrewD / 2), 3 + (pcbScrewD/2), -thickness * 2]) {
            cylinder(thickness * 3, d=pcbScrewD, center=false);
        }
        translate([27 + (pcbScrewD / 2), pcbY - 3 - (pcbScrewD/2), -thickness * 2]) {
            cylinder(thickness * 3, d=pcbScrewD, center=false);
        }
    }
    
    translate([-thickness-1, pcbY-usbPortY-30, pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
    translate([-thickness-1, pcbY-usbPortY-30-usbPortY-10, pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
    translate([-thickness-1, 3.2, pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, 7, 2]);
    }
    
    usbSpaceBetween = 10;
    yPadding = pcbY - (usbPortY * 4) - (usbSpaceBetween * 3);
    translate([pcbX-usbPortX+1, (yPadding / 2), pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
    translate([pcbX-usbPortX+1, (yPadding / 2) + (usbSpaceBetween + usbPortY), pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
    translate([pcbX-usbPortX+1, (yPadding / 2) + (usbSpaceBetween + usbPortY) * 2, pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
    translate([pcbX-usbPortX+1, (yPadding / 2) + (usbSpaceBetween + usbPortY) * 3, pcbZ]) {
        color("#f39c12") cube([usbPortX+thickness, usbPortY, usbPortZ]);
    }
}

module parts(cutout=false) {
    padding = 2;
    
    translate([thickness, thickness + padding, thickness]) {
        pcb(cutout);
    }
    
    translate([-headphoneRim, widthY - (headphoneNutD / 2) - thickness - padding, (height / 2)]) {
        headphoneJack();
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
    translate([thickness, depthX + thickness + tbPadding + height, -height + (thickness / 2)])
    rotate([0, 0, -90])
    topSide();
    
    translate([thickness, ((depthX + thickness + tbPadding) * 2) + height, -thickness / 2])
    rotate([0, 0, -90])
    bottomSide();
}

module displayProjection() {
    projection() {
        layoutPieces();
    }
}

/* displayModel();
parts();*/

displayProjection();