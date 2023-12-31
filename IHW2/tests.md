Тестовое покрытие (зависит от интервала):
1) $f(x) = 3 + 4x^{-2}$, интервал - [5,3]

  $\int_3^5 f(x)dx = 6.53333$
  
![](1.png)

Ответ с учетом точности 0.0001 верен.

2) $f(x) = 3 + 4x^{-2}$, интервал - [3,5](поменял местами границы)

$\int_5^3 f(x)dx = -6.53333$

![](2.png)

Тут тоже все верно.

3) $f(x) = $f(x) = 3 + 4x^{-2}$, интервал - [-3,-5] (отрицательные границы)$

$\int_{-3}^{-5} f(x)dx = -6.53333$

![](3.png)

И тут верно.

4) $f(x) = $f(x) = 3 + 4x^{-2}$, интервал - [-3,5]$


$\int_{-3}^5 f(x)dx = \infty$

![](4.png)

Тут бесконечность, тк есть выколотая точка  - 0 внутри интервала, т.е. функция не непрерывна на данном интервале.

5) Сравнение результатов тестовой программы и программы на С++:

![](5.png)

![](7.png)

Совпадает! (только вот на некоторых тестах может пройти около 30-60 сек, тк точность 0.0001 в некоторых случаях считается долго, так что не пугайтесь!)
