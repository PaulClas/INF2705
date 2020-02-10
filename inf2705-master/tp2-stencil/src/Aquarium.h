#ifndef __AQUARIUM_H__
#define __AQUARIUM_H__

#include <vector>
#include <iterator>
#include <iostream>

//
// l'aquarium
//
class Aquarium
{
    static FormeCube *cubeFil;
    static FormeCube *cube;
public:
    Aquarium( )
        : locplanDragage(-1), locplanRayonsX(-1), locattenuation(-1)
    {
        // les positions des 25 poissons
        glm::vec3 pos[] =
        {
            glm::vec3( 0.0,  6.8,  0.0 ),
            glm::vec3( 0.0,  0.3,  2.1 ),
            glm::vec3( 0.0, -3.3,  0.0 ),
            glm::vec3( 0.0,  0.2,  5.3 ),
            glm::vec3( 0.0,  3.3,  2.4 ),
            glm::vec3( 0.0,  6.4,  2.8 ),
            glm::vec3( 0.0, -6.5, -5.3 ),
            glm::vec3( 0.0,  0.0,  0.0 ),
            glm::vec3( 0.0, -6.6, -2.5 ),
            glm::vec3( 0.0, -6.5,  2.7 ),
            glm::vec3( 0.0, -3.3, -5.7 ),
            glm::vec3( 0.0,  3.3, -5.2 ),
            glm::vec3( 0.0,  6.2, -2.5 ),
            glm::vec3( 0.0,  3.2, -2.2 ),
            glm::vec3( 0.0, -6.7,  0.0 ),
            glm::vec3( 0.0, -3.5, -2.5 ),
            glm::vec3( 0.0,  3.7,  0.0 ),
            glm::vec3( 0.0,  3.8,  5.3 ),
            glm::vec3( 0.0, -6.1,  5.3 ),
            glm::vec3( 0.0, -3.3,  5.1 ),
            glm::vec3( 0.0,  6.5,  5.1 ),
            glm::vec3( 0.0,  6.1, -5.3 ),
            glm::vec3( 0.0,  0.0, -5.3 ),
            glm::vec3( 0.0,  0.1, -2.5 ),
            glm::vec3( 0.0, -3.4,  2.2 ),
        };

        // créer un aquarium graphique
        initialiserGraphique();

        // initialiser la génération de valeurs aléatoires pour la création de poissons
        srand( time(NULL) );

        // remplir l'aquarium
        for ( unsigned int i = 0 ; i < sizeof(pos)/sizeof(pos[0]) ; ++i )
        {
            // donner position aléatoire en x
            pos[i].x = glm::mix( -0.9*Etat::bDim.x, 0.9*Etat::bDim.x, rand()/((double)RAND_MAX) );
            // donner vitesse aléatoire en x
            glm::vec3 vit = glm::vec3( glm::mix( -0.2, 0.2, rand()/((double)RAND_MAX) ), 0.0, 0.0 );
            vit.x += 0.1 * glm::sign(vit.x); // ajouter ou soustraire 0.1 selon le signe de vx afin d'avoir : 0.1 <= abs(vx) <= 0.3
            // donner taille aléatoire
            float taille = glm::mix( 0.5 , 0.9, rand()/((double)RAND_MAX) );

            // créer un nouveau poisson
            Poisson *p = new Poisson( pos[i], vit, taille );

            // assigner une couleur de sélection
            // partie 2: modifs ici ...
            GLubyte couleur[3] = { (unsigned char)(i * 10), 0, 0 };
            p->setCouleur(couleur);
            // ajouter ce poisson dans la liste
            this->poissons.push_back( p );
        }

        // créer quelques autres formes
        if ( cubeFil == NULL ) cubeFil = new FormeCube( 2.0, false );
        if ( cube == NULL ) cube = new FormeCube( 2.0 );
    }
    ~Aquarium()
    {
        conclureGraphique();
        // vider l'aquarium
        while ( !poissons.empty() ) poissons.pop_back( );
    }
    void initialiserGraphique()
    {
        GLint prog = 0; glGetIntegerv( GL_CURRENT_PROGRAM, &prog );
        if ( prog <= 0 )
        {
            std::cerr << "Pas de programme actif!" << std::endl;
            locVertex = locColor = -1;
            return;
        }
        if ( ( locVertex = glGetAttribLocation( prog, "Vertex" ) ) == -1 ) std::cerr << "!!! pas trouvé la \"Location\" de Vertex" << std::endl;
        if ( ( locColor = glGetAttribLocation( prog, "Color" ) ) == -1 ) std::cerr << "!!! pas trouvé la \"Location\" de Color" << std::endl;
        if ( ( locplanDragage = glGetUniformLocation( prog, "planDragage" ) ) == -1 ) std::cerr << "!!! pas trouvé la \"Location\" de planDragage" << std::endl;
        if ( ( locplanRayonsX = glGetUniformLocation( prog, "planRayonsX" ) ) == -1 ) std::cerr << "!!! pas trouvé la \"Location\" de planRayonsX" << std::endl;
        if ( ( locattenuation = glGetUniformLocation( prog, "attenuation" ) ) == -1 ) std::cerr << "!!! pas trouvé la \"Location\" de attenuation" << std::endl;

        // les valeurs à utiliser pour tracer le quad
        GLfloat coo[] = { -1,  1, 0,
                           1,  1, 0,
                           1, -1, 0,
                          -1, -1, 0 };
        const GLuint connec[] = { 0, 1, 2, 2, 3, 0 };

        vao = vbo[0] = vbo[1] = 0;
        // *** l'initialisation des objets graphiques doit être faite seulement après l'initialisation de la fenêtre graphique

        // partie 1: initialiser le VAO (pour le quad de l'aquarium)
        glBindVertexArray( vao );

        // partie 1: créer les deux VBO pour les sommets et la connectivité
        glGenBuffers(1, &(this->vbo[0]));
        glBindBuffer(GL_ARRAY_BUFFER, this->vbo[0]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(coo), coo, GL_STATIC_DRAW);

        // créer le VBO la connectivité
        glGenBuffers(1, &(this->vbo[1]));
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this->vbo[1]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(connec), connec, GL_STATIC_DRAW);

