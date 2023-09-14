Отчёт:
1) Рассмотрим первую программу, ассемблируем код:
<img width="770" alt="image" src="https://github.com/Intellectual23/ABC/assets/68235201/b8a14467-2d8c-4d89-932e-5923d2d44d9e">

2) Запускаем программу, вводим два числа, 3 и 5, их сумма - 8 в регистре a0:
<img width="327" alt="image" src="https://github.com/Intellectual23/ABC/assets/68235201/0ebfc38c-f182-48d6-8142-3fe7271c2ead">
<img width="275" alt="image" src="https://github.com/Intellectual23/ABC/assets/68235201/1a9bfc00-1b03-44af-8cf2-8a1b3b5fd97f">

3) Псевдоинструкции:
- li      a7 5
- mv      t0 a0
- li      a7 1
- li      a7 10
4) Типы комманд:
  - 1: i-type
  - 2: ecall
  - 3: r-type
  - 4 ecall
  - 5: r-type
  - 6: i-type
  - 7: ecall
  - 8: i-type
  - 9: ecall
5) Системные вызовы в программах:
- 5: ReadInt
- 1: PrintInt
- 10: Exit
- 4: PrintString
