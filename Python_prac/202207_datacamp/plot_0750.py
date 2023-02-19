#!/usr/bin/env python
# coding: utf-8

# ### Installation of Matplotlib
# ### pip install matplotlib
# ### 시각화를 위한 파이썬 라이브러리

# In[1]:


get_ipython().system('pip install matplotlib')


# In[4]:


get_ipython().system('dir')


# In[9]:


import matplotlib

print(matplotlib.__version__)


# In[10]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0, 6])
ypoints = np.array([0, 250])

plt.plot(xpoints, ypoints)
plt.show()


# In[12]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2, 4,  6])
ypoints = np.array([0,8, 120, 250])

plt.plot(xpoints, ypoints)
plt.show()


# In[19]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2, 4,  6])
ypoints = np.array([0,8, 120, 250])

plt.plot(xpoints, ypoints, '>b')
plt.show()


# In[22]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2,4,6])
ypoints = np.array([0,8,120,250])

plt.xlabel('x axis')
plt.ylabel('y axis')
plt.title('matplotlib sample')
plt.plot(xpoints, ypoints)
plt.show()


# In[23]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2,4,6])
ypoints = np.array([0,8,120,250])

plt.xlim(-2, 9)
plt.ylim(0,300)
plt.xlabel('x axis')
plt.ylabel('y axis')
plt.title('matplotlib sample')
plt.plot(xpoints, ypoints)
plt.show()


# In[27]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.arange(1,10,0.1)
ypoints1 = xpoints*0.2
ypoints2 = np.sin(xpoints)

plt.plot(xpoints, ypoints1)
plt.plot(xpoints, ypoints2)
plt.show()


# In[30]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.arange(1,10,0.1)
ypoints1 = xpoints*0.2
ypoints2 = np.sin(xpoints)

plt.plot(xpoints, ypoints1, label='first')
plt.plot(xpoints, ypoints2, label='second')
plt.legend(loc='upper right')
plt.show()


# In[31]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.arange(1,10,0.1)
ypoints1 = xpoints*0.2
ypoints2 = np.sin(xpoints)

plt.plot(xpoints, ypoints1, label='first')
plt.plot(xpoints, ypoints2, label='second')
plt.annotate('annotate',xy=(2,1),xytext=(4,1.5),arrowprops={'color':'green'})

plt.show()


# In[33]:


from matplotlib import pyplot as plt
import numpy as np

x = np.arange(1,10)
y1 = x*5
y2 = x*1
y3 = x*0.3
y4 = x*0.2

plt.subplot(1,2,1)
plt.plot(x,y1)
plt.subplot(1,2,2)
plt.plot(x,y2)

plt.show()


# In[34]:


from matplotlib import pyplot as plt
import numpy as np

x = np.arange(1,10)
y1 = x*5
y2 = x*1
y3 = x*0.3
y4 = x*0.2

plt.subplot(2,1,1)
plt.plot(x,y1)
plt.subplot(2,1,2)
plt.plot(x,y2)

plt.show()


# In[35]:


from matplotlib import pyplot as plt
import numpy as np

x = np.arange(1,10)
y1 = x*5
y2 = x*1
y3 = x*0.3
y4 = x*0.2

plt.subplot(2,2,1)
plt.plot(x,y1)
plt.subplot(2,2,2)
plt.plot(x,y2)
plt.subplot(2,2,3)
plt.plot(x,y3)
plt.subplot(2,2,4)
plt.plot(x,y4)

plt.show()


# In[36]:


from matplotlib import pyplot as plt
import numpy as np

x = np.arange(1,10)
y1 = x*5
y2 = x*1
y3 = x*0.3
y4 = x*0.2

plt.figure(figsize=(20,5))
plt.subplot(2,2,1)
plt.plot(x,y1)
plt.subplot(2,2,2)
plt.plot(x,y2)
plt.subplot(2,2,3)
plt.plot(x,y3)
plt.subplot(2,2,4)
plt.plot(x,y4)

plt.show()


# In[37]:


import matplotlib.pyplot as plt
import numpy as np

ypoints = np.array([3, 8, 1, 10])

plt.plot(ypoints, marker = 'o', ms = 20)
plt.show()


# In[38]:


import matplotlib.pyplot as plt
import numpy as np

ypoints = np.array([3, 8, 1, 10])

plt.plot(ypoints, marker = 'o', ms = 20, mec = 'r')
plt.show()


# In[39]:


import matplotlib.pyplot as plt
import numpy as np

ypoints = np.array([3, 8, 1, 10])

plt.plot(ypoints, marker = 'o', ms = 20, mfc = 'r')
plt.show()


# In[40]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2,4,6])
ypoints = np.array([0,8,120,250])

plt.xlabel('x axis')
plt.ylabel('y axis')
plt.title('matplotlib sample')
plt.plot(xpoints, ypoints)
plt.grid()
plt.show()


