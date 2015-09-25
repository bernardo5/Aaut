syms x y

f=symfun(((x^2)+(y^2))/2, [x y])
%f=symfun(x + y, [x y])

ezplot(f, [-10,10,-10,10,-10,10])