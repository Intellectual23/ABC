#include <iostream>
#include <cmath>

double integrate(double a, double b, double x1, double x2) {
    double n = 2; // initial number of intervals
    double h = (x2 - x1) / n;
    double integral_prev = 0; // previous approximation
    double integral_curr = h / 3 * (a + b * std::pow(x1, -2) + a + b * std::pow(x2, -2)); // current approximation

    while (std::abs(integral_curr - integral_prev) > 0.0001) {
        integral_prev = integral_curr;
        double sum1 = 0; // sum of f(x_i-1) values
        double sum2 = 0; // sum of f(x_i-1/2) values

        for (int i = 1; i <= n - 1; i++) {
            double x = x1 + i * h;
            if (i % 2 == 0) {
                sum2 += a + b * std::pow(x, -2);
            } else {
                sum1 += a + b * std::pow(x, -2);
            }
        }

        integral_curr = integral_prev / 2 + h / 3 * (sum1 + 2 * sum2);
        n *= 2;
        h /= 2;
    }

    return integral_curr;
}

int main() {
    double a, b, x1, x2;;
    std::cin >> a >> b >> x1 >> x2;
    double result = integrate(a, b, x1, x2);
    std::cout << result << std::endl;
    return 0;
}
