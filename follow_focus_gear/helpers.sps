public function drawOrigin( float length )
{
  float size = length / 20
  make rgb(255,0,0) >> cylinder(<[length,0,0]>, size)
  make rgb(0,255,0) >> cylinder(<[0,length,0]>, size)
  make rgb(0,0,255) >> cylinder(<[0,0,length]>, size)
}

public function showVector(vector x)
{
  make cylinder(x, 3)
}

function radFromArclength(float arcl, float d)
{
  // Return the angle (in radians, from [0, 2PI)) corresponding to the arclength
  // arc on a circe with diameter d
  float phi = 2 * arcl / d
  int turns = phi / 2PI
  return phi - turns * 2PI
}

function vecFromCylindricalCoords(float r, float phi)
{
  // Create a 2D cartesian vector from cylindrical coordinates (r, phi)
  // phi is in radians
  return vector(r * cos(phi), r * sin(phi))
}

function mirror(vector v)
{
  // Return an atrafo that mirrors around the plane that is orthogonal to v and
  // contains the origin.
  // https://en.wikipedia.org/wiki/Householder_transformation
  return atrafo(<[<[1 - 2*v.x*v.x, 2*v.x*v.y, 2*v.x*v.z]>,
                  <[2*v.y*v.x, 1 - 2*v.y*v.y, 2*v.y*v.z]>,
                  <[2*v.z*v.x, 2*v.z*v.y, 1 - 2*v.z*v.z]>]>)
}

function between(float val, float min_val, float max_val)
{
  return min(max_val, max(min_val, val))
}

function between(int val, int min_val, int max_val)
{
  return min(max_val, max(min_val, val))
}

vector x_axis = <[1,0,0]>
vector y_axis = <[0,1,0]>
vector z_axis = <[0,0,1]>
vector origin = <[0,0,0]>

vector coord_axes[] = [x_axis, y_axis, z_axis]
