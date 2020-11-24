function hash(h,k)= 
(
  h[search([k], h)[0]][1]
); 

module placeTeethY(start, step, count, size) {
    for(i = [0:count]) {
        y = start + (i * step);
        translate([0, y, 0])
        cube(size, center=true);
    }
}

module placeTeethZ(start, step, count, size) {
    for(i = [0:count]) {
        z = start + (i * step);
        translate([0, 0, z])
        cube(size, center=true);
    }
}

module verticalTeeth(translateZ, widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    avSpace = widthY - (size * count);
    padding = (padding==undef) ? 0 : padding;
    ts = [depthX + nothing + padding, size, height + nothing + padding];
    if (spaceBetween) {
        tbSpace = avSpace / (count - 1);
        tbStep = tbSpace + size;
        tbStart = -(widthY / 2) + (size / 2);
        
        translate([0, 0, translateZ])
        placeTeethY(tbStart, tbStep, count-1, ts);
    } else {
        tbSpace = avSpace / (count + 1);
        tbStep = tbSpace + size;
        tbStart = -(widthY / 2) + tbSpace + (size / 2);
        
        translate([0, 0, translateZ])
        placeTeethY(tbStart, tbStep, count-1, ts);
    }
}

module horizontalTeeth(translateY, widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    avSpace = heightZ - (size * count);
    padding = (padding==undef) ? 0 : padding;
    ts = [depthX + nothing + padding, height + nothing + padding, size];
    if (spaceBetween) {
        tbSpace = avSpace / (count - 1);
        tbStep = tbSpace + size;
        tbStart = -(heightZ / 2) + (size / 2);
        
        translate([0, translateY, 0])
        placeTeethZ(tbStart, tbStep, count-1, ts);
    } else {
        tbSpace = avSpace / (count + 1);
        tbStep = tbSpace + size;
        tbStart = -(heightZ / 2) + tbSpace + (size / 2);
        
        translate([0, translateY, 0])
        placeTeethZ(tbStart, tbStep, count-1, ts);
    }
}

module bottomTeeth(widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    z = -(heightZ / 2)-(height/2);
    verticalTeeth(z, widthY, depthX, heightZ, count, size, height, spaceBetween, padding, nothing);
}

module topTeeth(widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    z = (heightZ / 2)+(height/2);
    verticalTeeth(z, widthY, depthX, heightZ, count, size, height, spaceBetween, padding, nothing);
}

module leftTeeth(widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    y = -(widthY / 2)-(height / 2);
    horizontalTeeth(y, widthY, depthX, heightZ, count, size, height, spaceBetween, padding, nothing);
}

module rightTeeth(widthY, depthX, heightZ, count, size, height, spaceBetween = false, padding = 0, nothing = 0.1) {
    y = (widthY / 2) + (height / 2);
    horizontalTeeth(y, widthY, depthX, heightZ, count, size, height, spaceBetween, padding, nothing);
}

module teeth(size, opts, nothing = 0.1) {
    union() {
        color("#ef5777") cube(size, center=true);
        
        bc = hash(opts, "bottomCount");
        if (bc > 0) {        
            color("#575fcf") bottomTeeth(
                widthY = size[1],
                depthX = size[0],
                heightZ = size[2],
                count = hash(opts, "bottomCount"),
                size = hash(opts, "bottomSize"),
                height = hash(opts, "bottomHeight"),
                spaceBetween = hash(opts, "bottomSpaceBetween"),
                padding = hash(opts, "bottomPadding"),
                nothing = nothing
            );
        }
        
        tc = hash(opts, "topCount");
        if (tc > 0) {        
            color("#4bcffa") topTeeth(
                widthY = size[1],
                depthX = size[0],
                heightZ = size[2],
                count = hash(opts, "topCount"),
                size = hash(opts, "topSize"),
                height = hash(opts, "topHeight"),
                spaceBetween = hash(opts, "topSpaceBetween"),
                padding = hash(opts, "topPadding"),
                nothing = nothing
            );
        }
        
        lc = hash(opts, "leftCount");
        if (lc > 0) {        
            color("#0be881") leftTeeth(
                widthY = size[1],
                depthX = size[0],
                heightZ = size[2],
                count = hash(opts, "leftCount"),
                size = hash(opts, "leftSize"),
                height = hash(opts, "leftHeight"),
                spaceBetween = hash(opts, "leftSpaceBetween"),
                padding = hash(opts, "leftPadding"),
                nothing = nothing
            );
        }
        
        rc = hash(opts, "rightCount");
        if (rc > 0) {        
            color("#ffc048") rightTeeth(
                widthY = size[1],
                depthX = size[0],
                heightZ = size[2],
                count = hash(opts, "rightCount"),
                size = hash(opts, "rightSize"),
                height = hash(opts, "rightHeight"),
                spaceBetween = hash(opts, "rightSpaceBetween"),
                padding = hash(opts, "rightPadding"),
                nothing = nothing
            );
        }
    }
}


/*opts=[
    ["bottomCount", 3],    
    ["bottomSize", 6],
    ["bottomHeight", 10],
    ["bottomSpaceBetween", true],
    ["bottomPadding", 0.2],

    ["topCount", 3],    
    ["topSize", 6],
    ["topHeight", 10],
    ["topSpaceBetween", false],

    ["leftCount", 3],    
    ["leftSize", 4],
    ["leftHeight", 10],
    ["leftSpaceBetween", true],

    ["rightCount", 2],    
    ["rightSize", 4],
    ["rightHeight", 10],
    ["rightSpaceBetween", false],
];
teeth(size=[10, 50, 30], opts=opts);
*/