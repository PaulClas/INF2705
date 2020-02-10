#include <cstdlib>
#if defined(__WIN32__)
#include <windows.h>
#endif
#include <GL/glut.h>
#include "Etat.h"

void initialisation( )
{
    glClearColor( 0.0, 0.0, 0.0, 1.0 );
    glEnable( GL_DEPTH_TEST );

    glMatrixMode( GL_PROJECTION );
    glLoadIdentity( );
    glFrustum( -3.0, 3.0, -3.0, 3.0, 4.0, 10.0 );
    glMatrixMode( GL_MODELVIEW );
}

// les différentes version de afficherModele() :
#include "afficherModele1.cpp"
#include "afficherModele2.cpp"
#include "afficherModele3.cpp"
#include "afficherModele4.cpp"

void afficherScene()
{
    switch ( Etat::pas )
    {
    case 1: afficherModele1(); break;
    case 2: afficherModele2(); break;
    case 3: afficherModele3(); break;
    case 4: afficherModele4(); break;
    }
    glutSwapBuffers ( );
}

void redimensionnement( GLsizei w, GLsizei h )
{
    glViewport( 0, 0, w, h );
}

void clavier( unsigned char touche, int x, int y )
{
    switch ( touche )
    {
    case 27:
    case 'q':
        exit( 0 );
        break;

    case ' ':
        Etat::enmouvement = !Etat::enmouvement;
        break;

    case '1': Etat::pas = 1; break;
    case '2': Etat::pas = 2; break;
    case '3': Etat::pas = 3; break;
    case '4': Etat::pas = 4; break;

    default:
        break;
    }
}

void clavierSpecial( int touche, int x, int y )
{
    switch ( touche )
    {
    case GLUT_KEY_UP:
        glutFullScreen( );
        break;
    case GLUT_KEY_DOWN:
        glutReshapeWindow( 500, 500 );
        break;
    default:
        break;
    }
}

int main ( int argc, char** argv )
{
    glutInit( &argc, argv );
    glutInitDisplayMode( GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE );
    glutInitWindowSize( 500, 500 );
    glutCreateWindow( "premiers pas" );
    initialisation();
    glutDisplayFunc( afficherScene );
    glutReshapeFunc( redimensionnement );
    glutKeyboardFunc( clavier );
    glutSpecialFunc( clavierSpecial );
    glutIdleFunc( afficherScene );
    glutMainLoop( );
    return(0);
}
