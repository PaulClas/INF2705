#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;

uniform int attenuation; // on veut une atténuation en profondeur ?

uniform vec4 planRayonsX;

layout(location=0) in vec4 Vertex;
layout(location=3) in vec4 Color;

out Attribs {
    vec4 couleur;
    vec4 planRX;
	vec4 vertex;
} AttribsOut;

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;
    // couleur du sommet
    AttribsOut.couleur = Color;

	vec4 pos = matrModel * Vertex;

	// gradient on fish color, depends on vertex coord
	vec3 vert = vec3(0.f, 1.f, 0.f);
    vec3 cyan = vec3(0.f, 1.f, 1.f);
    if(all(equal(Color.rgb, vert))) {
        AttribsOut.couleur.rgb = mix(AttribsOut.couleur.rgb, cyan, Vertex.z);
    }


	 // atténuer selon la profondeur
    if ( attenuation == 1 )
    {
		const float debAttenuation = -12.0;
		const float finAttenuation = +5.0;
		const vec4 coulAttenuation = vec4( 0.2, 0.15, 0.1, 1.0 );
		float ratio = smoothstep(finAttenuation, debAttenuation, pos.z);
		AttribsOut.couleur = mix(AttribsOut.couleur, coulAttenuation, ratio);
    }

	AttribsOut.planRX = planRayonsX;
	AttribsOut.vertex = Vertex;
}
