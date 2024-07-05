# -*- coding: utf-8 -*-
"""
Created on Thu May 23 14:54:54 2024

@author: cdanr
"""

import numpy as np
import lmfit as lm
import matplotlib.pyplot as plt
import pandas as pd

def hillEQ(x, kd, sat, n):
    return  sat * np.power(x, n)/(kd + np.power(x,n))



#Lifetime
x = np.array([ 1e-08, 32, 57, 79, 114, 227])
y = np.array( [3.8460216529509705,
  4.925653205062114,
  8.355608259625145,
  11.392211422527096,
  11.632525656432552,
  12.805698893595755])
yerr = np.array([0.6473692870235007,
  0.8385342674091036,
  1.353599237126805,
  2.3910489782479805,
  1.9632386668210933,
  2.2857010344757893])
y1 = y - y[0]
y1err = np.sqrt(yerr**2+yerr[0]**2)



hillEQ_model = lm.Model(hillEQ)
chi_min = []
red_chi = []
# n_values = np.linspace(1.48,2.32,100)
n_values = np.linspace(1,5,200)
for n in n_values:
    hillEQ_params = hillEQ_model.make_params(kd=1,sat=1)
    hillEQ_params['kd'].set(value=1,vary=True,min=0)
    hillEQ_params['n'].set(value=n,vary=False)
    resultEQ = hillEQ_model.fit(y1,x=x, params=hillEQ_params,weights=1/y1err)
    chi_min.append(resultEQ.chisqr)
    red_chi.append(resultEQ.redchi)
    
plt.figure()
plt.title('Hill Lifetime')
plt.plot(n_values,chi_min)
data = np.array([n_values,chi_min]).transpose()
df = pd.DataFrame(data,columns=['n values','chimin'])
df.to_csv('lifetime.csv')
# plt.axhline(y=0.90534755)
# plt.axhline(y=1.18)
# plt.ylim(0.9,1.9)
plt.xlabel('fixed N')
plt.ylabel('chisqr min')

# plt.figure()
# plt.plot(n_values,red_chi)
# plt.xlabel('fixed N')
# plt.ylabel('redchi min')

#Best fit
hillEQ_model = lm.Model(hillEQ)
hillEQ_params = hillEQ_model.make_params(kd=1,sat=1)
hillEQ_params['kd'].set(value=1,vary=True,min=0)
hillEQ_params['n'].set(value=3.4,vary=True,min=1,max=6)
resultEQ = hillEQ_model.fit(y1,x=x, params=hillEQ_params,weights=1/y1err)
print(resultEQ.fit_report())
# resultEQ.plot()
xmodel = np.linspace(x.min(),x.max(),100)
ymodel = hillEQ_model.eval(x=xmodel,params=resultEQ.params)
plt.figure()
plt.title('Data Lifetime')
plt.errorbar(x,y1,yerr=y1err,marker='o',linestyle='')
plt.plot(xmodel,ymodel)

dely = resultEQ.eval_uncertainty(x=x)
# plt.plot(x, y)
# plt.plot(x, resultEQ.best_fit)
# plt.fill_between(x, resultEQ.best_fit-dely,resultEQ.best_fit+dely, color='#888888')

#Normalizando

ynorm = y1/y1[-1]
ynorm_err = np.sqrt(y1err**2/y1[-1]**2+y1**2*y1err[-1]**2/y1[-1]**4)
ylog = np.log(ynorm/(1-ynorm))
ylog_err = np.sqrt(ynorm_err**2/((-1+ynorm)**2*ynorm**2))
ylog = ylog[1:-1]
ylog_err = ylog_err[1:-1]
xlog = np.log(x[1:-1])
lmodel = lm.models.LinearModel()
lmodel_params = lmodel.make_params(slope=3,b=0)
result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params,weights=1/ylog_err)
# result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params)
print(result_log.fit_report())

xmodel = np.linspace(xlog.min(),xlog.max(),100)
ymodel = lmodel.eval(x=xmodel,params=result_log.params)

plt.figure()
plt.title('LogLog Lifetime')
plt.errorbar(xlog,ylog,yerr=ylog_err,marker='o',linestyle='')
plt.plot(xmodel,ymodel)

chi_min = []
red_chi = []
for n in n_values:
    lmodel_params = lmodel.make_params(b=0)
    lmodel_params['slope'].set(value=n,vary=False)
    result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params,weights=1/ylog_err)
    chi_min.append(result_log.chisqr)

plt.figure()
plt.title('Slope Lifetime')
plt.plot(n_values,chi_min)
plt.xlabel('fixed N')
plt.ylabel('chisqr min')