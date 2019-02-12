open float lensDiamCM
{
  name = "Diameter [cm]"
  descr = "Outer diameter of the part of the lens where the gear-ring is placed."
  value = 10
  min = 1
  max = 100
}

open float ringThickCM
{
  name = "Thickness [cm]"
  descr = "Thickness of the gear-ring."
  value = 1.5
  min = .5
  max = 10
}

open float heightCM
{
  name = "Height [cm]"
  descr = "Height of the gear-ring."
  value = 2.5
  min = 1
  max = 10
}

function toMMfromCM(float x) { return x * 10}

float lensDiam = toMMfromCM(lensDiamCM)
float ringThick = toMMfromCM(ringThickCM)
float height = toMMfromCM(heightCM)
