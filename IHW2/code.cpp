#include <iostream>
#include <cmath>

double f(double a, double b, double x) {
    return a + b * std::pow(x, -2);
}

double integrate(double a, double b, double x1, double x2) {
    double n = 2; // Кол-во отрезков/интервалов
    double h = (x2 - x1) / n; // Длина каждого отрезка
    double prev = 0; // предыдущий результат
    double curr = (h / 3) * (f(a, b, x1) + f(a, b, x2)); // текуший результат
    while (std::abs(curr - prev) > 0.0001) { //пока не достигли нужной нам точности
        prev = curr;
        double sum1 = 0; // первая новая сумма
        double sum2 = 0; // вторая новая сумма
        for (int i = 1; i <= n - 1; i++) { //суммируем
            double x = x1 + i * h; //подсчет узла
            if (i % 2 == 0) { //подсчет новых сумм
                sum2 += f(a, b, x);
            } else {
                sum1 += f(a, b, x);
            }
        }
        curr = prev / 2 + h / 3 * (sum1 + 2 * sum2); //считаем наш интеграл по формуле.
        n *= 2; // Увеличиваем количество отрезков в 2 раза и
        h /= 2;// Соответственно уменьшаем длину каждого в два раза
    }
    return curr;
}

int main() {
    double a, b, x1, x2;
    std::cin >> a >> b >> x1 >> x2;
    std::cout << integrate(a, b, x1, x2) << std::endl;
    return 0;
}
