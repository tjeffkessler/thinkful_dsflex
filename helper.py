#This file contains functions to be used in the analysis of NFL punt data for the 2016 and 2017 seasons.
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from collections import Counter, OrderedDict


def num_category(df, col, name):
    ''' Assign a number based on unique string values within a column to use for histogram, create a dictionary to use 
    to label those numbers on the histogram x-axis.
    :param df: data frame, dataframe to operate on
    :param col: str, existing dataframe column to categorize
    :param name: str, name for new column with numerical categories'''
    unq = np.unique(df[col]) 
    df[name] = [list(unq).index(v) for v in df[col]]
    key_dict = {k:v for k, v in enumerate(unq)}
    return df, key_dict

def standardize_weather(gamedata_df):
    nw = {}
    for value in gamedata_df.GameWeather.unique():
        s = str(value).lower()
        if 'snow' in s:
            nw[value] = 'snow'
        elif 'rain' in s or 'shower' in s and 'chance' not in s and 'possible' not in s:
            nw[value] = 'rain'
        elif 'cold' in s:
            nw[value] = 'cold'
        elif 'wind' in s or 'gust' in s:
            nw[value] = 'windy'
        elif 'sun' in s or 'clear' in s:
            nw[value] = 'pleasant'
        elif 'storm' in s:
            nw[value] = 'stormy'
        elif 'hot' in s:
            nw[value] = 'hot'
        elif 'fog' in s or 'haz' in s:
            nw[value] = 'reduced visibility'
        elif 'indoor' in s or 'control' in s:
            nw[value] ='indoor'
        elif 'unknown' in s:
            continue
        else:
            nw[value] = 'cloudy/mixed'

    gamedata_df['GameWeather'].replace(nw.keys(), nw.values(), inplace=True)

    return gamedata_df

def standardize_turf(gamedata_df):
    nw = {}
    for value in gamedata_df.Turf.unique():
        t = str(value).lower()
        if 'grass' in t or 'nat' in t:
            nw[value] = 'grass'
        elif 'turf' in t:
            nw[value] = 'turf'
        elif 'art' in t or 'syn' in t:
            nw[value] = 'artificial'
        elif 'ubu' in t:
            nw[value] = 'ubu_speed'
        else:
            nw[value] = 'other'

    gamedata_df['Turf'].replace(nw.keys(), nw.values(), inplace=True)

    return gamedata_df

def standardize_role_groups(player_role_df):
    nw = {}
    for value in player_role_df.Role.unique():
        s = str(value).lower()
        if 'v' in s:
            nw[value] = 'Return Jammers'
        elif s == 'plt' or s == 'plg' or s == 'pls' or s=='prg' or s=='prt':
            nw[value] = 'Punt Line'
        elif 'g' in s:
            nw[value] = 'Punt Gunners'
        elif s == 'p':
            nw[value] = 'Punter'
        elif 'w' in s or 'c' in s or 'pp' in s:
            nw[value] = 'Punt Backfield'
        elif 'pd' in s:
            nw[value] = 'Return Line'
        elif 'fb' in s  or s ==  'pr':
            nw[value] = 'Returners'
        else:
            nw[value] = 'Return LBs'
        
    player_role_df['Group'] = player_role_df['Role'].replace(nw.keys(), nw.values(), inplace=False)

    return player_role_df
	
def compare_hists(x1, x2, label1=None, label2=None, title1=None, title2=None, figsize=(10, 5)):
    '''Create a plot with subplots of histograms for comparison
    :param x: series or array-like, data to be plotted
    :param label: series or list, labels for the data
    :param title: string, values to fill in plot titles
    :param figsize: tuple, length and height of plot'''
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=figsize)
    
    
    ax1.hist(x1, density=True)
    
    #If a label argument is passed, set the xtick labels vertically
    if label1:
        ax1.set_xticks(range(len(label1)))
        ax1.set_xticklabels(label1, rotation='vertical')
    
    #If the data is not string type, set x limits
    if x1.dtype != 'object':
        x_min, x_max = min(x1), max(x1)
        ax1.set_xlim(x_min, x_max)
        
    ax1.set_title('2016/17 Punts by {}'.format(title1))
    
    ax2.hist(x2, density=True, color='r')
    
    #If a label argument is passed, set the xtick labels vertically
    if label2:
        ax2.set_xticks(range(len(label2)))
        ax2.set_xticklabels(label2, rotation='vertical')
        
    #If the data is not string type, set x limits
    if x2.dtype != 'object':
        ax2.set_xlim(x_min,  x_max)
        
    ax2.set_title('2016/17 Punts by {}'.format(title2))
    
    return plt.show()

def get_percentages(data):
    '''Take a frequency count from array-like data and create a sorted, ordered dictionary of percentages
    :param data: Pandas Series or array-like, the data from which to count frequency'''
    l = len(data)
    ddict = dict(Counter(list(data)))
    ddict.update((k, v/l) for k, v in ddict.items())
    ddict = OrderedDict(sorted(ddict.items()))
    return ddict