var types = [int, float, bigint, bigfloat]
var x = 10
var y = 10

for a in types {
	for b in types {
		var X = a(x)
		var Y = b(y)
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", X, " >  ", Y, " ",X> Y, "\n"
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", X, " <  ", Y, " ",X< Y, "\n"
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", X, " >= ", Y, " ",X>=Y, "\n"
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", X, " <= ", Y, " ",X<=Y, "\n"
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", x, " == ", y, " ",x==y, "\n"
		// sysout typeof(X)[:2], " ", typeof(Y)[:2], " ", x, " != ", y, " ",x==y, "\n"
		// println()
		print(typeof(X)[:2], typeof(Y)[:2], " ")
		print((x>y)==(X>Y), (x<y)==(X<Y), (x>=y)==(X>=Y), (x<=y)==(X<=Y), (x==y)==(X==Y), (x!=y)==(X!=Y))
		println()
		// println((x>y)==(X>Y), (x<y)==(X<Y), (x>=y)==(X>=Y), (x<=y)==(X<=Y))
		
	}
}