#include <iostream>

int main() {
    for (;;) {
        int A, B, C, D;
        std::cout << "Enter D C B A values: ";
        std::cin >> D >> C >> B >> A;
        std::cout << "F0 = " << ((!A) && (!B) || B && (!D)) << std::endl;
        std::cout << "F1 = " << (((!A) || D) && ((!B) || C)) << std::endl;
    }
}
