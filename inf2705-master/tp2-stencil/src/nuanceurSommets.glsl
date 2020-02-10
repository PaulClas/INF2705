#version 410

const float M_PI = 3.14159265358979323846; // pi
const float M_PI_2 = 1.57079632679489661923; // pi/2

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;

uniform vec4 planDragage; // équation du plan de dragage
uniform vec4 planRayonsX; // équation du plan de RayonsX

layout(location=0) in vec4 Vertex;
layout(location=3) in vec4 Color;

out Attribs {
    vec4 couleur;
} AttribsOut;

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

    // couleur du sommet
    AttribsOut.couleur = Color;
    if (Color[0] == 0.0 && Color[1] == 1.0 && Color[2] == 0.0) {
        AttribsOut.couleur = mix(vec4(0, 1, 0, 1), vec4(0, 1, 1, 1), Vertex[2]);
    }

    vec4 pos = matrModel * Vertex; // dans le repere du monde
    gl_ClipDistance[0] = dot( -planRayonsX, pos );
    gl_ClipDistance[1] = dot( planRayonsX, pos );
    gl_ClipDistance[2] = dot( planDragage, pos );
}
