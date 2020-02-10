#version 410

layout(triangles) in;
layout(triangle_strip, max_vertices = 6) out;
uniform mat4 matrModel;

in Attribs {
    vec4 couleur;
	vec4 planRX;
	vec4 vertex;
} AttribsIn[];

out Attribs {
    vec4 couleur;
} AttribsOut;


void main()
{
    // og
    for(int i =0 ; i < gl_in.length(); ++i) {
        gl_ViewportIndex = 0;
        gl_Position = gl_in[i].gl_Position;
        AttribsOut.couleur = AttribsIn[i].couleur;
		gl_ClipDistance[0] = dot( AttribsIn[i].planRX, matrModel * AttribsIn[i].vertex );
        EmitVertex();
    }
	EndPrimitive();
	// inverted
	for(int i =0 ; i < gl_in.length(); ++i) {
        gl_ViewportIndex = 1;
        gl_Position = gl_in[i].gl_Position;
        AttribsOut.couleur.r = 1 -  AttribsIn[i].couleur.r;
        AttribsOut.couleur.g = 1 -  AttribsIn[i].couleur.g;
        AttribsOut.couleur.b = 1 -  AttribsIn[i].couleur.b;
        AttribsOut.couleur.a = AttribsIn[i].couleur.a;
		gl_ClipDistance[0] = dot( AttribsIn[i].planRX, matrModel * AttribsIn[i].vertex );
        EmitVertex();
    }
    EndPrimitive();
 }
