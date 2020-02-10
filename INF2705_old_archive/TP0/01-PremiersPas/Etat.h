#ifndef __ETAT_H__
#define __ETAT_H__

#include "Singleton.h"

//
// variables d'état
//
class Etat : public Singleton<Etat>
{
    SINGLETON_DECLARATION_CLASSE(Etat);
public:
    static int pas;           // le pas courant
    static bool enmouvement;  // le modèle est en mouvement/rotation automatique ou non
};

#endif
