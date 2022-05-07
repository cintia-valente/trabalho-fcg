#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <stack>
#include <map>
#include <list>

#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

struct GameObject
{
    std::string name;
    glm::vec3 bounding_box_min;
    glm::vec3 bounding_box_max;
};

struct PlaneObject
{
    std::string name;
    glm::vec3 bounding_box;
};

bool collidingPlane(GameObject object, PlaneObject plane);
bool collidingObject(GameObject object1, GameObject object2);

