// From: https://www.trfastenings.com/knowledge-base/fundamentals/tapping-sizes-and-clearance-holes
allScrewSizes = [
  ["m1",    1.2],
  ["m1.2",  1.4],
  ["m1.4",  1.6],
  ["m1.6",  1.8],
  ["m1.8",  2],
  ["m2",    2.4],
  ["m2.2",  2.8],
  ["m2.5",  2.9],
  ["m3",    3.4],
  ["m3.5",  3.9],
  ["m4",    4.5],
  ["m5",    5.5],
  ["m6",    6.6],
  ["m8",    9],
  ["m10",   11],
  ["m12",   13.5],
  ["m14",   15.5],
  ["m16",   17.5],
  ["m18",   20],
  ["m20",   22],
  ["m22",   24],
  ["m24",   26],
  ["m27",   30],
  ["m30",   33],
];

function screwDiameter(id) = allScrewSizes[search([id], allScrewSizes)[0]][1];