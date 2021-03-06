# Pocket Archive Exploration


```python
import pandas as pd 
import seaborn as sns
import datetime
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy
import itertools
import networkx as nx
sns.set_style('whitegrid')

```

## Load and Munge


```python

articles = pd.read_csv('data/articles.csv')
print(len(articles), " articles imported")
print(articles.dtypes)
```

    2786  articles imported
    title        object
    link         object
    dateadded     int64
    tags         object
    dtype: object



```python

plt.rcParams['figure.figsize'] = (20,10)
plt.rcParams["axes.labelsize"] = 16
sns.set_context("talk")
```


```python
pocketrar = pd.read_csv('data/pr-log.csv')
prcount = len(pocketrar)
pocketrar['cumulative'] = prcount - pocketrar['id']
print(prcount, " reading log records imported")
print(pocketrar.dtypes)
print(pocketrar.groupby('type')['id'].count())


```

    1450  reading log records imported
    id             int64
    type          object
    dateadded     object
    cumulative     int64
    dtype: object
    type
    added         79
    archived    1371
    Name: id, dtype: int64



```python
pocketrar.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>type</th>
      <th>dateadded</th>
      <th>cumulative</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>added</td>
      <td>2020-08-15 10:42:40</td>
      <td>1449</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>added</td>
      <td>2020-08-15 11:03:57</td>
      <td>1448</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>added</td>
      <td>2020-08-15 11:09:06</td>
      <td>1447</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>archived</td>
      <td>2020-08-15 11:10:22</td>
      <td>1446</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>archived</td>
      <td>2020-08-15 13:03:03</td>
      <td>1445</td>
    </tr>
  </tbody>
</table>
</div>




```python
articles["yearmonth"] = pd.to_datetime(articles["dateadded"], unit='s').dt.strftime('%Y')
articles.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>title</th>
      <th>link</th>
      <th>dateadded</th>
      <th>tags</th>
      <th>yearmonth</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Using Artificial Intelligence to Augment Human...</td>
      <td>https://distill.pub/2017/aia/</td>
      <td>1610232618</td>
      <td>ai,cognition,extended mind,hci</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Reinforcement Q-Learning from Scratch in Pytho...</td>
      <td>https://www.learndatasci.com/tutorials/reinfor...</td>
      <td>1610203505</td>
      <td>machine learning,re-read,reinforcement learning</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>2</th>
      <td>The Building Blocks of Interpretability</td>
      <td>https://distill.pub/2018/building-blocks/</td>
      <td>1610114179</td>
      <td>dataviz,deep learning,interpretability,visuali...</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>3</th>
      <td>From Word Embeddings to Pretrained Language Mo...</td>
      <td>https://towardsdatascience.com/from-word-embed...</td>
      <td>1610091071</td>
      <td>ir,nlp,text mining</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>4</th>
      <td>http://www.ted.com/talks/joshua_prager_wisdom_...</td>
      <td>http://www.ted.com/talks/joshua_prager_wisdom_...</td>
      <td>1610090807</td>
      <td>aging,writers</td>
      <td>2021</td>
    </tr>
  </tbody>
</table>
</div>



## Articles By Year

This is misleading as it looks like that any article with tags edited was added in 2020 - actually those ones would be spread out over previous years..


```python
#fig, h = plt.subplots(figsize = (18,9))
h = sns.histplot(data=articles, x='yearmonth', color='purple', binwidth=10, stat='count')
#h.setp(plot.get_xticklabels(), rotation=90)

```


    
![svg](pocket-analysis_files/pocket-analysis_9_0.svg)
    


## Burn Through

This is how I progressed once I decided to attack the backlog in summer 2020 and set up [PocketRAR](https://github.com/danielskowronski/pocket.rar) to give me random articles from the collection.


```python
#fig, b = plt.subplots(figsize = (18,9))
pocketrar['day'] = pd.to_datetime(pocketrar['dateadded']).dt.strftime('%Y-%m-%d')
prmeans = pocketrar.groupby('day').mean('cumulative')
b = sns.lineplot(data=prmeans, x='day', y = 'cumulative', color='purple', linewidth = 3)
b.xaxis.set_major_locator(ticker.MultipleLocator(14))
#b.fig.autofmt_xdate()
#b.setp(pd.get_xticklabels(), rotation=90)


```


    
![svg](pocket-analysis_files/pocket-analysis_11_0.svg)
    


## Tags and Tag Network


```python
alltags = {}
tagpairs = {}
for i, row in articles.iterrows():
    tagset = row['tags']
    if tagset is not numpy.nan:
        tagset = tagset.split(',')
        for tag in tagset:
            if tag in alltags.keys():
                alltags[tag] = alltags[tag] + 1
            else:
                alltags[tag] = 1
        tagpairscmb = itertools.combinations(tagset,2)
        for tagpair in tagpairscmb:
            if tagpair in tagpairs.keys():
                tagpairs[tagpair] =  tagpairs[tagpair] +1
            else:
                tagpairs[tagpair] = 1
        

print(len(alltags), ' unique tags')
print(len(tagpairs), ' pairs')
```

    498  unique tags
    1313  pairs



```python
alltagsorted = sorted(alltags, key=alltags.__getitem__, reverse=True)
for i in range(0,6):
    print(alltagsorted[i], alltags[alltagsorted[i]])
```

    ux 88
    data science 65
    ai 51
    philosophy 49
    psychology 44
    science 43



```python
alltagpairssorted = sorted(tagpairs, key=tagpairs.__getitem__, reverse=True)
for i in range(0,6):
    print(alltagpairssorted[i], tagpairs[alltagpairssorted[i]])
```

    ('data science', 'talisable') 12
    ('smws', 'social media') 9
    ('algorithms', 'bias') 8
    ('self-improvement', 'sketchnotable') 8
    ('deep learning', 'ml') 7
    ('nlp', 'text mining') 6



```python
tagsG = nx.Graph()
tagnodes_export = [(k ,{'weight':v}) for k, v in alltags.items()]
#print(tagnodes_export)
tagsG.add_nodes_from(tagnodes_export)
tagpairs_export = [k + (v,) for k, v in tagpairs.items()]
tagsG.add_weighted_edges_from(tagpairs_export)
#print(tagpairs_export)
print(f'Nodes: {tagsG.number_of_nodes()}, Edges: {tagsG.size()}')
nx.write_gexf(tagsG, "data/tags.gexf")

```

    Nodes: 498, Edges: 1313


![taggraph](pocket-analysis_files/taggraph.svg)


```python

```