        glVertexAttribPointer( locVertex, 3, GL_FLOAT, GL_FALSE, 0, 0 );
        glEnableVertexAttribArray( locVertex );
    }
    void conclureGraphique()
    {
        glDeleteBuffers( 2, vbo );
        glDeleteVertexArrays( 1, &vao );
        delete cubeFil;
        delete cube;
    }

    void afficherParois()
    {
        // tracer les parois de verre de l'aquarium
        glEnable( GL_CULL_FACE ); glCullFace( GL_FRONT ); // ne pas afficher les faces avant
        glVertexAttrib3f( locColorBase, 0.1, 0.1, 0.3 ); // bleuté
        matrModel.PushMatrix();{
            matrModel.Scale( Etat::bDim.x, Etat::bDim.y, Etat::bDim.z );
            glUniformMatrix4fv( locmatrModelBase, 1, GL_FALSE, matrModel );
            cube->afficher();
        }matrModel.PopMatrix(); glUniformMatrix4fv( locmatrModelBase, 1, GL_FALSE, matrModel );
        glDisable( GL_CULL_FACE );

        // tracer les coins de l'aquarium
        glVertexAttrib3f( locColorBase, 1.0, 1.0, 1.0 ); // blanc
        matrModel.PushMatrix();{
            matrModel.Scale( 0.999*Etat::bDim.x, 0.999*Etat::bDim.y, 0.999*Etat::bDim.z ); // légèrement à l'intérieur
            glUniformMatrix4fv( locmatrModelBase, 1, GL_FALSE, matrModel );
            cubeFil->afficher();
        }matrModel.PopMatrix(); glUniformMatrix4fv( locmatrModelBase, 1, GL_FALSE, matrModel );
    }

    void afficherPlan( GLfloat alpha ) // le plan qui ferme les solides
    {
        glVertexAttrib4f( locColor, 1.0, 1.0, 1.0, alpha );
        // afficher le plan mis à l'échelle, tourné selon l'angle courant et à la position courante
        // partie 1: modifs ici ...
        glEnable( GL_BLEND );
        matrModel.PushMatrix();
        {
            matrModel.Rotate( Etat::angleDragage, 0.0, 1.0, 0.0 );
            matrModel.Translate( 0.0, 0.0, Etat::planDragage.w );
            matrModel.Scale( Etat::bDim[0], Etat::bDim[1], Etat::bDim[2] );
            glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );
            glBindVertexArray( vao );
            glDrawElements( GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0 );
        }
        matrModel.PopMatrix();
        glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );
        glDisable( GL_BLEND );
    }

    void afficherTousLesPoissons()
    {
        glVertexAttrib4f( locColor, 1.0, 1.0, 1.0, 1.0 );

        for ( std::vector<Poisson*>::iterator it = poissons.begin() ; it != poissons.end() ; it++ )
        {
            (*it)->afficher();
        }
    }

    // afficher les poissons
    void afficherFaune()
    {
        // partie 1: modifs ici ...
        // afficher les poissons en plein et en fil de fer en tenant compte du plan de rayonsX,
        // puis tenir compte aussi du plan de dragage

        // activer les plans de coupe et afficher la scène normalement
        // partie 1: modifs ici ...
        // affiche tous les poissons
        glEnable( GL_CLIP_PLANE2 );
        {
            // affiche les poissons en fil de fer
            glEnable( GL_CLIP_PLANE0 );
            {
                // glStencilFunc( GL_EQUAL, 1, 1 ); // ?
                if (!Etat::modeSelection)
                {
                    glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );
                }
                // glVertexAttrib3f( locColor, 0.0, 1.0, 0.0 );

                afficherTousLesPoissons();

                // glStencilFunc( GL_EQUAL, 0, 1 ); // ?
                glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
                // glVertexAttrib3f( locColor, 1.0, 0.0, 0.0 );
            }
            glDisable( GL_CLIP_PLANE0 );

            // affiche les poissons plein
            glEnable( GL_CLIP_PLANE1 );
            {
                afficherTousLesPoissons();
            }
            glDisable( GL_CLIP_PLANE1 );

            // affiche la fermeture des poissons
            glEnable( GL_STENCIL_TEST );
            {
                glColorMask( GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE );
                glDisable( GL_DEPTH_TEST );
                glEnable( GL_CULL_FACE );
                {
                    glStencilFunc( GL_ALWAYS, 1, 0xFF );
                    glCullFace( GL_FRONT );
                    {
                        glStencilOp( GL_KEEP, GL_KEEP, GL_INCR );
                        afficherTousLesPoissons();
                    }

                    glCullFace( GL_BACK );
                    {
                        glStencilOp( GL_KEEP, GL_KEEP, GL_DECR );
                        afficherTousLesPoissons();
                    }
                }
                glColorMask( GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE );
                glEnable( GL_DEPTH_TEST );
                glDisable( GL_CULL_FACE );

                // afficher les quadrilateres
                glStencilFunc( GL_NOTEQUAL, 0, 0xFF );
                if (!Etat::modeSelection)
                {
                    this->afficherPlan(1.0);
                }
            }
            glDisable( GL_STENCIL_TEST );
        }
        glDisable( GL_CLIP_PLANE2 );
    }

    // afficher le contenu de l'aquarium
    void afficher()
    {
        // tracer les parois de l'aquarium avec le programme de nuanceur de base
        glUseProgram( progBase );
        if (!Etat::modeSelection)
        {
            afficherParois( );
        }

        // tracer le reste de l'aquarium avec le second programme de nuanceur
        glUseProgram( prog );
        glUniformMatrix4fv( locmatrProj, 1, GL_FALSE, matrProj );
        glUniformMatrix4fv( locmatrVisu, 1, GL_FALSE, matrVisu );
        glUniformMatrix4fv( locmatrModel, 1, GL_FALSE, matrModel );
        // La valeur w de la variable planDragage est la position du plan en Z, c'est-à-dire Z = w.
        // Il faut donc inverser le signe de w dans l'équation du plan de coupe à transmettre au nuanceur afin d'avoir Ax+By+Cz-w=0 :
        glm::vec4 planD = Etat::planDragage; planD.w = -planD.w;
        glUniform4fv( locplanDragage, 1, glm::value_ptr(planD) );
        // La valeur w de la variable planRayonsX est la position du plan en X, c'est-à-dire X = w.
        // Il faut donc inverser le signe de w dans l'équation du plan de coupe à transmettre au nuanceur afin d'avoir Ax+By+Cz-w=0 :
        glm::vec4 planR = Etat::planRayonsX; planR.w = -planR.w;
        glUniform4fv( locplanRayonsX, 1, glm::value_ptr(planR) );

        glUniform1i( locattenuation, Etat::attenuation );

        // afficher les poissons
        afficherFaune();

        // en plus, dessiner le plan de dragage en transparence pour bien voir son étendue
        if (!Etat::modeSelection)
        {
            afficherPlan( 0.25 );
        }
    }

    // sélectionner un poisson
    void selectionnerPoisson()
    {
        // partie 2: modifs ici ...
        GLint cloture[4];
        glGetIntegerv(GL_VIEWPORT, cloture);

        GLubyte couleur[3];
        glReadPixels(Etat::sourisPosPrec[0], cloture[3] - Etat::sourisPosPrec[1], 1, 1, GL_RGB, GL_UNSIGNED_BYTE, couleur);
        
        std::cout<< (unsigned)couleur[0] << std::endl;
        this->poissons[(unsigned)(couleur[0] / 10)]->toggleEstSelectionne();
    }

    void calculerPhysique()
    {
        if ( Etat::enmouvement )
        {
            for ( std::vector<Poisson*>::iterator it = poissons.begin() ; it != poissons.end() ; it++ )
            {
                (*it)->avancerPhysique();
            }
#if 1
            // Quelques déplacements automatiques pour la démo :
            static int sens[6] = { +1, +1, +1, +1, +1, +1 };
            glm::vec3 vitesse( 0.03, 0.02, 0.05 );
            // la distance de RayonsX
            if ( Etat::planRayonsX.w <= -4.0 ) sens[0] = +1.0;
            else if ( Etat::planRayonsX.w >= 4.0 ) sens[0] = -1.0;
            Etat::planRayonsX.w += 0.05 * sens[0];
            // la hauteur de dragage
            if ( Etat::planDragage.w <= -4.0 ) sens[1] = +1.0;
            else if ( Etat::planDragage.w >= 4.0 ) sens[1] = -1.0;
            Etat::planDragage.w += 0.03 * sens[1];
            // l'angle de dragage
            if ( Etat::angleDragage <= -10.0 ) sens[2] = +1.0;
            else if ( Etat::angleDragage >= 10.0 ) sens[2] = -1.0;
            Etat::angleDragage += 0.05 * sens[2];
            Etat::planDragage.x = sin(glm::radians(Etat::angleDragage));
            Etat::planDragage.z = cos(glm::radians(Etat::angleDragage));
#endif
        }
    }

    // utilisation de vbo et vao
    GLuint vao;
    GLuint vbo[2];
    GLint locplanDragage;
    GLint locplanRayonsX;
    GLint locattenuation;

    // la liste des poissons
    std::vector<Poisson*> poissons;
    // std::vector<glm::vec3> couleurs;
};

FormeCube* Aquarium::cubeFil = NULL;
FormeCube* Aquarium::cube = NULL;

#endif