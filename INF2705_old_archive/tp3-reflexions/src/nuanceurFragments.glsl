#version 410

// Définition des paramètres des sources de lumière
layout(std140) uniform LightSourceParameters {
  vec4 ambient[3];
  vec4 diffuse[3];
  vec4 specular[3];
  vec4 position[3]; // dans le repère du monde
}
LightSource;

// Définition des paramètres des matériaux
layout(std140) uniform MaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
}
FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout(std140) uniform LightModelParameters {
  vec4 ambient; // couleur ambiante globale
  bool twoSide; // éclairage sur les deux côtés ou un seul?
}
LightModel;

layout(std140) uniform varsUnif {
  // partie 1: illumination
  int typeIllumination; // 0:Gouraud, 1:Phong
  bool utiliseBlinn; // indique si on veut utiliser modèle spéculaire de Blinn
                     // ou Phong
  bool afficheNormales; // indique si on utilise les normales comme couleurs
                        // (utile pour le débogage)
  // partie 2: texture
  int numTexCoul;        // numéro de la texture de couleurs appliquée
  int numTexNorm;        // numéro de la texture de normales appliquée
  int afficheTexelFonce; // un texel foncé doit-il être affiché 0:normalement,
                         // 1:mi-coloré, 2:transparent?
    
    //partie 3: tesselation
    int tesselation;
    
    //test du decalage de texture
    float decalage;
};

uniform sampler2D laTextureCoul;
uniform sampler2D laTextureNorm;

/////////////////////////////////////////////////////////////////

in Attribs {
  vec4 couleur;
  vec3 normale;
  vec3 lumiDir[3];
  vec3 obsVec;
  vec2 texCoord;
}
AttribsIn;

out vec4 FragColor;

// pour la lumière j
vec4 calculerReflexion(in int j, in vec3 L, in vec3 N, in vec3 O) {
  vec4 coul = FragColor;

  // calcul de l'éclairage seulement si le produit scalaire est positif
  float NdotL = max(0.0, dot(N, L));
  if (NdotL > 0.0) {
    // calcul de la composante diffuse
    // coul += FrontMaterial.diffuse * LightSource.diffuse * NdotL;
    // (ici, on utilise plutôt la couleur de l'objet)
    coul += FrontMaterial.diffuse * LightSource.diffuse[j] * NdotL;

    // calcul de la composante spéculaire (Blinn ou Phong)
    float NdotHV = max(0.0, (utiliseBlinn) ? dot(normalize(L + O), N)
                                           : dot(reflect(-L, N), O));
    coul += FrontMaterial.specular * LightSource.specular[j] *
            ((NdotHV <= 0.0) ? 0.0 : pow(NdotHV, FrontMaterial.shininess));
  }
  // assigner la couleur finale
  return coul;
}

vec3 modifierNormale(in vec3 N, in vec3 dN) {
  return normalize(N + dN);
}

void main(void) {
  FragColor = AttribsIn.couleur;
  
  // Partie 4:
  // Placage de texture avec offset
  vec3 texOffset = texture(laTextureNorm, AttribsIn.texCoord).rgb;
  vec3 dN = normalize((texOffset - 0.5) * 2.0);
  vec3 normale = AttribsIn.normale;
  if ( numTexNorm != 0 ) {
    normale = modifierNormale(AttribsIn.normale, dN);
  }

  // Gouraud
  if (typeIllumination == 0) {
    FragColor = AttribsIn.couleur;
    // Phong
  } else {
    if (gl_FrontFacing) {
      FragColor =
        (FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient) +
        LightSource.ambient[0] * FrontMaterial.ambient +
        LightSource.ambient[1] * FrontMaterial.ambient +
        LightSource.ambient[2] * FrontMaterial.ambient;

      for (int i = 0; i < 3; i++) {
        FragColor = calculerReflexion(i, normalize(AttribsIn.lumiDir[i]),
                                      normalize(normale),
                                      normalize(AttribsIn.obsVec));
        }
      FragColor = clamp(FragColor, 0.0, 1.0);
    }
  }

  if (numTexCoul != 0) {    
    vec4 couleurTexture = texture(laTextureCoul, AttribsIn.texCoord);
    if (numTexCoul == 2) {
      // Normal
      if (afficheTexelFonce == 0) {
        if (length(couleurTexture.rgb) < 0.5) {
          FragColor = couleurTexture;
        }
        // Mi-coloré
      } else if (afficheTexelFonce == 1) {
        if (length(couleurTexture.rgb) < 0.5) {
          FragColor = (FragColor + couleurTexture) / 2;
        }
        // Transparent
      } else {
        if (length(couleurTexture.rgb) < 0.5) {
          discard;
        }
      }
    } else {
      FragColor = FragColor * couleurTexture;
    }
  }
}
