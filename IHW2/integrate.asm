.data
accuracy: .double 0.0001
.text
.globl integrate
.include "macrolib.asm"
integrate:
	push_int(ra) # Сохраняю на стек регистр-адрес и входные параметры 
	push_double(fa1) #a
	push_double(fa2) #b
	push_double(fa3) #x1
	push_double(fa4) #x2
	push_double(fs1) # Сохраняю на стек локальные переменные подпрограммы
	push_double(fs2)
	push_double(fs3)
	push_double(fs4)
	push_double(fs5)
	push_double(fs6)
	fld ft5 accuracy t5 # вводим точность 0.0001
	
	li t0 2
	fcvt.d.w fs1, t0 #n = 2 - количество отрезков
	
	fsub.d fs2, fa4, fa3
	fdiv.d fs2 fs2 fs1 # h = (x2 - x1) / n - длина каждого отрезка
	#fs3 - prev
	func(fa1, fa2,fa3) # считаем cur
	fmv.d fs4 fa0
	func(fa1,fa2,fa4)
	fadd.d fs4 fs4 fa0
	fmul.d fs4 fs4 fs2
	li t0 3
	fcvt.d.w ft0, t0
	fdiv.d fs4 fs4 ft0 # cur = h/3 * (f(x1) + f(x2)))
	
	while:
		fsub.d ft2 fs4 fs3
		fabs.d ft2 ft2
		fge.d t3 ft5 ft2
		bnez t3 end_while # проверяем что |cur - prev| < 0.0001 - проверка на точность
		fmv.d fs3 fs4 #prev = cur
		li t0 0
		fcvt.d.w fs5 t0 # sum1 = 0 - вводим две новые суммы
		fcvt.d.w fs6 t0 # sum2 = 0
		li t1 1
		fcvt.d.w ft1, t1 # счётчики цикла, для удобства один - double, второй - int
		for: 
			feq.d t2 ft1 fs1 # i от 1 до n 
			bnez t2 end_for
			
			fmul.d ft3 ft1 fs2
			fadd.d ft3 ft3 fa3 #подсчет узла x = x1 + i*h
			
			func(fa1, fa2, ft3) #cуммируем в зависимости от четности индекса
			li t0 2
			rem t3 t1 t0
			if_ev: bnez t3 else
				fadd.d fs6 fs6 fa0
				j next
			else:
				fadd.d fs5 fs5 fa0
				
			next: #увеличиваем счетчики -> следующая итерация
				addi t1 t1 1
				fcvt.d.w ft1, t1
				j for
			end_for:
			
		fadd.d fs4 fs5 fs6 # Пересчитываем наш интеграл cur 
		fadd.d fs4 fs4 fs6 
		fmul.d fs4 fs4 fs2
		li t0 3
		fcvt.d.w ft0, t0
		fdiv.d fs4 fs4 ft0
		li t0 2
		fcvt.d.w ft0, t0
		fmv.d ft4 fs3
		fdiv.d ft4 ft4 ft0
		fadd.d fs4 fs4 ft4 # curr = prev / 2 + h / 3 * (sum1 + 2 * sum2);
		
		fmul.d fs1 fs1 ft0 # n*=2 - увеличиваем кол-во отрезков в 2 раза
		fdiv.d fs2 fs2 ft0 # h/=2 - уменьшаем длину каждого отрезка в 2 раза
		j while
	end_while: #восстанавливаем регистры со стека и возвращаем результат  в регистре fa0
	fmv.d fa0 fs4
	pop_double(fs6)
	pop_double(fs5)
	pop_double(fs4)
	pop_double(fs3)
	pop_double(fs2)
	pop_double(fs1)
	pop_double(fa4)
	pop_double(fa3)
	pop_double(fa2)
	pop_double(fa1)
	pop_int(ra)
	ret
