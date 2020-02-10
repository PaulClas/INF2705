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

uniform sampler2D laTextureCoul;
uniform sampler2D laTextureNorm;

/////////////////////////////////////////////////////////////////

in Attribs {
    vec3 lumiDir[3];
    vec3 normale, obsVec;
    vec4 couleur;
    vec2 texCoord;
} AttribsIn;

out vec4 FragColor;
uniform sampler2D laTexture;

const int NB_SPOT = 3;

vec4 calculerReflexion( in vec3 L[NB_SPOT], in vec3 N, in vec3 O )
{
    vec4 coul = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;

    if ( numTexNorm != 0 )
    {
        vec3 couleur = texture(laTextureNorm, AttribsIn.texCoord.st ).rgb;
        vec3 dN = normalize( ( couleur - 0.5 ) * 2.0 );
        N = normalize( N + dN );
    }
    

    coul.a = AttribsIn.couleur.a;

    for ( int i = 0; i < NB_SPOT; ++i )
    {
        // calcul de la composante ambiante
        coul += FrontMaterial.ambient * LightSource.ambient;
        
        // calcul de la composante diffuse
        float NdotL = max( 0.0, dot( N, L[i] ) );

        if (utiliseCouleur)
        {
            coul += vec4(0.7, 0.7, 0.7, 1.0) * LightSource.diffuse * NdotL;
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
    FragColor = AttribsIn.couleur;

    if (typeIllumination == 1)
    {
        vec3 L[NB_SPOT];
        for (int i = 0; i < NB_SPOT; ++i) 
        {
            L[i] = normalize( AttribsIn.lumiDir[i] );
        }
        vec3 N = normalize( gl_FrontFacing ? AttribsIn.normale : -AttribsIn.normale );
        vec3 O = normalize( AttribsIn.obsVec );  // position de l'observateur

        FragColor = calculerReflexion(L, N, O);
    }
    
    if (numTexCoul != 0)
    {
        vec4 couleurTexture = texture( laTexture, AttribsIn.texCoord.st );

        if (afficheTexelFonce == 1)
        {
            if (couleurTexture.r < 0.5 && couleurTexture.g < 0.5 && couleurTexture.b < 0.5)
            {
                FragColor = mix(FragColor, couleurTexture, 0.5);
            }
        }
        else if (afficheTexelFonce == 2)
        {
            if (couleurTexture.r < 0.5 && couleurTexture.g < 0.5 && couleurTexture.b < 0.5)
            {
                discard;
            }       
        }
        else
        {
            FragColor *= couleurTexture;
        }
    }

}
