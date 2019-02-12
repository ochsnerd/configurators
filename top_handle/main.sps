#insert("helpers.sps")
#insert("importers.sps")
#insert("itemplacer.sps")
#insert("pattern.sps")
// Hand dimensions --------------------------------------------------
open float handHeight
{
  name = "Height [cm]"
  descr = "Height of your Hand in cm"
  value = 19
  min = 12.5
  max = 23
}

open float handWidth
{
  name = "Width [cm]"
  descr = "Width of your Hand in cm"
  value = 9.95
  min = 7.5
  max = 20.0
}

float handleGeometry[] = handleGeometryFromHand(handWidth, handHeight)

// Color --------------------------------------------------------------------
open color handleColor
{
  name="Color"
  descr="Color of the handle"
  value=rgb(40,40,40)
}

// Attachments --------------------------------------------------------------
open int attachment1
{
  name = "Atch-type 1"
  descr = "Type of first attachment (top)"
  value = 0
  min = 0
  max = 4
}

open int attachment2
{
  name = "Atch-type 2"
  descr = "Type of second attachment (front)"
  value = 0
  min = 0
  max = 4
}

open int attachment3
{
  name = "Atch-type 3"
  descr = "Type of third attachment (left)"
  value = 0
  min = 0
  max = 4
}

open int attachment4
{
  name = "Atch-type 4"
  descr = "Type of fourth attachment (right)"
  value = 0
  min = 0
  max = 4
}

solid attachments[] = [importSTL("include/attachment_empty.stl"),
                       importSTL("include/attachment_quarter.stl"),
                       importSTL("include/attachment_eights.stl"),
                       importSTL("include/attachment_ulcs.stl"),
                       importSTL("include/attachment_cableclips.stl")]

atrafo attachment_transforms[] = [translation(<[  0.0,   20, 16.5]>) >> rotation(<[0,0,1]>, rad(  0)),
                                  translation(<[  0.0, -1.5, 30.0]>) >> rotation(<[1,0,0]>, rad( 90)),
                                  translation(<[ 20.0, -1.5, 16.5]>) >> rotation(<[0,0,1]>, rad(-90)),
                                  translation(<[-20.0, -1.5, 16.5]>) >> rotation(<[0,0,1]>, rad( 90))]

int ids[] = [attachment1,
             attachment2,
             attachment3,
             attachment4]

// Patterns ----------------------------------------------------------------
open float logoID
{
  name = "Pattern Type [1 to 8, 0 for none]"
  descr = "Pattern Type"
  value = 0
  min = 0
  max = 8
}

// Import stls

solid grip = handleColor >> importGripTransition(handleGeometry[1], handleGeometry[0], 40)
solid neck = handleColor >> importNeck()
solid base = handleColor >> importBaseplate()

// Add attachments to neck
placeItems(ids,
           attachment_transforms,
           neck,
           attachments,
           importSTL("include/attachment_empty.stl"))

// Add pattern to grip
createPattern(grip, logoID, handWidth, handHeight)

// Combine, color and make
make (grip + neck + base)
