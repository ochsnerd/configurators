function importSTL(string name)
{
  // Import the stl from file name and return it as a solid
  return (solid) mesh(name)
}

function importGrip(float diameter, float length)
{
  // Return the grip, scaled to prescribed length + diameter and with added hole
  // for the screwdriver.
  float origLen = 99.5
  float origDia = 36

  float lenScaling = length / origLen
  float diaScaling = diameter / origDia

  solid grip = importSTL("include/grip_high.stl")
  grip <<= scaling(diaScaling, diaScaling, lenScaling)
  //grip -= translation(<[0, -20, -25]>) >> cylinder(<[0,100,0]>, 3) // destroys the pattern
  return grip
}

function importGripTransition(float diameter, float length, float basediam)
{
  // Return the grip, scaled to prescribed length + diameter and fitting the
  // basediam.
  return importGrip(diameter, length) + cone(<[0,0,-10]>, basediam/2, (diameter-12)/2)
}

function importNeck()
{
  // Return the neck, with the attachment-point of the handle at (0,0,0)
  return importSTL("include/neck_high.stl")
}

function importBaseplate()
{
  return translation(<[0,-75.5,-25]>) >> rotation(<[0,0,1]>, rad(-90)) >> rotation(<[1,0,0]>, rad(90)) >> importSTL("include/baseplate_high.stl")
}
