'''
Load each iteration's csv file and then combine them, saving them into a json file
Check if between two VPace signals there exists more than one VPace signal, if so, it is not consecutive

'''
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import json

def get_list_from_file(filename):	
	with open(filename) as f:
		series= f.read()

	series= [int(s) for s in series.split('\n') if s!= '']
	#print(len(series))

	return series

def get_signals_list(va, vp):
	# %One can tell if a rhythm hijack has occured, if between two VPace signals,
	# %there are more than on SA signal. A signal is a contiguous set of 1s, and
	# %the space is the zero in between.


	# %So 1) is to get the windows between VA pulses, and 2)is to get the number
	# %of signals between each pulse, and 3) is to calculate the number of
	# %contiguous pulses within each window



	#sa= get_list_from_file('%s_SA.csv' % sim_num)

	print('va: %s/%s' % (va.count(1), len(va)))
	print('vp: %s/%s' % (vp.count(1), len(vp)))

	signal_list= []
	signal_in_period= 0

	if (vp.count(1) == 0):
		return [0]*len(va)
	else:
		for t in range(0,len(va)):
			if (va[t]==1):
				signal_in_period+= 1

			if (vp[t]==1 and (t+1 <= len(vp) or vp[t+1]== 0)): #if this is a 1 at the end of 1s, or the very end
				#print(signal_in_period)
				signal_in_period= 0 #resetting
				#signal_list.append(signal_in_period) #adding to the period between beats

			signal_list.append(signal_in_period) #making there be one beat per timestamp

		#print(signal_list)
		return signal_list


def plot(name, va, vp, sig):
	# Data for plotting

	t= range(0, len(va)) 

	plt.subplot(3, 1, 1)
	plt.plot(t, va, '-')
	plt.title('Single simulation')
	plt.ylabel('VA')

	plt.subplot(3, 1, 2)
	plt.plot(t, vp, '-')
	plt.ylabel('VP')

	plt.subplot(3, 1, 3)
	plt.plot(t, sig, '-')
	plt.ylabel('Consecutive VP')
	plt.xlabel('Timestamp')


	#plt.show()
	plt.savefig('%s_single_run.png' %name, figsize=(2,1), dpi=300)
	plt.clf()

def plot_final(save_name, va_series, vp_series, sig_series):

	save_dict= {
		'va': va_series,
		'vp': vp_series,
		'sig': sig_series,
	}

	with open('%s.json' % save_name, 'w') as f:
		json.dump(save_dict,f)

	# Data for plotting

	t= list(range(0, len(va_series)))
	print('t count in final: %s' % t)

	plt.subplot(3, 1, 1)
	plt.plot(t, va_series, '-')
	plt.title('All simulations')
	plt.ylabel('VA count')

	plt.subplot(3, 1, 2)
	plt.plot(t, vp_series, '-')
	plt.ylabel('VP count')

	plt.subplot(3, 1, 3)
	plt.plot(t, sig_series, '-')
	plt.ylabel('Max consecutive VP')
	plt.xlabel('Simulation number')


	#plt.show()
	plt.savefig('%s_total_run.png'%save_name, figsize=(2,1), dpi=300)


if __name__=='__main__':
	va_series= []
	vp_series= []
	max_sig_series= []

	name= '100'

	for sim_num in range(1,101):
		va= get_list_from_file('%s_VA.csv' % sim_num)
		vp= get_list_from_file('%s_VP.csv' % sim_num)
		sig= get_signals_list(va, vp)

		if (max(sig) >= 2):
			plot(name, va, vp, sig)

		va_series.append(va.count(1))
		vp_series.append(vp.count(1))
		max_sig_series.append(max(sig))

	plot_final(name, va_series, vp_series, max_sig_series)