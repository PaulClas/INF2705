#ifndef __POISSON_H__
#define __POISSON_H__

//
// un poisson
//
class Poisson
{
    static FormeCylindre *cylindre; // un cylindre centré dans l'axe des Z, de rayon 1, entre (0,0,0) et (0,0,1)
public:
    Poisson( float r = 1.0, float h = 0.0, float ang = 0.0, float vit = 1.0, float tai = 0.5, double rouge = 0.0, double g = 0.0, double b = 0.0 )
        : rayon(r), hauteur(h), angle(ang), vitesse(vit), taille(tai)
    {
        // créer un poisson graphique
        coulPoisson = glm::vec3(rouge,g,b);
        initialiserGraphique();
    }
    ~Poisson()
    {
        conclureGraphique();
    }
    void initialiserGraphique()
    {
        // créer quelques formes
        if ( cylindre == NULL ) cylindre = new FormeCylindre( 1.0, 1.0, 1.0, 12, 1, true );
    }
    void conclureGraphique()
    {
        delete cylindre;
    }
    
	//retourne le taux de rouge [0,255] (pour la sélection des poissons)
    int getTauxRouge(){
		return coulPoisson[0]*255;
	}

    void afficher()
    {
        matrModel.PushMatrix();{ // sauvegarder la tranformation courante

            // amener le repère à la position courante
            matrModel.Rotate( angle, 0, 0, 1 ); // tourner selon l'angle
            matrModel.Translate( rayon, 0.0, hauteur ); // se déplacer dans la direction de l'axe des X ainsi tourné
            matrModel.Rotate( 90, 0, 0, 1 ); // tourner le corps pour le mettre tangeant à la rotation

            // partie 2: modifs ici ...
            // donner la couleur de sélection

            // afficher le corps
            // (en utilisant le cylindre centré dans l'axe des Z, de rayon 1, entre (0,0,0) et (0,0,1))
            if(!Etat::enSelection){
				glm::vec3 coulCorps( 0.0, 1.0, 0.0 ); // vert
				glVertexAttrib3fv( locColor, glm::value_ptr(coulCorps) );
			} else {
				//std::cout<< glm::to_string(coulPoisson)<<std::endl;
				glVertexAttrib3fv( locColor, glm::value_ptr(coulPoisson) );
			}
            matrModel.PushMatrix();{
                matrModel.Scale( 5.0*taille, taille, taille );
                matrModel.Rotate( 90.0, 0.0, 1.0, 0.0 );
				if (vitesse > 0.0) matrModel.Rotate(180.0, 0.0, 1.0, 0.0);
                matrModel.Translate( 0.0, 0.0, -0.5 );
                glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel ); // ==> Avant de tracer, on doit informer la carte graphique des changements faits à la matrice de modélisation

                cylindre->afficher();
            }matrModel.PopMatrix(); glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );

            // afficher les yeux
            // (en utilisant le cylindre centré dans l'axe des Z, de rayon 1, entre (0,0,0) et (0,0,1))
            if(!Etat::enSelection){
				glm::vec3 coulYeux( 1.0, 1.0, 0.0 ); // jaune
				glVertexAttrib3fv( locColor, glm::value_ptr(coulYeux) );
			} else {
				glVertexAttrib3fv( locColor, glm::value_ptr(coulPoisson) );
			}
            matrModel.PushMatrix();{
                matrModel.Rotate( 90.0, 1.0, 0.0, 0.0 );
                matrModel.Scale( 0.5*taille, 0.5*taille, 2.0*taille );
                matrModel.Translate( vitesse > 0.0 ? 4.0 : -4.0, 0.2, -0.5 );
                glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );
                cylindre->afficher();
                matrModel.Translate( 0.0, 0.0, 2.0 );
            }matrModel.PopMatrix(); glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );

        }matrModel.PopMatrix(); glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );
        glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel ); // informer ...
    }

    void avancerPhysique()
    {
		if(!estSelectionne){ 
			angle += Etat::dt * vitesse;
		}
    }
    
    //inverse la valeur de estsélectionné
    void setEstSelectionne(){
		estSelectionne= !estSelectionne;
	//	estSelectionne=true;
	}
	
	glm::vec3 getCoulPoisson(){
		return coulPoisson;
	}

    // les variables du poisson
    bool estSelectionne = false;
	// couleur de sélection du poisson
    glm::vec3 coulPoisson;
    float rayon;          // en unités
    float hauteur;        // en unités
    float angle;          // en degrés
    float vitesse;        // en degrés/seconde
    float taille;         // en unités
};

FormeCylindre* Poisson::cylindre = NULL;

#endif