# In[43]:


import matplotlib.pyplot as plt
import numpy as np

xpoints = np.array([0,2,4,6])
ypoints = np.array([0,8,120,250])

plt.xlabel('x axis')
plt.ylabel('y axis')
plt.title('matplotlib sample')
plt.plot(xpoints, ypoints)
plt.grid(color = 'red', linestyle = '--', linewidth = 0.2)
plt.show()


# In[44]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array([5,7,8,7,2,17,2,9,4,11,12,9,6])
y = np.array([99,86,87,88,111,86,103,87,94,78,77,85,86])
plt.scatter(x, y)

x = np.array([2,2,8,1,15,8,12,9,7,3,11,4,7,14,12])
y = np.array([100,105,84,105,90,99,90,95,94,100,79,112,91,80,85])
plt.scatter(x, y)

plt.show()


# In[45]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array([5,7,8,7,2,17,2,9,4,11,12,9,6])
y = np.array([99,86,87,88,111,86,103,87,94,78,77,85,86])
colors = np.array(["red","green","blue","yellow","pink","black","orange","purple","beige","brown","gray","cyan","magenta"])

plt.scatter(x, y, c=colors)

plt.show()


# In[49]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array([5,7,8,7,2,17,2,9,4,11,12,9,6])
y = np.array([99,86,87,88,111,86,103,87,94,78,77,85,86])
colors = np.array([0, 10, 20, 30, 40, 45, 50, 55, 60, 70, 80, 90, 100])

plt.scatter(x, y, c=colors, cmap='BuPu')

plt.colorbar()

plt.show()


# In[48]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array([5,7,8,7,2,17,2,9,4,11,12,9,6])
y = np.array([99,86,87,88,111,86,103,87,94,78,77,85,86])
sizes = np.array([20,50,100,200,500,1000,60,90,10,300,600,800,75])

plt.scatter(x, y, s=sizes)

plt.show()


# In[50]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array([5,7,8,7,2,17,2,9,4,11,12,9,6])
y = np.array([99,86,87,88,111,86,103,87,94,78,77,85,86])
sizes = np.array([20,50,100,200,500,1000,60,90,10,300,600,800,75])

plt.scatter(x, y, s=sizes, alpha=0.5)

plt.show()


# In[51]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array(["A", "B", "C", "D"])
y = np.array([3, 8, 1, 10])

plt.bar(x,y)
plt.show()


# In[52]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array(["A", "B", "C", "D"])
y = np.array([3, 8, 1, 10])

plt.barh(x, y)
plt.show()


# In[53]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array(["A", "B", "C", "D"])
y = np.array([3, 8, 1, 10])

plt.bar(x, y, color = "red")
plt.show()


# In[54]:


import matplotlib.pyplot as plt
import numpy as np

x = np.array(["A", "B", "C", "D"])
y = np.array([3, 8, 1, 10])

plt.bar(x, y, width = 0.1)
plt.show()


# In[61]:


from numpy import random

x = random.normal(loc=100, scale=9, size=100)
plt.hist(x)
print(x)


# In[62]:


import matplotlib.pyplot as plt
import numpy as np

y = np.array([35, 25, 25, 15])

plt.pie(y)
plt.show() 


# In[63]:


import matplotlib.pyplot as plt
import numpy as np

y = np.array([35, 25, 25, 15])
mylabels = ["Apples", "Bananas", "Cherries", "Dates"]

plt.pie(y, labels = mylabels)
plt.show() 


# In[67]:


import matplotlib.pyplot as plt
import numpy as np

y = np.array([35, 125, 55, 15])
mylabels = ["Apples", "Bananas", "Cherries", "Dates"]
myexplode = [0.3, 0, 0, 0]

plt.pie(y, labels = mylabels, explode = myexplode)
plt.show() 


# In[70]:


import matplotlib.pyplot as plt
import numpy as np

y = np.array([35, 25, 25, 15])
mylabels = ["Apples", "Bananas", "Cherries", "Dates"]

plt.pie(y, labels = mylabels)
plt.legend(title = "Four Fruits:")
plt.show() 


# In[71]:


import matplotlib.pyplot as plt
import numpy as np

plt.style.use('_mpl-gallery')

# make data:
np.random.seed(10)
D = np.random.normal((3, 5, 4), (1.25, 1.00, 1.25), (100, 3))

# plot
fig, ax = plt.subplots()
VP = ax.boxplot(D, positions=[2, 4, 6], widths=1.5, patch_artist=True,
                showmeans=False, showfliers=False,
                medianprops={"color": "white", "linewidth": 0.5},
                boxprops={"facecolor": "C0", "edgecolor": "white",
                          "linewidth": 0.5},
                whiskerprops={"color": "C0", "linewidth": 1.5},
                capprops={"color": "C0", "linewidth": 1.5})

ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
       ylim=(0, 8), yticks=np.arange(1, 8))

plt.show()

