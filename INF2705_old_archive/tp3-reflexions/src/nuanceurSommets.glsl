#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient[3];
    vec4 diffuse[3];
    vec4 specular[3];
    vec4 position[3];      // dans le repère du monde
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante globale
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    int numTexCoul;           // numéro de la texture de couleurs appliquée
    int numTexNorm;           // numéro de la texture de normales appliquée
    int afficheTexelFonce;    // un texel foncé doit-il être affiché 0:normalement, 1:mi-coloré, 2:transparent?
    
    //partie 3: tesselation
    int tesselation;
    
    //test du decalage de texture
    float decalage;
};

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;

out Attribs {
    vec4 couleur;
    vec3 normale;
    vec3 lumiDir[3];
    vec3 obsVec;
    vec2 texCoord;
} AttribsOut;

vec4 calculerReflexion( in int j, in vec3 L, in vec3 N, in vec3 O ) // pour la lumière j
{
	vec4 coul = AttribsOut.couleur;

    // calcul de l'éclairage seulement si le produit scalaire est positif
    float NdotL = max( 0.0, dot( N, L ) );
    if ( NdotL > 0.0 )
    {
        // calcul de la composante diffuse
        //coul += FrontMaterial.diffuse * LightSource.diffuse * NdotL;
        coul += FrontMaterial.diffuse * LightSource.diffuse[j] * NdotL; //(ici, on utilise plutôt la couleur de l'objet)
        // calcul de la composante spéculaire (Blinn ou Phong)
        float NdotHV = max( 0.0, ( utiliseBlinn ) ? dot( normalize( L + O ), N ) : dot( reflect( -L, N ), O ) );
        coul += FrontMaterial.specular * LightSource.specular[j] * ( ( NdotHV == 0.0 ) ? 0.0 : pow( NdotHV, FrontMaterial.shininess ) );
    }
    // assigner la couleur finale
    return coul;
}

void main( void )
{
	// transformation standard du sommet
	if(tesselation==1){
		gl_Position = matrModel * Vertex;
	}else{
		gl_Position = matrProj * matrVisu * matrModel * Vertex;
	}
	vec3 pos = vec3( matrVisu * matrModel * Vertex );
	
	// calcul de la normale normalisée
	vec3 N = matrNormale * Normal;
	vec3 O = (-pos);
	vec3 L[3];
	for (int i=0;i< 3 ;i++){
		L[i] =(matrVisu * LightSource.position[i]).xyz -pos;
		AttribsOut.lumiDir[i] =L[i];
	}
	AttribsOut.normale = N;
	AttribsOut.obsVec = O; // =(0-pos)
		
	if(typeIllumination==0){		
		AttribsOut.couleur = (FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient) +
		LightSource.ambient[0] * FrontMaterial.ambient + LightSource.ambient[1] * FrontMaterial.ambient+
		LightSource.ambient[2] * FrontMaterial.ambient;
		
		for (int i=0;i< 3 ;i++){
			AttribsOut.couleur = calculerReflexion(i, normalize(L[i]), normalize( N ), normalize(O) ) ;
		}
		AttribsOut.couleur = clamp( AttribsOut.couleur, 0.0, 1.0 );
	} else {
		AttribsOut.couleur = vec4(0.3,0.3,0.3,1.0);
	}
	//Si on veut décaler la texture 2 par rapport au temps, décommenter la structure if/else
    if (numTexCoul == 2) {
		AttribsOut.texCoord = TexCoord.st + vec2(-decalage,0.0);
	} else {
		AttribsOut.texCoord = TexCoord.st;
	}
}
