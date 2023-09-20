#include <iostream>

int main() {
    int n = 0, d = 0;
    std::cin >> n >> d;
    std::cout << n / d << " " << n % d << std::endl;
    int q = 0, m = 1;
    if (d < 0) {
        d *= -1;
        m = -1;
    }
    if (n > 0) {
        while (n - d >= 0) {
            n -= d;
            q += m;
        }
    } else {
        m *= -1;
        while (n + d <= 0) {
            n += d;
            q += m;
        }
    }
    std::cout << q << " " << n;
    return 0;
}
