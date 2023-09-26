/// ex 1
//#include <iostream>
//using namespace std;
//
//struct TreeNode {
//    int val;
//    TreeNode* left;
//    TreeNode* right;
//
//    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
//};
//
//void printNodesAtLevel(TreeNode* root, int level, int currentLevel = 0) {
//    if (root == nullptr)
//        return;
//
//    if (currentLevel == level)
//        cout << root->val << " ";
//
//    printNodesAtLevel(root->left, level, currentLevel + 1);
//    printNodesAtLevel(root->right, level, currentLevel + 1);
//}
//
//int main() {
//    // Exemplu de arbore binar
//    TreeNode* root = new TreeNode(1);
//    root->left = new TreeNode(2);
//    root->right = new TreeNode(3);
//    root->left->left = new TreeNode(4);
//    root->left->right = new TreeNode(5);
//    root->right->left = new TreeNode(6);
//    root->right->right = new TreeNode(7);
//
//    int level = 1;
//
//    cout << "Nodurile de pe nivelul " << level << " sunt: ";
//    printNodesAtLevel(root, level);
//    cout << endl;
//
//    return 0;
//}


/// Ex 2
//#include <iostream>
//
//struct nod {
//    int val;
//    nod* prev;
//    nod* next;
//};
//
//nod* stanga = nullptr;
//nod* dreapta = nullptr;
//
//void inserareStanga(int numar) {
//    nod* nou = new nod;
//    nou->val = numar;
//    nou->prev = nullptr;
//    nou->next = stanga;
//
//    if (stanga != nullptr) {
//        stanga->prev = nou;
//    }
//
//    stanga = nou;
//
//    if (dreapta == nullptr) {
//        dreapta = nou;
//    }
//}
//
//void inserareDreapta(int numar) {
//    nod* nou = new nod;
//    nou->val = numar;
//    nou->prev = dreapta;
//    nou->next = nullptr;
//
//    if (dreapta != nullptr) {
//        dreapta->next = nou;
//    }
//
//    dreapta = nou;
//
//    if (stanga == nullptr) {
//        stanga = nou;
//    }
//}
//
//int extragereStanga() {
//    if (stanga == nullptr) {
//        std::cout << "Coada este goala!" << std::endl;
//        return -1; // Sau aruncați o excepție, în funcție de cerințe.
//    }
//
//    nod* nodExtras = stanga;
//    int valoareExtrasa = nodExtras->val;
//
//    stanga = stanga->next;
//
//    if (stanga != nullptr) {
//        stanga->prev = nullptr;
//    } else {
//        dreapta = nullptr;
//    }
//
//    delete nodExtras;
//
//    return valoareExtrasa;
//}
//
//int extragereDreapta() {
//    if (dreapta == nullptr) {
//        std::cout << "Coada este goala!" << std::endl;
//        return -1; // Sau aruncați o excepție, în funcție de cerințe.
//    }
//
//    nod* nodExtras = dreapta;
//    int valoareExtrasa = nodExtras->val;
//
//    dreapta = dreapta->prev;
//
//    if (dreapta != nullptr) {
//        dreapta->next = nullptr;
//    } else {
//        stanga = nullptr;
//    }
//
//    delete nodExtras;
//
//    return valoareExtrasa;
//}
//
//int main() {
//    inserareStanga(3);
//    inserareStanga(2);
//    inserareStanga(1);
//
//    inserareDreapta(4);
//    inserareDreapta(5);
//    inserareDreapta(6);
//
//    std::cout << extragereStanga() << std::endl; // Output: 1
//    std::cout << extragereDreapta() << std::endl; // Output: 6
//    std::cout << extragereStanga() << std::endl; // Output: 2
//    std::cout << extragereDreapta() << std::endl; // Output: 5
//    std::cout << extragereStanga() << std::endl; // Output: 3
//    std::cout << extragereDreapta() << std::endl; // Output: Coada este goala! / -1
//
//    return 0;
//}


/// ex 3
//#include <iostream>
//#include <vector>
//
//struct Element {
//    int valoare;
//    int prioritate;
//};
//
//class PriorityQueue {
//private:
//    std::vector<Element> heap;
//
//    // Funcție pentru a menține proprietatea de heap după inserare
//    void urca(int index) {
//        int parinte = (index - 1) / 2;
//        while (index > 0 && heap[index].prioritate < heap[parinte].prioritate) {
//            std::swap(heap[index], heap[parinte]);
//            index = parinte;
//            parinte = (index - 1) / 2;
//        }
//    }
//
//    // Funcție pentru a menține proprietatea de heap după extragere
//    void coboara(int index) {
//        int copilStanga = 2 * index + 1;
//        int copilDreapta = 2 * index + 2;
//        int minim = index;
//
//        if (copilStanga < heap.size() && heap[copilStanga].prioritate < heap[minim].prioritate) {
//            minim = copilStanga;
//        }
//
//        if (copilDreapta < heap.size() && heap[copilDreapta].prioritate < heap[minim].prioritate) {
//            minim = copilDreapta;
//        }
//
//        if (minim != index) {
//            std::swap(heap[index], heap[minim]);
//            coboara(minim);
//        }
//    }
//
//public:
//    bool isEmpty() {
//        return heap.empty();
//    }
//
//    void insert(int valoare, int prioritate) {
//        Element element;
//        element.valoare = valoare;
//        element.prioritate = prioritate;
//        heap.push_back(element);
//
//        int index = heap.size() - 1;
//        urca(index);
//    }
//
//    int extractMin() {
//        if (isEmpty()) {
//            std::cout << "Coada de prioritate este goala!" << std::endl;
//            return -1; // Sau aruncați o excepție, în funcție de cerințe.
//        }
//
//        int minim = heap[0].valoare;
//        heap[0] = heap.back();
//        heap.pop_back();
//
//        if (!isEmpty()) {
//            coboara(0);
//        }
//
//        return minim;
//    }
//};
//
//int main() {
//    PriorityQueue coadaPrioritate;
//
//    coadaPrioritate.insert(10, 3);
//    coadaPrioritate.insert(20, 1);
//    coadaPrioritate.insert(30, 2);
//
//    std::cout << coadaPrioritate.extractMin() << std::endl; // Output: 20
//    std::cout << coadaPrioritate.extractMin() << std::endl; // Output: 30
//    std::cout << coadaPrioritate.extractMin() << std::endl; // Output: 10
//
//    return 0;
//}
