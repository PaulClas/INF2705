#version 410

layout(points) in;
layout(points, max_vertices = 1) out;

in Attribs {
  vec4 couleur;
  float tempsDeVieRestant;
  float sens; // du vol
}
AttribsIn[];

out Attribs {
  vec4 couleur;
  vec2 texCoord;
}
AttribsOut;

uniform mat4 matrProj;
uniform int texnumero;
uniform float pointsize;

void main() {
    // assigner la position du point
    // float depth = (matrProj * gl_in[0].gl_Position).z;
    // depth = clamp(depth, -8.0, 8.0);
    gl_Position = matrProj * gl_in[0].gl_Position;

    // assigner la taille des points (en pixels)
    gl_PointSize = gl_in[0].gl_PointSize;
    // gl_PointSize = abs(pointsize / depth);

    // assigner la couleur courante
    AttribsOut.couleur = AttribsIn[0].couleur;
    AttribsOut.texCoord += (1.0, 1.0);
    AttribsOut.texCoord -= (1.0, 1.0);
    
    EmitVertex();
}