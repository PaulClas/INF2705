#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    vec4 position[3];      // dans le repère du monde
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
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
    vec4 ambient;       // couleur ambiante
    bool localViewer;   // observateur local ou à l'infini?
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
    bool utiliseCouleur;      // doit-on utiliser la couleur de base de l'objet en plus de celle de la texture?
    int afficheTexelFonce;    // un texel foncé doit-il être affiché 0:normalement, 1:mi-coloré, 2:transparent?
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
    vec3 lumiDir[3];
    vec3 normale, obsVec;
    vec4 couleur;
    vec2 texCoord;
} AttribsOut;

const int NB_SPOT = 3;

vec4 calculerReflexion( in vec3 L[NB_SPOT], in vec3 N, in vec3 O )
{
    vec4 coul = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;

    
    coul.a = AttribsOut.couleur.a;

    for ( int i = 0; i < NB_SPOT; ++i )
    {
        // calcul de la composante ambiante
        coul += FrontMaterial.ambient * LightSource.ambient;

        // calcul de la composante diffuse
        float NdotL = max( 0.0, dot( N, L[i] ) );
        if (utiliseCouleur)
        {
            coul += vec4(0.7,0.7,0.7,1.0)*  LightSource.diffuse * NdotL;
        }
        else
        {
            coul += FrontMaterial.diffuse * LightSource.diffuse * NdotL;
        }

        // calcul de la composante spéculaire
        if (utiliseBlinn) 
        {
            // Blinn
            vec3 B = normalize( L[i] + O );
            float BdotN = max( 0.0, dot( B, N ) );
            coul += FrontMaterial.specular * LightSource.specular * max( 0.0, pow( BdotN, FrontMaterial.shininess ) );
        }
        else 
        {
            // Phong
            vec3 R = reflect( -L[i], N );
            coul += FrontMaterial.specular * LightSource.specular * pow( max( 0.0, dot( R, O ) ), FrontMaterial.shininess );
        }
    }

    return clamp( coul, 0.0, 1.0 );
}

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

    AttribsOut.couleur = Color;

    // calculer la normale (N) qui sera interpolée pour le nuanceur de fragment
    AttribsOut.normale = matrNormale * Normal;

    // calculer la position (P) du sommet (dans le repère de la caméra)
    vec3 pos = vec3( matrVisu * matrModel * Vertex );

    // vecteur de la direction (L) de la lumière (dans le repère de la caméra)
    AttribsOut.lumiDir[0] = ( matrVisu * LightSource.position[0] ).xyz - pos;
    AttribsOut.lumiDir[1] = ( matrVisu * LightSource.position[1] ).xyz - pos;
    AttribsOut.lumiDir[2] = ( matrVisu * LightSource.position[2] ).xyz - pos;

    // vecteur de la direction (O) vers l'observateur (dans le repère de la caméra)
    AttribsOut.obsVec = LightModel.localViewer ? normalize(-pos) : vec3( 0.0, 0.0, 1.0 );

    AttribsOut.texCoord = TexCoord.st;

    if (typeIllumination == 0) 
    {
        vec3 L[NB_SPOT];
        for (int i = 0; i < NB_SPOT; ++i) 
        {
            L[i] = normalize( AttribsOut.lumiDir[i] );
        }
        vec3 N = normalize( AttribsOut.normale );
        vec3 O = normalize( AttribsOut.obsVec );  // position de l'observateur

        AttribsOut.couleur = calculerReflexion(L, N, O);
    }

}
