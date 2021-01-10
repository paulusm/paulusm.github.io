# Pocket Archive Exploration


```python
import pandas as pd 
import seaborn as sns
import datetime
import matplotlib.pyplot as plt
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
fig, h = plt.subplots(figsize = (18,9))
h = sns.histplot(data=articles, x='yearmonth', color='purple', binwidth=10, stat='count')
#h.setp(plot.get_xticklabels(), rotation=90)
h
```




    <AxesSubplot:xlabel='yearmonth', ylabel='Count'>




    
![svg](pocket-analysis_files/pocket-analysis_8_1.svg)
    



```python

```
