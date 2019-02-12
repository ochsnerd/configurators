#insert("helpers.sps")
#insert("open.sps")

function createRing(float d1, float d2, float h) {
  // Create a ring with inner diameter d1, outer diameter d2 and height h
  // Oriented along z, from z=0 until z=h
  // Arguments:
  //    d1 : inner diameter of the ring
  //    d1 : outer diameter of the ring
  //    h  : height of the ring
  // Returns:
  //    solid : Ring as described above of a box() if parameters are invalid
  if ((d1 >= d2) || (h <= 0)) {
    echo("Invalid arguments")
    return (solid) box()
  }

  return (solid) cylinder(<[0,0,h]>, d2/2) - cylinder(<[0,0,h]>, d1/2)
}


function makeTooth(float da,
                   float d,
                   float db,
                   float df,
                   float s,
                   float e,
                   float height) {
  // Create a tooth of an involute gear from the given dimensions. It is placed
  // such that it fits on a gear with the given dimensions oriented along z from
  // z=0 to z=h on the positive x-axis.
  // The geometry of the tooth is approximated.
  // Nomenclature from https://de.wikipedia.org/wiki/Evolventenverzahnung
  // See: https://www.arc.id.au/GearDrawing.html
  // and: http://web.mit.edu/harishm/www/papers/involuteEWC.pdf
  // for what would be necessary to construct a better involute-approxiamtion
  // No argument validation is performed.
  // Arguments:
  //    da : Kopfkreisdurchmesser
  //    d  : Teilkreisdurchmesser
  //    db : Grundkreisdurchmesser
  //    df : Fusskreisdurchmesser
  //    s  : Zahndicke
  //    e  : Zahnlücke
  // Returns:
  //    solid : A single approximately involute gear tooth as described above
  float phi_pdf = radFromArclength(0.5*(s+e), df)   // s + e = p Teilung
  float phi_sd = radFromArclength(0.5*s, db)
  float phi_sda = radFromArclength(s/4, da)

  float rf = df / 2
  float r = d / 2
  float ra = da / 2

  vector v1 = vecFromCylindricalCoords(ra, 0)
  vector v2 = vecFromCylindricalCoords(ra, phi_sda)
  vector v3 = vecFromCylindricalCoords(r, phi_sd)
  vector v4 = vecFromCylindricalCoords(rf, phi_pdf)
  vector v5 = vecFromCylindricalCoords(rf, 0)

  curve c1 = v1 ->
             arc_to(v2, ra) ->
             arc_to(v3, 1.5*(ra-rf)) ->    // this should be the involute
             arc_to(v4, 0.75*(ra-rf), false) ->
             v5 -><-

  solid half_tooth = extrusion(c1, <[0, 0, height]>)

  return half_tooth + (mirror(y_axis) >> half_tooth)
}

function chamferRingTop(solid& ring, float l1, float l2)
{
  // Apply a chamfer to the top of the given ring with dimensions almost l1 along
  // the axis and almost l2 radially.
  // Assumes the ring is oriented symmetrically along z
  float eps = 0.1
  selectbox ring_dims = ring.min_bbox()
  solid s1 = cylinder(l1 + eps,
                      ring_dims.maxx + eps,
                      z_axis * (ring_dims.maxz - l1))
  solid s2 = cone(l1 + 2*eps,
                  ring_dims.maxx + eps,
                  ring_dims.maxx - l2,
                  z_axis * (ring_dims.maxz - l1 - eps))
  ring -= (s1 - s2)
}

float outerDiam = lensDiam + 2*ringThick

// Calculate aspects of the gear (https://de.wikipedia.org/wiki/Evolventenverzahnung)
float m = 0.8                   // Modul
float alpha = 20                // Eingriffswinkel (deg)
float ratio = 0.5               // Verhältnis Zahnbreite / Teilung (s / p)

float ha = m                    // Zahnkopfhöhe
float hf = 1.1 * m              // Zahnfusshöhe
float df = outerDiam            // Fusskreisdurchmesser
float d = df + 2*hf             // Teilkreisdurchmesser
float da = d + 2*ha             // Kopfkreisdurchmesser
// db doesn't make much sense, it's much too small ---> is alpha too big?
float db = d * cos(rad(alpha))  // Grundkreisdurchmesser

int z = d / m                   // Zähnezahl
float p = m * PI                // Teilung
float s = ratio * p             // Zahnbreite
float e = (1-ratio) * p         // Lückenbreite


document.gamma = rad(2)
// Only build half and mirror about xy at the end
height /= 2

// Create ring
solid gear_ring = createRing(lensDiam + 1, outerDiam, height)

// Add springs inside
function put_bend(solid s, float radius, float angle)
{
  // Translates, bends (around z) and then rotates the solid s
  s <<= translation(<[radius, 0, 0]>)
  s <<= bending(origin, <[radius+20,0,0]>, y_axis)
  s <<= rotation(z_axis, angle)
  return s
}

int num_springs = between(lensDiam/20, 3.0, 13.0)
for (int i = 0; i < num_springs; ++i)
{
  gear_ring += put_bend(cylinder(height, 6, 25), lensDiam/2 + 3.5, 2PI/num_springs * i)
  gear_ring -= put_bend(cylinder(height, 2, 15), lensDiam/2 + 0.5, 2PI/num_springs * i)
}

// Add teeth
for (int i = 0; i < z; ++i)
{
  gear_ring += rotation(z_axis, i * 2PI/z) >> makeTooth(da, d, db, df, s, e, height)
}

// Chamfer outside
float chamfer_height = between(height/2, 2.0, 6.0)
chamferRingTop(gear_ring, chamfer_height, ha+hf)

// Chamfer inside
gear_ring -= cone(10, lensDiam/2 - 4.5, lensDiam/2 + 1, z_axis * (height - 10))

make gear_ring + (mirror(z_axis) >> gear_ring)
