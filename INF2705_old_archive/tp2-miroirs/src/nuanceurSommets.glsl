#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;

uniform vec4 planRayonsX; // équation du plan de RayonsX
uniform int attenuation; // on veut une atténuation en profondeur ?

uniform int enSelection; // si nous somme en sélection


layout(location=0) in vec4 Vertex;
layout(location=3) in vec4 Color;

out Attribs {
    vec4 couleur;
    float clipDistanceRayonsX;
} AttribsOut;

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

	AttribsOut.clipDistanceRayonsX = dot(planRayonsX, matrModel *Vertex);
    // couleur du sommet
    
			AttribsOut.couleur = Color;

    //AttribsOut.couleur = Color;
    // atténuer selon la profondeur
    if ( attenuation == 1 && enSelection == 0 )
    {
        const float debAttenuation = -12.0;
        const float finAttenuation = +5.0;
        const vec4 coulAttenuation = vec4( 0.2, 0.15, 0.1, 1.0 );
        
        AttribsOut.couleur = Color;
		
		//si le alpha est plus grand que 0.4 alors nous savons que nous somme pas en présence d'une paroie, mais d'un poisson
		if(Color[3] > 0.4){
			// le poisson est un cylindre centré dans l'axe des z de rayon 1 entre (0,0,0) et (0,0,1). Donc le z varie entre 0 et 1.
			float z = smoothstep(0,1,Vertex.z);
			vec4 cyan = vec4(0.0,1.0,1.0,1.0);
			
			AttribsOut.couleur = mix(Color,cyan,z) ;
			
		}
			
			// Pour salir l'aquarium selon le z
			float z = smoothstep(finAttenuation,debAttenuation,(matrModel * Vertex).z);
			
			AttribsOut.couleur = mix(AttribsOut.couleur,coulAttenuation,z) ;
		

       
    }
}
