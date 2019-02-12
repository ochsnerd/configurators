function placeItems(int itemIds[],
                    atrafo itemTransformations[],
                    solid& targetSolid,
                    solid unionItems[])
{
  // Add items to the targetSolid
  // Items specified by itemIds are picked from unionItems and transformed
  // according to itemTransformations before being unioned with the targetSolid
  // Arguments:
  //    itemIds :            Indices into unionItems to choose which items to place
  //    itemTransformation : Transformations to be applied to the items. Every item
  //                         has to have a transformation.
  //    targetSolid :        Solid to which the items are added. It is changed by the
  //                         function.
  //    unionItems :         List of possible items to add.
  //                         unionItems.length() > max(itemIds) has to hold.
  // Example:
  //    solid test = box(11, 11, 11)
  //    int ids[] = [0,1,1]
  //    atrafo trafos[] = [translation(<[0,0,10]>) >> rotation(<[0,0,1]>, rad(45) ),
  //                       translation(<[1,1,0]>) >> rotation(<[0,0,1]>, rad(135) ),
  //                       translation(<[10,10,10]>) >> rotation(<[0,1,0]>, rad(45) )]
  //
  //    solid items[] = [(solid) sphere(10),(solid) box(5,5,5)]
  //
  //    placeItems(ids, trafos, test, items)
  if (!(itemIds.length() == itemTransformations.length()))
  {
    echo("Different lengths of itemIds and itemTransformations")
    return
  }

  for (int i = 0; i < itemIds.length(); i++) {
    targetSolid +=  itemTransformations[i] >> unionItems[itemIds[i]]
  }
}

function placeItems(int itemIds[],
                    atrafo itemTransformations[],
                    solid& targetSolid,
                    solid unionItems[],
                    solid subtractItem)
{
  // Add items to the targetSolid after subtracting the subtractItem.
  // For each index in itemIds, transform and subtract the subtractItem. Then the
  // item specified by itemIds is picked from unionItems and transformed
  // according to itemTransformations before being unioned with the targetSolid.
  // Arguments:
  //    itemIds :            Indices into unionItems to choose which items to place
  //    itemTransformation : Transformations to be applied to the items. Every item
  //                         has to have a transformation.
  //    targetSolid :        Solid to which the items are added. It is changed by the
  //                         function.
  //    unionItems :         List of possible items to add.
  //                         unionItems.length() > max(itemIds) has to hold.
  //    subtractItem :       Item that gets subtracted before adding the specified
  if (!(itemIds.length() == itemTransformations.length()))
  {
    echo("Different lengths of itemIds and itemTransformations")
    return
  }

  for (int i = 0; i < itemIds.length(); i++) {
    targetSolid -= itemTransformations[i] >> subtractItem
    targetSolid += itemTransformations[i] >> unionItems[itemIds[i]]
  }
}
