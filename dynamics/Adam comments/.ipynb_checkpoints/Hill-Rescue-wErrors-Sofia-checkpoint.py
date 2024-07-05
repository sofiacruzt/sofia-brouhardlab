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

#Intensity
# x = np.array([  5.,  30.,  60.,  80., 115., 230., 500.])
# y = np.array([ 0.99261538, 17.76513846, 23.23455932, 26.60839726, 36.46577528, 42.4960687 , 39.87481034])
# yerr = np.array([ 0.27976167,  4.55995503,  8.04855477,  7.43265278, 12.91246145,
#         16.15575718, 15.96253172])

#Lifetime
# x = np.array([ 1e-08, 32, 57, 79, 114, 227])
# y = np.array([1e-08   , 1.07963155, 4.50958661, 7.54618977, 7.786504  ,
#         8.95967724])
# yerr = np.array([0.6473692870235007,
#   0.8385342674091036,
#   1.353599237126805,
#   2.3910489782479805,
#   1.9632386668210933,
#   2.2857010344757893])

#Rescue
x = np.array([ 1e-08, 32, 57, 79, 114, 227])
y = np.array([0.0049583555887541,
  0.0625344261041309,
  0.110049387662098,
  0.2736689876769317,
  0.3199057390068016,
  0.4123348402146009])
yerr = np.array([0.0002424560338569,
  0.0032544503129795,
  0.0037094073982605,
  0.0117578563350252,
  0.0127183705656803,
  0.0194419840184191])

hillEQ_model = lm.Model(hillEQ)
chi_min = []
red_chi = []
# n_values = np.linspace(1.48,2.32,100)
n_values = np.linspace(1,3,200)
for n in n_values:
    hillEQ_params = hillEQ_model.make_params(kd=1,sat=1)
    hillEQ_params['kd'].set(value=1,vary=True,min=0)
    hillEQ_params['n'].set(value=n,vary=False)
    resultEQ = hillEQ_model.fit(y,x=x, params=hillEQ_params,weights=1/yerr)
    chi_min.append(resultEQ.chisqr)
    red_chi.append(resultEQ.redchi)
    
plt.figure()
plt.title('Hill')
plt.plot(n_values,chi_min)
plt.xlabel('fixed N')
plt.ylabel('chisqr min')
data = np.array([n_values,chi_min]).transpose()
df = pd.DataFrame(data,columns=['n values','chimin'])
df.to_csv('rescue.csv')

# plt.figure()
# plt.plot(n_values,red_chi)
# plt.xlabel('fixed N')
# plt.ylabel('redchi min')

#Best fit
hillEQ_model = lm.Model(hillEQ)
hillEQ_params = hillEQ_model.make_params(kd=1,sat=1)
hillEQ_params['kd'].set(value=1,vary=True,min=0)
hillEQ_params['n'].set(value=1.99,vary=True,min=1,max=6)
resultEQ = hillEQ_model.fit(y,x=x, params=hillEQ_params,weights=1/yerr)
print(resultEQ.fit_report())
# resultEQ.plot()
xmodel = np.linspace(x.min(),x.max(),100)
ymodel = hillEQ_model.eval(x=xmodel,params=resultEQ.params)
plt.figure()
plt.errorbar(x,y,yerr=yerr,marker='o',linestyle='')
plt.plot(xmodel,ymodel)

dely = resultEQ.eval_uncertainty(x=x)
# plt.plot(x, y)
# plt.plot(x, resultEQ.best_fit)
# plt.fill_between(x, resultEQ.best_fit-dely,resultEQ.best_fit+dely, color='#888888')

#Normalizando

ynorm = y/y[-1]
ynorm_err = np.sqrt(yerr**2/y[-1]**2+y**2*yerr[-1]**2/y[-1]**4)
ylog = np.log(ynorm/(1-ynorm))
ylog_err = np.sqrt(ynorm_err**2/((-1+ynorm)**2*ynorm**2))
ylog = ylog[1:-1]
ylog_err = ylog_err[1:-1]
xlog = np.log(x[1:-1])
lmodel = lm.models.LinearModel()
lmodel_params = lmodel.make_params(slope=2,b=0)
result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params,weights=1/ylog_err)
# result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params)
print(result_log.fit_report())

xmodel = np.linspace(xlog.min(),xlog.max(),100)
ymodel = lmodel.eval(x=xmodel,params=result_log.params)

plt.figure()
plt.title('LogLog')
plt.errorbar(xlog,ylog,yerr=ylog_err,marker='o',linestyle='')
plt.plot(xmodel,ymodel)

chi_min = []
red_chi = []
n_values = np.linspace(1,4,200)
for n in n_values:
    lmodel_params = lmodel.make_params(b=0)
    lmodel_params['slope'].set(value=n,vary=False)
    result_log = lmodel.fit(ylog,x=xlog, params=lmodel_params,weights=1/ylog_err)
    chi_min.append(result_log.chisqr)

plt.figure()
plt.title('Slope')
plt.plot(n_values,chi_min)
plt.xlabel('fixed N')
plt.ylabel('chisqr min')