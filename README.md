# user-21

Demo for the useR! 2021 conference talk:

> Open the Machine Learning Black-Box with modelStudio & Arena [[video on YouTube]](https://www.youtube.com/watch?v=tiR9ClOEaqM)

Find a modelStudio demo at https://hbaniecki.github.io/user-21

Find an Arena demo [at this URL](http://arena.drwhy.ai/?data=https://gist.githubusercontent.com/hbaniecki/cd968d512b803549397db1695fcd0be8/raw/292784bd92d634481236e43c592fd9f5abca28b8/arena_happiness.json).

## What factors correlate with happiness at national level?

1. Get data about happiness from 
https://www.kaggle.com/unsdsn/world-happiness

2. Train your favorite ML model that will predict the happiness score

3. Explain the model with [modelStudio](https://github.com/ModelOriented/modelStudio)

```r
library("DALEX")
library("modelStudio")
library("ranger")

# load data
happiness <- readRDS("happiness.rds")

# fit a model
model <- ranger(score~., data = happiness)

# create an explainer for the model  
explainer <- explain(model, data = happiness[,-1], y = happiness$score)

# make a Studio for the model
ms <- modelStudio(explainer,
                  happiness[c("Poland", "Finland", "Germany"),],
                  options = ms_options(margin_left = 220))
                  
# explain!
ms
```

4. Compare multiple models with [Arena](https://arena.drwhy.ai/docs/)

```r
library("DALEX")
library("arenar")
library("ranger")
library("gbm")

# load data
happiness <- readRDS("happiness.rds")

# fit models
model_rf <- ranger(score~., data = happiness)
model_gbm <- gbm(score~., data = happiness)

# create explainers for the models
explainer_rf <- explain(model_rf,
                        data = happiness[,-1],
                        y = happiness$score)
explainer_gbm <- explain(model_gbm,
                         data = happiness[,-1],
                         y = happiness$score)

# choose observations to be explained
observations <- happiness[1:10, ]

# make an Arena for the models
library("tidyr", quietly=TRUE, warn.conflicts = FALSE)
arena <- create_arena(live=TRUE) %>%
  push_model(explainer_rf) %>%
  push_model(explainer_gbm) %>%
  push_observations(observations)

# explain!
run_server(arena)
```

![Arena](docs/arena.png)

You can upload an Arena demo at http://arena.drwhy.ai/?app using [the following URL to data](https://gist.githubusercontent.com/hbaniecki/cd968d512b803549397db1695fcd0be8/raw/292784bd92d634481236e43c592fd9f5abca28b8/arena_happiness.json) or [by downloading the data from GitHub](https://github.com/hbaniecki/user-21/blob/main/workshop/arena_happiness.json).

![upload](docs/upload.png)
