/**
       Copyright 2016 Matthew Gaunt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/

/**
th = thickness
bD = bolt diameter
bH = bolt height
sD = screw diameter
sL = screw length
**/
module createTJoint(th, bD, bH, sD, sL, endspacing = 2, nothing = 0.1) {
    union() {
        translate([0, 0, (sL / 2) - nothing])
        color("#ef5777") cube([sD, th + nothing, sL + nothing], center = true);

        translate([0, 0, sL - (bH / 2) - endspacing])
        color("#575fcf") cube([bD, th + nothing, bH], center = true);
        
        translate([0, 0, -(th / 2)])
        color("#4bcffa") cylinder(th + nothing, d=sD, center=true);
    }
}

// Remember https://www.trfastenings.com/Products/knowledgebase/Tables-Standards-Terminology/Tapping-Sizes-and-Clearance-Holes

// createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
