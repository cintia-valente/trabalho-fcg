#include "collisions.h"

bool collidingPlane(GameObject object, PlaneObject plane) {
  
  if ( object.name == plane.name )
    return false;

  // teto e chão
  if ( plane.bounding_box.x == INFINITY ) {

    if (plane.bounding_box.z > 0 && ( (object.bounding_box_max.z + object.bounding_box_min.z) > plane.bounding_box.z)) 
      return true;
    
    else if (plane.bounding_box.z < 0 && ((object.bounding_box_max.z - object.bounding_box_min.z) < plane.bounding_box.z)) 
      return true;
    
    else if (plane.bounding_box.y > 0 && ((object.bounding_box_max.y + object.bounding_box_min.y)/2 > plane.bounding_box.y)) 
      return true;
    
    else if (plane.bounding_box.y < 0 && ((object.bounding_box_max.y + object.bounding_box_min.y) < plane.bounding_box.y)) 
      return true;
  } else if ( plane.bounding_box.y == INFINITY ) {

    // parte da frente
    if (plane.bounding_box.x > 0 && ((object.bounding_box_max.x + object.bounding_box_min.x)/2 > plane.bounding_box.x)) 
      return true;
    
    // parte de trás
    else if (plane.bounding_box.x < 0 && ((object.bounding_box_max.x + object.bounding_box_min.x)/2 < plane.bounding_box.x)) 
      return true;
    
    // direita
    else if (plane.bounding_box.z > 0 && ((object.bounding_box_max.z + object.bounding_box_min.z)/2 > plane.bounding_box.z)) 
      return true;
    
    // esquerda
    else if (plane.bounding_box.z < 0 && ((object.bounding_box_max.z + object.bounding_box_min.z)/2 < plane.bounding_box.z)) 
      return true;
  } else {
     if (plane.bounding_box.z < 0 && ((object.bounding_box_max.z + object.bounding_box_min.z)/2 <= plane.bounding_box.z)) 
      return true;
  }

  return false;
}

bool collidingObject(GameObject object1, GameObject object2) {
  if ( object1.name == object2.name )
    return false;
    
  return false;
}
