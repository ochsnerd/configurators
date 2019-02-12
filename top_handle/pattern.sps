// Create Pattern Feature using different Logos
function createPattern(solid grip, int logoID, int handWidth, int handHeight)
{
// LogoID: 1 == heart
// LogoID: 2 == puzzle
// LogoID: 3 == star
// LogoID: 4 == starthree
// LogoID: 5 == unicorn
// LogoID: 6 == alpa
// LogoID: 7 == ETH
// LogoID: 8 == Audi

// invert dimfromhand
//handWidth += 10
//handHeight = 2 / PI * (7.5* handHeight - 15)
echo(handWidth)
echo(handHeight)
float pattern_thickness = 50

// Switch condition to select logo
string temp
switch( logoID )
{
  case 0:
    return;

  case 1:
    temp = "include/logo_heart.jpg";

  case 2:
    temp = "include/logo_puzzle.jpg";

  case 3:
    temp = "include/logo_star.jpg";

  case 4:
    temp = "include/logo_starthree.jpg";

  case 5:
    temp = "include/logo_unicorn.jpg";

  case 6:
    temp = "include/logo_alpa.jpg";

  case 7:
    temp = "include/logo_ETH.jpg";

  case 8:
    temp = "include/logo_audi.jpg";

}

  // Import and invert black-white pattern (sometimes necessary)
  image img(temp)
  img.invert()

  // Convert image to solid
  solid img1 = img_to_solid( img, pattern_thickness, 1.0)

  // Move to center
  img1 = translation(<[-img.width/2, -img.height/2, 0]>) >> img1

  // Scale solid of image
  float scal = 0.04
  img1 = scaling(scal, scal, scal) >> img1
  float pattern_height = scal* img.height
  float pattern_width = scal* img.width

  // Position with correct orientation
  img1 = rotation(<[1.0, 0.0, 0.0]>, rad(-90)) >> img1

  // Offset in y axis with offset (diameter direction)
  float offset_pattern_diameter_dir = 34
  img1 = translation(<[0, offset_pattern_diameter_dir, 0]>) >> img1

  // Offset in -z axis with offset (length direction)
  float offset_pattern_length_dir = 12.5
  img1 = translation(<[0, 0, -offset_pattern_length_dir]>) >> img1

  // Get dimensions of img1
  selectbox sBbox = img1.min_bbox()

  vector v1 = <[ sBbox.minx,  sBbox.miny, sBbox.minz ]>
  vector v2 = <[ sBbox.maxx,  sBbox.miny, sBbox.minz ]>
  vector v3 = <[ sBbox.minx,  sBbox.maxy, sBbox.minz ]>
  vector v4 = <[ sBbox.minx,  sBbox.miny, sBbox.maxz ]>

  vector connectingVectorV1V2 = v2 - v1
  vector connectingVectorV1V3 = v3 - v1
  vector connectingVectorV1V4 = v4 - v1

  float sDimensions[3]
  sDimensions[0] = | connectingVectorV1V2 |/100
  sDimensions[1] = | connectingVectorV1V3 |/100
  sDimensions[2] = | connectingVectorV1V4 |/100

    for( int idx = 0; idx < 3; idx++ ) {
      sDimensions[ idx ] *= 10
    }

  // Subdivide solid image for enfold
  img1 = subdiv( 0.5, <[0,0,1]> ) >> img1

  // Execute enfold for solid image
  solid img1_enfold


echo("handWidth"+handWidth)
echo("handHeight"+handHeight)
echo("sDimensions[0]"+sDimensions[0])
echo("sDimensions[1]"+sDimensions[1])
echo("sDimensions[2]"+sDimensions[2])

int pattern_n_length_dir = floor(handWidth/sDimensions[2])-1
echo("pattern_n_length_dir"+pattern_n_length_dir)

int pattern_n_diameter_dir = floor(handHeight/sDimensions[0])/2
echo("pattern_n_diameter_dir"+pattern_n_diameter_dir)


  for (int i = 0; i < pattern_n_length_dir; i++)
  {
     img1_enfold = rgb( 255, 255, 255 ) >> enfold(img1, grip, <[0.0, -1.0, 0.0]>, 1.0, false, -1)
    img1 = translation(<[0, 0, -sDimensions[2]*10]>) >> img1

    for (int j = 0; j < pattern_n_diameter_dir; j++)
    {
      make rotation(<[0, 0, 1]>, rad(360 / pattern_n_diameter_dir) * j) >> img1_enfold
    }

  }

  return
}
