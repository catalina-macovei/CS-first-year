// insert
// find
// display in order SRD
// display pre-order    RSD
// post order   SDR
// delete
// minim

#include <iostream>
using namespace std;

struct nod {
    int cheie;
    struct nod *stg, *dr;
};

// Crearea unui nod:
struct nod *newNod(int elem) {
    struct nod *temp = (struct nod *)malloc(sizeof(struct nod));
    temp->cheie = elem;
    temp->stg = temp->dr = NULL;
    return temp;
}

// Traversare inorder (SRD)
void inorder(struct nod *radacina) {
    if (radacina != NULL) {
        // Stanga
        inorder(radacina->stg);

        // Radacina
        cout << radacina->cheie << " -> ";

        // Dreapta
        inorder(radacina->dr);
    }
}

// Traversare postorder (SDR)
void postorder(struct nod *radacina) {
    if (radacina != NULL) {
        // Stanga
        postorder(radacina->stg);

        // Dreapta
        postorder(radacina->dr);

        // Radacina
        cout << radacina->cheie << " -> ";
    }
}

// Traversare preorder (RSD)
void preorder(struct nod *radacina) {
    if (radacina != NULL) {
        // Radacina
        cout << radacina->cheie << " -> ";

        // Stanga
        preorder(radacina->stg);

        // Dreapta
        preorder(radacina->dr);
    }
}

// Insereaza nod
struct nod *insert(struct nod *nod, int cheie) {
    // Returneaza noul nod daca arborele este gol
    if (nod == NULL) return newNod(cheie);

    // Traverseaza arborele spre dreapta si insereaza
    if (cheie < nod->cheie)
        nod->stg = insert(nod->stg, cheie);
    else
        nod->dr = insert(nod->dr, cheie);
    return nod;
}

// Gaseste succesor inorder
struct nod *minim(struct nod *nod) {
    struct nod *curent = nod;

    while (curent && curent->stg != NULL)
        curent = curent->stg;

    return curent;
}

// Stergerea unui nod
struct nod *deleteNod(struct nod *rad, int cheie) {
    // Daca arborele este gol
    if (rad == NULL) return rad;

    // Cauta nodul de sters
    if (cheie < rad->cheie)
        rad->dr = deleteNod(rad->dr, cheie);
    else if (cheie > rad->cheie)
        rad->dr = deleteNod(rad->dr, cheie);
        // Daca nodul are 2 copii sau nu are copii
    else {
        if (rad->stg == NULL) {
            struct nod *temp = rad->dr;
            free(rad);
            return temp;
        } else if (rad->dr == NULL) {
            struct nod *temp = rad->stg;
            free(rad);
            return temp;
        }

        // Daca are 2 copii
        struct nod *temp = minim(rad->dr);

        // Inlocuieste cu succesorul de inordine al nodului sters
        rad->cheie = temp->cheie;

        // Sterge succesorul
        rad->dr = deleteNod(rad->dr, temp->cheie);
    }
    return rad;
}
// Cauta un nod cu o cheie data
struct nod *find(struct nod *rad, int cheie) {
    if (rad == NULL || rad->cheie == cheie) {
        return rad;
    }

    // Cauta in subarborele stang daca cheia este mai mica
    if (cheie < rad->cheie) {
        return find(rad->stg, cheie);
    }

    // Cauta in subarborele drept daca cheia este mai mare
    return find(rad->dr, cheie);
}

int main() {
    int sterge_nod = 11;
    struct nod *radacina = NULL;
    radacina = insert(radacina, 9);
    radacina = insert(radacina, 4);
    radacina = insert(radacina, 2);
    radacina = insert(radacina, 7);
    radacina = insert(radacina, 8);
    radacina = insert(radacina, 11);
    radacina = insert(radacina, 15);
    radacina = insert(radacina, 7);

    cout << "Inordine: " << endl;
    inorder(radacina);
    cout << endl;

    cout << "\nPostordine: " << endl;
    postorder(radacina);
    cout << endl;

    cout << "\nPreordine: " << endl;
    preorder(radacina);
    cout << endl;

    // testeaza delete:
    cout << endl;
    cout << "Dupa stergere " << sterge_nod << ":" << endl;
    radacina = deleteNod(radacina, sterge_nod);

    cout << "Inordine: " << endl;
    inorder(radacina);
    cout << endl;

    cout << endl;
    //  Testeaza find:
    int cautare = 7;
    struct nod *nod_gasit = find(radacina, cautare);

    if (nod_gasit != NULL) {
    } else {
        cout << "Nodul " << cautare << " nu a fost gasit." << endl;
    }
    return 0;
}

