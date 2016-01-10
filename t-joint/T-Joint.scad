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

module createTJoint(materialThickness, boltWidth, boltHeight, nutWidth, nutHeight, endspacing = 2) {
    translate([-(boltWidth / 2), 0, 0]) {
        translate([(boltWidth / 2) - (nutWidth / 2), 0, 0]) {
            cube([nutWidth, materialThickness, nutHeight]);
        }

        translate([0, 0, nutHeight - endspacing - boltHeight]) {
            cube([boltWidth, materialThickness, boltHeight]);
        }
    }

    translate([0, (materialThickness / 2), -materialThickness]) {
        cylinder(materialThickness, d=nutWidth, true);
    }
}

// Remember bit.ly/holesize

createTJoint(3, 5.5, 2.5, 3.4, 7);
